
'*****************************************************************************
'BSD Rate Business project
'Copyright © 2011 U.S. Bancorp
'This source file contains the base class for the BSD Rate Calculators.
' ==============================================================================
'
'Used By: BSD Rate
'
'Created by: jrhald
'Created when: 10/17/2011
'Modifications:
'
'Date       By              Reason/What changed
'--------   ---------       -------------------
'1/24/2012  D. Weeks        Make _incrementalRate configurable in AppConfig (was hard-coded at 0.02)
'03/12/2012 D. Weeks        In CalculateConsumerCOF, the cpr value is already between 0 and 1
'04/19/2012 D. Weeks        If user specifies an irregular cash flow, and tries to calculate the COF
'                           without specifying the cash flow schedule, throw an exception
'04/16/13   jrhald          Added currency code so COFs can be calculated for currencies other than US.
'12/02/13   jrhald          Updated references to DataTable column collectiondate to CalculatedDate.
'06/30/14   jrhald          Added logging for exceptions for issue #565.
'12/10/14   jrhald          CalculatePrepaymentCOF() was accessing wrong element in ppCOFRates array.
'                           See issue #617.
'07/09/2025  detolle        TPP-7119 detolle - add CalculateCIP360 implementation
'*****************************************************************************/
Option Explicit On
Option Strict On

Imports System.Math

''' <summary>
''' This class serves as the base class for the various BSD rate calculators.
''' </summary>
''' <remarks>
''' Also see the <seealso>FTPRateCalculator</seealso>, <seealso>CIPRateCalculator</seealso>,
''' and <seealso>ALSRateCalculator</seealso> classes.
''' </remarks>
Public MustInherit Class Calculator
    ' Inputs
    Protected _requestedRateDate As Date ' Rate date requested by calling method.
    Protected _rateDate As Date ' Actual date of rates returned from database, which may differ.
    Protected _incrementalRate As Decimal       'Added to bullet rate to calculate COF
    Protected _currencyCode As String 'The currency for curve rates.

#Region "Enums"
    ''' <summary>
    ''' Represents the way in which interest is accrued on a loan.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum AccrualBasis
        ActThreeSixty = 1
        ThirtyThreeSixty = 2
        ActAct = 3
    End Enum

    ''' <summary>
    ''' Represents how cash flows amortize on a loan.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum AmortizationType
        Equal = 1
        Linear = 2
        Bullet = 3
        Irregular = 4
    End Enum

    ''' <summary>
    ''' The frequency at which payments are made on a loan.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum PaymentFrequency
        SemiMonthly = 1
        Monthly = 2
        Quarterly = 3
        SemiAnnual = 4
        Annual = 5
        AtMaturity = 6
    End Enum

    ''' <summary>
    ''' Represents the amount of the principal balance that can be prepaid each
    ''' year without additional cost.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum PrepaymentWaiver
        ZeroPercent = 1
        TenPercent = 2
        FifteenPercent = 3
        TwentyPercent = 4
        ThirtyPercent = 5
        Full = 6
    End Enum

    ''' <summary>
    ''' Represents the type of consumer loan.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum ConsumerLoanType
        FirstMortgage = 1
        HomeEquityFirst = 2
        HomeEquitySecond = 3
        ConsumerInstallment = 4
        Auto = 5
    End Enum
