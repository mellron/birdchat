' Assumes:
'  - Enums AccrualBasis, AmortizationType, PaymentFrequency already defined.
'  - Fields: _requestedRateDate As Date, _currencyCode As String, _incrementalRate As Double, _rateDate As Date
'  - Method IRR(cashflows() As Double, guess As Double) As Double exists (monthly IRR).

Protected Function CalculateGeneric360_V2(ByVal curveName As String,
                                          ByVal term As Integer,
                                          ByVal amort As Integer,
                                          ByVal accBasis As AccrualBasis,
                                          ByVal amortType As AmortizationType,
                                          ByVal prinFreq As PaymentFrequency,
                                          ByVal intFreq As PaymentFrequency,
                                          ByVal residual As Double,
                                          ByVal interestOnly As Integer,
                                          Optional ByVal mosToFirstPrinPmt As Integer = 0,
                                          Optional ByVal mosToFirstIntPmt As Integer = 0) As Double
    Try
        '-----------------------------
        ' 1) Load curve, 1-based index
        '-----------------------------
        Dim cofRates(360) As Double               ' 1..360 usable
        Dim cb As New CurveBuilder()
        Dim dt As DataTable = cb.GetCurve(curveName, _requestedRateDate, _currencyCode)

        If dt Is Nothing OrElse dt.Rows.Count = 0 Then
            Throw New ApplicationException("Curve is empty.")
        End If

        _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())

        ' Load 1-based so cofRates(1) = month 1. Guard for up to 360 values.
        Dim maxPts As Integer = Math.Min(360, dt.Rows.Count)
        For i As Integer = 1 To maxPts
            cofRates(i) = Convert.ToDouble(dt.Rows(i - 1)("value"))
        Next

        If term < 1 OrElse term > maxPts Then
            Throw New ArgumentOutOfRangeException(NameOf(term), "Term must be between 1 and available curve length.")
        End If

        '-----------------------------------------
        ' 2) Frequency setup (principal scheduling)
        '    Interest is computed monthly regardless
        '-----------------------------------------
        Dim prinPmtAdd As Integer = 1             ' months between principal payments
        Dim prinFreqAdd As Integer = 0

        Select Case prinFreq
            Case PaymentFrequency.Monthly : prinPmtAdd = 1
            Case PaymentFrequency.Quarterly : prinPmtAdd = 3 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 3, 0)
            Case PaymentFrequency.SemiAnnual : prinPmtAdd = 6 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 6, 0)
            Case PaymentFrequency.Annual : prinPmtAdd = 12 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 12, 0)
            Case PaymentFrequency.AtMaturity : prinPmtAdd = term
        End Select

        '-----------------------------------------
        ' 3) Initialize arrays (normalized to 100)
        '-----------------------------------------
        Dim outPrin(term) As Double
        Dim prinPmt(term) As Double
        Dim intPmtMonthly(term) As Double         ' shadow monthly interest (for amort math)
        Dim monInt(term) As Double                ' monthly funding cost component (per principal paid in that month)
        Dim cumInt(term) As Double
        Dim cofPmt(term) As Double

        outPrin(0) = 100.0
        cofPmt(0) = -outPrin(0)

        ' Coupon = curve at "term" plus any incremental spread
        Dim intRate As Double = cofRates(term) + _incrementalRate
        Dim r_m As Double = intRate / 12.0

        '-----------------------------------------
        ' 4) Compute PMT and monthly "shadow" principal
        '    (interestOnly months have zero principal)
        '-----------------------------------------
        Dim pmt As Double = 0.0
        Select Case amortType
            Case AmortizationType.Equal
                Dim nper As Integer = Math.Max(0, amort - interestOnly)
                If nper > 0 Then
                    pmt = Financial.Pmt(r_m, nper, -outPrin(0), outPrin(0) * residual, 0)
                Else
                    pmt = 0.0
                End If

            Case AmortizationType.Linear
                Dim nper As Integer = Math.Max(0, amort - interestOnly)
                If nper > 0 Then
                    ' Constant monthly principal during amort window
                    pmt = 0.0 ' will compute principal directly; pmt not used for linear
                Else
                    pmt = 0.0
                End If

            Case AmortizationType.Bullet
                pmt = 0.0
        End Select

        ' First scheduled principal month
        Dim nextPrinMonth As Integer = Math.Max(1, Math.Min(term, interestOnly + Math.Max(1, prinPmtAdd) + prinFreqAdd))

        ' Accumulator for principal between principal due dates
        Dim accPrin As Double = 0.0

        For month As Integer = 1 To term
            ' --- Monthly interest for amort math (always monthly) ---
            intPmtMonthly(month) = r_m * outPrin(month - 1)

            ' --- Monthly principal (shadow) ---
            Dim monthlyPrin As Double = 0.0
            If month > interestOnly Then
                Select Case amortType
                    Case AmortizationType.Equal
                        monthlyPrin = Math.Max(0.0, pmt - intPmtMonthly(month))
                    Case AmortizationType.Linear
                        Dim nper As Integer = Math.Max(0, amort - interestOnly)
                        If nper > 0 AndAlso (month - interestOnly) <= nper Then
                            monthlyPrin = outPrin(0) * (1.0 - residual) / nper
                        Else
                            monthlyPrin = 0.0
                        End If
                    Case AmortizationType.Bullet
                        monthlyPrin = 0.0
                End Select
            End If

            ' Accumulate monthly principal until a principal due month
            accPrin += monthlyPrin

            ' If this is a principal payment month, book the accumulated principal
            If month = nextPrinMonth OrElse (prinFreq = PaymentFrequency.AtMaturity AndAlso month = term) Then
                prinPmt(month) = accPrin
                accPrin = 0.0
                nextPrinMonth = Math.Min(term, month + prinPmtAdd)
            End If

            ' Force full payoff at final term
            If month = term Then
                ' Whatever is still outstanding is paid now
                prinPmt(month) = Math.Max(prinPmt(month), outPrin(month - 1))
            End If

            ' Update outstanding principal only when principal is actually paid
            If month = term Then
                outPrin(month) = 0.0
            Else
                outPrin(month) = outPrin(month - 1) - prinPmt(month)
            End If

            ' --- Monthly funding cost component for the principal paid this month ---
            ' Apply day-count inside (Excel-equivalent)
            Dim dayCountFactor As Double = If(accBasis = AccrualBasis.ActThreeSixty, 360.0 / 365.0, 1.0)
            Dim curve_m As Double = cofRates(Math.Min(month, maxPts)) ' guard index
            monInt(month) = curve_m * (1.0 / 12.0) * dayCountFactor * prinPmt(month)
        Next

        '-----------------------------------------
        ' 5) Build cash flows for IRR
        '    cofPmt(i) = principal paid at i + cumulative funding cost from i..term
        '-----------------------------------------
        For i As Integer = 1 To term
            Dim s As Double = 0.0
            For n As Integer = i To term
                s += monInt(n)
            Next
            cumInt(i) = s
            cofPmt(i) = prinPmt(i) + cumInt(i)
        Next

        '-----------------------------------------
        ' 6) Compute COF (monthly IRR × 12). No remapping by intFreq.
        '-----------------------------------------
        Dim guess As Double = Math.Max(0.0000001, cofRates(term))
        Dim cofRate As Double = IRR(cofPmt, guess / 12.0) * 12.0

        Return cofRate

    Catch ex As Exception
        Dim msg = String.Format("Exception in {0}.{1}(): {2}",
                                (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name,
                                (New StackTrace()).GetFrame(0).GetMethod().Name,
                                ex.Message)
        App.EventLog.LogException(msg, ex.StackTrace)
        Throw
    End Try
End Function