#End Region

    ''' <summary>
    ''' The one and only constructor.
    ''' </summary>
    ''' <param name="rateDate">The date to use for rates used in calculations.</param>
    ''' <remarks></remarks>
    Protected Sub New(ByVal rateDate As Date)
        Try
            ' We'll assume the rates we get will be for same date as requested.
            _requestedRateDate = rateDate
            _rateDate = rateDate
            _currencyCode = "USD"

            'Get the incfrement to add to the bullet rate
            Dim txt As String = String.Empty
            App.Connector.GetAppConfig("IncrementalRate", txt, "2.0")
            If Not Decimal.TryParse(txt, _incrementalRate) Then
                _incrementalRate = CDec(2.0)
            End If
            _incrementalRate = _incrementalRate / 100

        Catch ex As Exception
            ' Re-throw the exception for calling method to handle.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Sub
    ''' <summary>
    ''' Generic implementation for 360-point COF calculations based on the specified curve.
    ''' </summary>
    ''' <param name="curveName">The name of the 360-point curve to use (e.g. "FHLBCredit360", "CIP360").</param>
    ''' <param name="term">The length of the loan in months.</param>
    ''' <param name="amort">The length of time, in months, before the loan is fully amortized.</param>
    ''' <param name="accBasis">See <seealso>AccrualBasis</seealso> enum in Calculator.vb.</param>
    ''' <param name="amortType">See <seealso>AmortizationType</seealso> enum in Calculator.vb.</param>
    ''' <param name="prinFreq">See <seealso>PaymentFrequency</seealso> enum in Calculator.vb.</param>
    ''' <param name="intFreq">See <seealso>PaymentFrequency</seealso> enum in Calculator.vb.</param>
    ''' <param name="residual">The amount of loan left at the end of loan period, as a percentage.</param>
    ''' <param name="interestOnly">Number of months payments applied only to interest.</param>
    ''' <param name="mosToFirstPrinPmt">The number of months to first principal payment. Optional.</param>
    ''' <param name="mosToFirstIntPmt">The number of months to first interest payment. Optional.</param>
    ''' <returns>The cost of funds.</returns>
    Protected Function CalculateGeneric360(ByVal curveName As String,
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
            Dim cofRates(360) As Double
            Dim cb As New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve(curveName, _requestedRateDate, _currencyCode)
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())
                For i As Integer = 0 To dt.Rows.Count - 1
                    cofRates(i) = Convert.ToDouble(dt.Rows(i)("value"))
                Next
            End If

            Dim outPrin(term) As Double, prinPmt(term) As Double, intPmt(term) As Double
            Dim prinPmtDen As Integer, intPmtDen As Integer
            Dim prinPmtAdd As Integer, intPmtAdd As Integer
            Dim prinFreqAdd As Integer, intFreqAdd As Integer
            Dim pmt As Double, intRate As Double
            Dim monInt(term) As Double, cumInt(term) As Double, cofPmt(term) As Double

            Select Case prinFreq
                Case PaymentFrequency.Monthly : prinPmtDen = 1 : prinPmtAdd = 1
                Case PaymentFrequency.Quarterly : prinPmtDen = 3 : prinPmtAdd = 3 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 3, 0)
                Case PaymentFrequency.SemiAnnual : prinPmtDen = 6 : prinPmtAdd = 6 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 6, 0)
                Case PaymentFrequency.Annual : prinPmtDen = 12 : prinPmtAdd = 12 : prinFreqAdd = If(mosToFirstPrinPmt > 0, mosToFirstPrinPmt - 12, 0)
                Case PaymentFrequency.AtMaturity : prinPmtDen = 0 : prinPmtAdd = term
            End Select

            Select Case intFreq
                Case PaymentFrequency.Monthly : intPmtDen = 12 : intPmtAdd = 1
                Case PaymentFrequency.Quarterly : intPmtDen = 4 : intPmtAdd = 3 : intFreqAdd = If(mosToFirstIntPmt > 0, mosToFirstIntPmt - 3, 0)
                Case PaymentFrequency.SemiAnnual : intPmtDen = 2 : intPmtAdd = 6 : intFreqAdd = If(mosToFirstIntPmt > 0, mosToFirstIntPmt - 6, 0)
                Case PaymentFrequency.Annual : intPmtDen = 1 : intPmtAdd = 12 : intFreqAdd = If(mosToFirstIntPmt > 0, mosToFirstIntPmt - 12, 0)
                Case PaymentFrequency.AtMaturity : intPmtDen = 1 : intPmtAdd = term
            End Select

            outPrin(0) = 100 : cofPmt(0) = -outPrin(0)
            intRate = cofRates(term) + _incrementalRate

            Select Case amortType
                Case AmortizationType.Equal : pmt = Financial.Pmt(intRate / intPmtDen, (amort - interestOnly) / prinPmtDen, -outPrin(0), outPrin(0) * residual, 0)
                Case AmortizationType.Linear : pmt = Financial.Pmt(0, (amort - interestOnly) / prinPmtDen, -outPrin(0), outPrin(0) * residual, 0)
                Case AmortizationType.Bullet : pmt = 0
            End Select

            Dim nextPrinMonth As Integer = prinPmtAdd + interestOnly + prinFreqAdd
            Dim nextIntMonth As Integer = intPmtAdd + intFreqAdd

            For month As Integer = 1 To term
                If month = nextIntMonth Then
                    intPmt(month) = (intRate / intPmtDen) * outPrin(month - 1)
                    nextIntMonth = month + intPmtAdd
                End If

                If month = nextPrinMonth Then
                    Select Case amortType
                        Case AmortizationType.Equal : prinPmt(month) = pmt - intPmt(month)
                        Case AmortizationType.Linear : prinPmt(month) = pmt
                        Case AmortizationType.Bullet : prinPmt(month) = 0
                    End Select
                    nextPrinMonth = month + prinPmtAdd
                End If

                If month = term Then
                    prinPmt(month) = outPrin(month - 1) : outPrin(month) = 0
                Else
                    outPrin(month) = outPrin(month - 1) - prinPmt(month)
                End If

                monInt(month) = cofRates(month) * (30.0 / 360.0) * prinPmt(month)
            Next

            For i As Integer = 1 To term
                For n As Integer = i To term
                    cumInt(i) += monInt(n)
                Next
                cofPmt(i) = cumInt(i) + prinPmt(i)
            Next

            Dim guess As Double = cofRates(term)
            Dim cofRate As Double = IRR(cofPmt, guess / 12) * 12
            Select Case intFreq
                Case PaymentFrequency.Quarterly : cofRate = ((1 + cofRate / 12) ^ 3 - 1) * 4
                Case PaymentFrequency.SemiAnnual : cofRate = ((1 + cofRate / 12) ^ 6 - 1) * 2
                Case PaymentFrequency.Annual : cofRate = ((1 + cofRate / 12) ^ 12 - 1) * 1
                Case PaymentFrequency.AtMaturity : cofRate = ((1 + cofRate / 12) ^ term - 1) * (12.0 / term)
            End Select

            If accBasis = AccrualBasis.ActThreeSixty Then cofRate *= (360.0 / 365.0)
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

    ''' <summary>
    ''' Calculates the standard cost of funds using the FHLBCredit360 curve.
    ''' </summary>
    Protected Function CalculateFHLBCredit360(ByVal term As Integer, ByVal amort As Integer, ByVal accBasis As AccrualBasis,
                                              ByVal amortType As AmortizationType, ByVal prinFreq As PaymentFrequency,
                                              ByVal intFreq As PaymentFrequency, ByVal residual As Double, ByVal interestOnly As Integer,
                                              Optional ByVal mosToFirstPrinPmt As Integer = 0, Optional ByVal mosToFirstIntPmt As Integer = 0) As Double
        Return CalculateGeneric360("FHLBCredit360", term, amort, accBasis, amortType, prinFreq, intFreq, residual, interestOnly, mosToFirstPrinPmt, mosToFirstIntPmt)
    End Function

    ''' <summary>
    ''' Calculates the basic CIP360 cost of funds using the CIP360 curve.
    ''' TPP-7119 detolle 07/09/2025
    ''' </summary>
    Protected Function CalculateCIP360(ByVal term As Integer, ByVal amort As Integer, ByVal accBasis As AccrualBasis,
                                       ByVal amortType As AmortizationType, ByVal prinFreq As PaymentFrequency,
                                       ByVal intFreq As PaymentFrequency, ByVal residual As Double, ByVal interestOnly As Integer,
                                       Optional ByVal mosToFirstPrinPmt As Integer = 0, Optional ByVal mosToFirstIntPmt As Integer = 0) As Double
        Return CalculateGeneric360("CIP360", term, amort, accBasis, amortType, prinFreq, intFreq, residual, interestOnly, mosToFirstPrinPmt, mosToFirstIntPmt)
    End Function

    ''' <summary>
    ''' Calculates the standard cost of funds on a rate lock.
    ''' </summary>
    ''' <param name="term">The length of the loan in months.</param>
    ''' <param name="amort">The length of time, in months, before the loan is fully amortized.</param>
    ''' <param name="accBasis">See <seealso>AccrualBasis</seealso> enum in Calculator.vb.</param>
    ''' <param name="amortType">See <seealso>AmortizationType</seealso> enum in Calculator.vb.</param>
    ''' <param name="prinFreq">See <seealso>PaymentFrequency</seealso> enum in Calculator.vb.</param>
    ''' <param name="intFreq">See <seealso>PaymentFrequency</seealso> enum in Calculator.vb.</param>
    ''' <param name="residual">The amount of loan left at the end of loan period, as a percentage.</param>
    ''' <param name="interestOnly">Number of months payments applied only to interest.</param>
    ''' <param name="mosToFirstPrinPmt">The number of months to first principal payment. Optional.</param>
    ''' <param name="mosToFirstIntPmt">The number of months to first interest payment. Optional.</param>
    ''' <returns>The cost of funds.</returns>
    ''' <remarks></remarks>
    Protected Function CalculateStandardCOF(ByVal term As Integer, ByVal amort As Integer, ByVal accBasis As AccrualBasis, _
                                            ByVal amortType As AmortizationType, ByVal prinFreq As PaymentFrequency, _
                                            ByVal intFreq As PaymentFrequency, ByVal residual As Double, ByVal interestOnly As Integer, _
                                            Optional ByVal mosToFirstPrinPmt As Integer = 0, Optional ByVal mosToFirstIntPmt As Integer = 0) As Double
        Try
            Dim cofRates(360) As Double

            ' Get rate curve.
            Dim cb As CurveBuilder = New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve("L0P0BFULL", _requestedRateDate, _currencyCode)
            If (dt IsNot Nothing) AndAlso (dt.Rows.Count > 0) Then
                _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())
                For i As Integer = 0 To dt.Rows.Count - 1
                    cofRates(i) = Convert.ToDouble(dt.Rows(i)("value"))

                    ' DEBUG
                    'Debug.WriteLine(Round(cofRates(i), 12))
                Next
            End If

            Dim outPrin(term) As Double ' Outstanding Principle at each cash flow.
            Dim prinPmt(term) As Double ' Current Principle Payment.
            Dim intPmt(term) As Double ' Current Interest Payment.
            Dim prinPmtDen As Integer = 0 ' Denominator for payment amortization.
            Dim intPmtDen As Integer = 0 ' Denominator for interest rate.
            Dim prinPmtAdd As Integer = 0 ' Determines how many months each principle pmt is made.
            Dim intPmtAdd As Integer = 0 ' Determines how many months each interest pmt is made.
            Dim prinFreqAdd As Integer = 0 ' Determines how "mos to first pmt" affects next principal payment date.
            Dim intFreqAdd As Integer = 0 ' Determines how "mos to first pmt" affects next interest payment date.
            Dim pmt As Double = 0.0 ' Monthy Payment of P&I, or P, etc.
            Dim intRate As Double = 0.0 ' 2% in excess of the bullet rate for Term.
            Dim monInt(term) As Double ' 1 month of interest at our COF on the Principle Payment.
            Dim cumInt(term) As Double ' Cumulative interest.
            Dim cofPmt(term) As Double ' Payment of CumInt + Principle.

            ' Determine how to divide amort for payment and how often principle pays back.
            Select Case prinFreq
                Case PaymentFrequency.Monthly
                    prinPmtDen = 1
                    prinPmtAdd = 1
                Case PaymentFrequency.Quarterly
                    prinPmtDen = 3
                    prinPmtAdd = 3
                    prinFreqAdd = If(mosToFirstPrinPmt > 0, -3 + mosToFirstPrinPmt, 0)
                Case PaymentFrequency.SemiAnnual
                    prinPmtDen = 6
                    prinPmtAdd = 6
                    prinFreqAdd = If(mosToFirstPrinPmt > 0, -6 + mosToFirstPrinPmt, 0)
                Case PaymentFrequency.Annual
                    prinPmtDen = 12
                    prinPmtAdd = 12
                    prinFreqAdd = If(mosToFirstPrinPmt > 0, -12 + mosToFirstPrinPmt, 0)
                Case PaymentFrequency.AtMaturity
                    prinPmtDen = 0
                    prinPmtAdd = term
            End Select

            ' Determine how the interest rate is divided based on the Interest Frequency.
            Select Case intFreq
                Case PaymentFrequency.Monthly
                    intPmtDen = 12
                    intPmtAdd = 1
                Case PaymentFrequency.Quarterly
                    intPmtDen = 4
                    intPmtAdd = 3
                    intFreqAdd = If(mosToFirstIntPmt > 0, -3 + mosToFirstIntPmt, 0)
                Case PaymentFrequency.SemiAnnual
                    intPmtDen = 2
                    intPmtAdd = 6
                    intFreqAdd = If(mosToFirstIntPmt > 0, -6 + mosToFirstIntPmt, 0)
                Case PaymentFrequency.Annual
                    intPmtDen = 1
                    intPmtAdd = 12
                    intFreqAdd = If(mosToFirstIntPmt > 0, -12 + mosToFirstIntPmt, 0)
                Case PaymentFrequency.AtMaturity
                    intPmtDen = 1
                    intPmtAdd = term
            End Select

            outPrin(0) = 100
            cofPmt(0) = -outPrin(0)
            intRate = cofRates(term) + _incrementalRate ' 2% over the bullet rate.

            ' Start building amortization schedule.
            Select Case amortType
                Case AmortizationType.Equal
                    pmt = Financial.Pmt(intRate / intPmtDen, (amort - interestOnly) / prinPmtDen, -outPrin(0), outPrin(0) * residual, 0)
                Case AmortizationType.Linear
                    pmt = Financial.Pmt(0, (amort - interestOnly) / prinPmtDen, -outPrin(0), outPrin(0) * residual, 0)
                Case AmortizationType.Bullet
                    pmt = 0
            End Select

            Dim nextPrinMonth As Integer = prinPmtAdd + interestOnly + prinFreqAdd
            Dim nextIntMonth As Integer = intPmtAdd + intFreqAdd

            For month As Integer = 1 To term
                ' Interest payment.
                If (month = nextIntMonth) Then
                    intPmt(month) = (intRate / intPmtDen) * outPrin(month - 1)
                    nextIntMonth = month + intPmtAdd
                Else
                    intPmt(month) = 0
                End If

                ' Principal payment.
                If (month = nextPrinMonth) Then
                    Select Case amortType
                        Case AmortizationType.Equal
                            prinPmt(month) = pmt - intPmt(month)
                        Case AmortizationType.Linear
                            prinPmt(month) = pmt
                        Case AmortizationType.Bullet
                            prinPmt(month) = 0
                    End Select
                    nextPrinMonth = month + prinPmtAdd
                End If

                ' Evaluate the ending payment.
                If (month = term) Then
                    prinPmt(month) = outPrin(month - 1)
                    outPrin(month) = outPrin(month - 1) - prinPmt(month)
                Else
                    If (prinPmt(month) > outPrin(month - 1)) Then
                        prinPmt(month) = outPrin(month - 1)
                    Else
                        outPrin(month) = outPrin(month - 1) - prinPmt(month)
                    End If
                End If

                monInt(month) = cofRates(month) * (30 / 360) * prinPmt(month)
            Next

            ' Cumulate interest, and interest and principal total, for each month.
            For i As Integer = 1 To term
                For n As Integer = i To term
                    cumInt(i) = cumInt(i) + monInt(n)
                Next
                cofPmt(i) = cumInt(i) + prinPmt(i)
            Next

            ' Determine final cost of funds rate.
            Dim cofCalc As Double = 0.0
            Dim cofRate As Double = 0.0
            Dim guess As Double = cofRates(term)

            Dim mytest As Double = 0.0

            cofRate = IRR(cofPmt, guess / 12) * 12

            Select Case intFreq
                Case PaymentFrequency.Quarterly
                    cofRate = (((1 + cofRate / 12) ^ (12 / 4)) - 1) * 4
                Case PaymentFrequency.SemiAnnual
                    cofRate = (((1 + cofRate / 12) ^ (12 / 2)) - 1) * 2
                Case PaymentFrequency.Annual
                    cofRate = (((1 + cofRate / 12) ^ (12 / 1)) - 1) * 1
                Case PaymentFrequency.AtMaturity
                    cofRate = (((1 + cofRate / 12) ^ (term / 1)) - 1) * (12 / term)
            End Select

            If (accBasis = AccrualBasis.ActThreeSixty) Then
                cofRate = cofRate * (360 / 365)
            End If

            Return cofRate
        Catch ex As Exception
            ' Re-throw to calling method.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Function

    ''' <summary>
    ''' Calculates the prepayment waiver cost of funds on a rate lock.
    ''' </summary>
    ''' <param name="term">The length of the loan in months.</param>
    ''' <param name="amort">The length of time, in months, before the loan is fully amortized.</param>
    ''' <param name="prinFreq">See <seealso>PaymentFrequency</seealso> enum in Calculator.vb.</param>
    ''' <param name="amortType">See <seealso>AmortizationType</seealso> enum in Calculator.vb.</param>
    ''' <param name="prePmtWaiver">See <seealso>PrepaymentWaiver</seealso> enum in Calculator.vb.</param>
    ''' <param name="residual">The amount of loan left at the end of loan period, as a percentage.</param>
    ''' <returns>The prepayment waiver cost of funds.</returns>
    ''' <remarks></remarks>
    Protected Function CalculatePrepaymentCOF(ByVal term As Integer, ByVal amort As Integer, ByVal prinFreq As PaymentFrequency, _
                                              ByVal amortType As AmortizationType, ByVal prePmtWaiver As PrepaymentWaiver, ByVal residual As Double) As Double
        Try
            Dim ppCOFRates(360) As Double

            ' Get rate curve. Note that we handle this curve a bit differently than the
            ' standard COF curve (L0P0BFULL) which has a 1 day rate up front - this curve
            ' starts at 1 month.
            Dim cb As CurveBuilder = New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve("PrepaymentPremium360", _requestedRateDate)
            If (dt IsNot Nothing) AndAlso (dt.Rows.Count > 0) Then
                _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())
                For i As Integer = 1 To dt.Rows.Count
                    ppCOFRates(i) = Convert.ToDouble(dt.Rows(i - 1)("value"))

                    ' DEBUG
                    'Debug.WriteLine(Round(ppCOFRates(i), 12))
                Next
            End If

            Dim outPrin(term) As Double ' Outstanding Principle at each cash flow.
            Dim prinPmt(term) As Double ' Current Principle Payment.
            Dim intPmt(term) As Double ' Current Interest Payment.
            Dim prinPmtDen As Integer = 0 ' Denominator for payment amortization.
            Dim intPmtDen As Integer = 0 ' Denominator for interest rate.
            Dim prinPmtAdd As Integer = 0 ' Determines how many months each principle pmt is made.
            Dim intPmtAdd As Integer = 0 ' Determines how many months each interest pmt is made.
            Dim pmt As Double = 0.0 ' Monthy Payment of P&I, or P, etc.
            Dim intRate As Double = 0.0 ' 2% in excess of the bullet rate for Term.
            Dim monInt(term) As Double ' 1 month of interest at our COF on the Principle Payment.
            Dim cumInt(term) As Double ' Cumulative interest.
            Dim cofPmt(term) As Double ' Payment of CumInt + Principle.

            outPrin(0) = 100
            cofPmt(0) = -outPrin(0)

            ' Calculate standard cost of funds using specific (not user specified)
            ' accrual basis, amortization type, principal frequency, interest frequency,
            ' residual, and interest only period.
            intRate = CalculateStandardCOF(term, amort, AccrualBasis.ActThreeSixty, AmortizationType.Bullet, _
                                           PaymentFrequency.AtMaturity, PaymentFrequency.Monthly, 0, 0)
            intRate += _incrementalRate  '2% over the bullet rate

            ' Use monthly interest payments
            intPmtDen = 12
            intPmtAdd = 1

            ' Determine how to divide amort for payment and how often principle pays back
            If (prinFreq = PaymentFrequency.AtMaturity) Then
                prinPmtDen = 0
                prinPmtAdd = term
            Else
                ' Treat as if monthly frequency.
                prinPmtDen = 1
                prinPmtAdd = 1
            End If

            ' Start building amortization schedule.
            If (amortType = AmortizationType.Bullet) Then
                pmt = 0
            Else
                pmt = Financial.Pmt(intRate / intPmtDen, amort / prinPmtDen, -outPrin(0), outPrin(0) * residual, 0)
            End If

            Dim nextPrinMonth As Integer = prinPmtAdd
            Dim nextIntMonth As Integer = intPmtAdd

            For month As Integer = 1 To term Step 1
                ' Interest payment.
                If (month = nextIntMonth) Then
                    intPmt(month) = (intRate / intPmtDen) * outPrin(month - 1)
                    nextIntMonth = month + intPmtAdd
                Else
                    intPmt(month) = 0
                End If

                ' Principal payment.
                If (month = nextPrinMonth) Then
                    If (amortType = AmortizationType.Bullet) Then
                        prinPmt(month) = 0
                    Else
                        prinPmt(month) = pmt - intPmt(month)
                    End If
                    nextPrinMonth = month + prinPmtAdd
                Else
                    prinPmt(month) = 0
                End If

                ' Evaluate the ending payment.
                If (month = term) Then
                    prinPmt(month) = outPrin(month - 1)
                    outPrin(month) = outPrin(month - 1) - prinPmt(month)
                Else
                    If (prinPmt(month) > outPrin(month - 1)) Then
                        prinPmt(month) = outPrin(month - 1)
                    Else
                        outPrin(month) = outPrin(month - 1) - prinPmt(month)
                    End If
                End If

                monInt(month) = ppCOFRates(month) * (30 / 360) * prinPmt(month)
            Next

            ' Cumulate interest, and interest and principal total, for each month.
            For i As Integer = 1 To term
                For n As Integer = i To term
                    cumInt(i) = cumInt(i) + monInt(n)
                Next
                cofPmt(i) = cumInt(i) + prinPmt(i)
            Next

            ' Determine final cost of funds rate.
            Dim cofCalc As Double = 0.0
            Dim cofRate As Double = 0.0
            Dim guess As Double = ppCOFRates(term)

            cofRate = IRR(cofPmt, guess / 12) * 12

            Select Case prePmtWaiver
                Case PrepaymentWaiver.TenPercent
                    cofRate *= 0.1
                Case PrepaymentWaiver.FifteenPercent
                    cofRate *= 0.15
                Case PrepaymentWaiver.TwentyPercent
                    cofRate *= 0.2
                Case PrepaymentWaiver.ThirtyPercent
                    cofRate *= 0.3
            End Select

            Return cofRate
        Catch ex As Exception
            ' Re-throw to calling method.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Function

    ''' <summary>
    ''' Calculates the cost of funds for a rate lock on a consumer loan.
    ''' </summary>
    ''' <param name="term">The length of the loan in months.</param>
    ''' <param name="amort">The length of time, in months, before the loan is fully amortized.</param>
    ''' <param name="cpr">The calculated constant prepayment rate.</param>
    ''' <param name="optionCost">The calculated option cost.</param>
    ''' <returns>The cost of funds.</returns>
    ''' <remarks></remarks>
    Protected Function CalculateConsumerCOF(ByVal term As Integer, ByVal amort As Integer, ByVal cpr As Double, _
                                            ByVal optionCost As Double) As Double
        Try
            Dim conCOFRates(360) As Double

            Dim cb As CurveBuilder = New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve("L0P0BFULL", _requestedRateDate)
            If (dt IsNot Nothing) AndAlso (dt.Rows.Count > 0) Then
                _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())
                For i As Integer = 0 To dt.Rows.Count - 1
                    conCOFRates(i) = Convert.ToDouble(dt.Rows(i)("value"))

                    ' DEBUG
                    'Debug.WriteLine(Round(cofRates(i), 12))
                Next
            End If

            Dim outPrin(term) As Double ' Outstanding Principle at each cash flow.
            Dim outPrinOrig(term) As Double ' Track original as Outstanding Principle changes.
            Dim prinPmt(term) As Double ' Current Principle Payment.
            Dim intRate As Double = 0.0 ' 2% in excess of the bullet rate for Term.
            Dim smm As Double = 0.0 ' ?????
            Dim monInt(term) As Double ' 1 month of interest at our COF on the Principle Payment.
            Dim cumInt(term) As Double ' Cumulative interest.
            Dim cofPmt(term) As Double ' Payment of CumInt + Principle.
            Dim pmtOnOrigFace(term) As Double  ' Payment on Original Face Amount
            Dim pmtOnRemainBal(term) As Double ' Payment on Remaining Book Balance
            Dim prinCashFlow(term) As Double ' Principal Cash Flow

            outPrin(0) = 100
            outPrinOrig(0) = 100
            cofPmt(0) = -outPrin(0)

            intRate = conCOFRates(term)
            intRate += _incrementalRate ' 2% over the bullet rate

            'smm = 1 - (1 - 0.01 * cpr) ^ (1 / 12)
            smm = 1 - (1 - cpr) ^ (1 / 12)

            ' Build amortization schedule for principal.
            For month As Integer = 1 To term
                pmtOnOrigFace(month) = -smm * outPrinOrig(month - 1)
                outPrinOrig(month) = outPrinOrig(month - 1) + pmtOnOrigFace(month)
                pmtOnRemainBal(month) = -smm * outPrin(month - 1)
                prinPmt(month) = Financial.PPmt(intRate / 12, month, amort, outPrinOrig(month), 0, 0)
                outPrin(month) = outPrin(month - 1) + pmtOnRemainBal(month) + prinPmt(month)

                If (month = term) Then
                    prinCashFlow(month) = -prinPmt(month) - pmtOnRemainBal(month) + outPrin(month)
                Else
                    prinCashFlow(month) = -prinPmt(month) - pmtOnRemainBal(month)
                End If

                monInt(month) = conCOFRates(month) * (30 / 360) * prinCashFlow(month)
            Next

            ' Cumulate interest, and interest and principal total, for each month.
            For i As Integer = 1 To term
                For n As Integer = i To term
                    cumInt(i) = cumInt(i) + monInt(n)
                Next
                cofPmt(i) = cumInt(i) + prinCashFlow(i)
            Next

            ' Determine final cost of funds rate.
            Dim cofCalc As Double = 0.0
            Dim cofRate As Double = 0.0
            Dim guess As Double = conCOFRates(term)

            cofRate = IRR(cofPmt, guess / 12) * 12
            cofCalc = cofRate + optionCost

            Return cofCalc
        Catch ex As Exception
            ' Re-throw to calling method.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Function

    ''' <summary>
    ''' Calculates the weighted average life on a loan.
    ''' </summary>
    ''' <param name="term">The term of the loan in months.</param>
    ''' <param name="amort">The amortization period of the loan in months.</param>
    ''' <returns>The weighted average life of the loan.</returns>
    ''' <remarks>
    ''' This value represents the average number of years for which each dollar
    ''' of unpaid principal on a loan or mortgage remains outstanding. Once
    ''' calculated, WAL tells how many years it will take to pay half of the
    ''' outstanding principal.
    ''' </remarks>
    Protected Function CalculateWAL(ByVal term As Integer, ByVal amort As Integer) As Double
        Try
            Dim cofRates(360) As Double

            Dim cb As CurveBuilder = New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve("L0P0BFULL", _requestedRateDate)
            If (dt IsNot Nothing) AndAlso (dt.Rows.Count > 0) Then
                _rateDate = Date.Parse(dt.Rows(0)("CalculatedDate").ToString())
                For i As Integer = 0 To dt.Rows.Count - 1
                    cofRates(i) = Convert.ToDouble(dt.Rows(i)("value"))

                    ' DEBUG
                    'Debug.WriteLine(Round(cofRates(i), 12))
                Next
            End If

            Dim outPrin(term) As Double ' Outstanding Principle at each cash flow.
            Dim prinPmt(term) As Double ' Current Principle Payment.
            Dim intPmt(term) As Double ' Current Interest Payment.
            Dim pmt As Double = 0.0 ' Monthy Payment of P&I, or P, etc.
            Dim intRate As Double = 0.0 ' 2% in excess of the bullet rate for Term.
            Dim cumPrinPmts As Double = 0.0 ' Cumulative principal payments.
            Dim cumAvgLife As Double = 0.0 ' Cumulative average life.
            Dim cumAvgLife2 As Double = 0.0 ' Cumulative average life.

            ' Use typical scenario of $100 loan.
            outPrin(0) = 100
            intRate = cofRates(term) + _incrementalRate ' 2% over the bullet rate.

            ' We use equal monthly payments for this calculation.
            pmt = Financial.Pmt(intRate / 12, amort, -outPrin(0), 0, 0)

            ' Build amortization schedule.
            For i As Integer = 1 To term
                ' Interest payment.
                intPmt(i) = (intRate / 12) * outPrin(i - 1)

                ' Principal payment.
                prinPmt(i) = pmt - intPmt(i)

                ' Evaluate the ending payment.
                If (i = term) Then
                    prinPmt(i) = outPrin(i - 1)
                    outPrin(i) = outPrin(i - 1) - prinPmt(i)
                Else
                    If (prinPmt(i) > outPrin(i - 1)) Then
                        prinPmt(i) = outPrin(i - 1)
                    Else
                        outPrin(i) = outPrin(i - 1) - prinPmt(i)
                    End If
                End If

                cumPrinPmts += prinPmt(i)
                cumAvgLife += prinPmt(i) * i * 30.4375
                cumAvgLife2 += prinPmt(i) * i
            Next

            ' Final average life calculation.
            Dim avgLife1 As Double = (cumAvgLife / cumPrinPmts) / 360
            Dim avgLife2 As Double = cumAvgLife2 / 100 / 12 ' This is the way AvgLifeCalc1.xls does it.

            Return avgLife2
        Catch ex As Exception
            ' Re-throw to calling method.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Function

    Protected Sub CalculateIrregularCOF(ByVal requestDate As Date, ByVal cashFlow As DataTable, _
                    ByRef avgLife As Double, ByRef actActRate As Double, ByRef act360Rate As Double)

        Dim cumPrinPmts As Double = 0.0
        Dim cumAvgLife As Double = 0.0

        ' Calculate outputs for Results group box and also extra columns. Because
        ' of the way cumulative interest and principal is calculated, this is
        ' best done by working backward through the grid rows. We'll also
        ' populate the array to use with IRR().
        Dim cumIntAmt As Double = 0.0
        Dim cumIntAndPrinAmt As Double = 0.0
        Dim intAndPrinAmts(360) As Double
        Dim prinPmt As Double
        Dim paymentDate As Date

        If cashFlow Is Nothing OrElse cashFlow.Rows.Count = 0 Then
            Throw New Exception("You have specified an amortization type of irregular cash flow, but have not entered the payment schedule")
        End If
        Try
            Dim cb As CurveBuilder = New CurveBuilder()
            Dim dt As DataTable = cb.GetCurve("L0P0BFULL", requestDate)
            For i As Integer = (cashFlow.Rows.Count - 1) To 0 Step -1
                Dim row As DataRow = cashFlow.Rows(i)

                prinPmt = Convert.ToDouble(row("principalamount"))
                paymentDate = DirectCast(row("paymentdate"), Date)


                If Not (prinPmt > 0) AndAlso Not (cumIntAmt > 0) AndAlso Not (cumIntAndPrinAmt > 0) Then
                    Continue For
                End If

                Dim months As Integer = Convert.ToInt32(DateDiff(DateInterval.Month, requestDate, paymentDate))
                Dim termRows = dt.Select(String.Format("term={0}", months))
                If (termRows Is Nothing OrElse termRows.Length = 0) Then
                    Throw New Exception(String.Format("The payment date {0} is more than 30 years after the calculation date {1}", paymentDate, requestDate))
                End If
                Dim discountRate = Convert.ToDouble(termRows(0)("value"))
                If (prinPmt > 0) Then
                    Dim intPmt As Double = prinPmt * discountRate * 30 / 360
                    cumIntAmt += intPmt
                End If

                cumIntAndPrinAmt = If(prinPmt > 0, prinPmt + cumIntAmt, cumIntAmt)
                cumPrinPmts += prinPmt
                cumAvgLife += prinPmt * (Convert.ToInt32(discountRate * 30.4375))
                intAndPrinAmts(i + 1) = cumIntAndPrinAmt
            Next

            If (cumPrinPmts > 0) Then
                ' Array for IRR() must start with negative value of total principal
                ' amount (i.e. the initial cost of loan to bank).
                intAndPrinAmts(0) = -cumPrinPmts
                actActRate = IRR(intAndPrinAmts, 0) * 12
                act360Rate = actActRate * 360 / 365
                avgLife = (cumAvgLife / cumPrinPmts) / 360

            End If


        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw ex
        End Try
    End Sub
End Class

''' <summary>
''' Base class for calculator validation responses.
''' </summary>
''' <remarks>
''' A List of these is returned with errors, warnings, and value changes when a
''' calculator completes its validation of parameters.
''' </remarks>
Public MustInherit Class CalculatorValidationResponse
    Protected _responseType As ValidationResponseType
    Protected _responseMessage As String
    Protected _newValue As Object

    ''' <summary>
    ''' The type of validation response.
    ''' </summary>
    ''' <remarks>Can be either Warning, Error, or ValueChange.</remarks>
    Public Enum ValidationResponseType
        Warning = 1
        [Error] = 2
        ValueChange = 3
        Enable = 4
    End Enum

    ''' <summary>
    ''' Read-only property for ValidationResponseType.
    ''' </summary>
    ''' <returns>The ValidationResponseType for the response.</returns>
    ''' <remarks>This should be set by all inheriting classes.</remarks>
    Public ReadOnly Property ResponseType() As ValidationResponseType
        Get
            Return _responseType
        End Get
    End Property

    ''' <summary>
    ''' Read-only property representing a user oriented message regarding
    ''' the response.
    ''' </summary>
    ''' <returns>The response message.</returns>
    ''' <remarks>This should be set by all inheriting classes.</remarks>
    Public ReadOnly Property ResponseMessage() As String
        Get
            Return _responseMessage
        End Get
    End Property

    ''' <summary>
    ''' The new value which was set when the response type is ValueChange.
    ''' </summary>
    ''' <returns>The new value given to the parameter.</returns>
    ''' <remarks>
    ''' This is supplied in case the UI wants to update the control from which
    ''' the paramter was derive witht the new value. This should be set by all
    ''' inheriting classes when generating a ValueChange response.
    ''' </remarks>
    Public ReadOnly Property NewValue() As Object
        Get
            Return _newValue
        End Get
    End Property
End Class
