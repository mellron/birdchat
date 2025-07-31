'*******************************************************************************
'BSD Rate Business project
'Copyright © 2011 U.S. Bancorp
'This source file contains the class for the CIP360 Rate Calculator. It
'determines the cost of funds using the new CIP360 curve.
'==============================================================================
'
'Used By: BSD Rate
'
'Created by: detolle
'Created when: 07/09/2025
'Modifications:
'
'Date        By      Reason/What changed
'07/09/2025  detolle   TPP-7119 detolle - initial implementation for CIP360 curve support
'*******************************************************************************/
Option Explicit On
Option Strict On

Imports System.Data

''' <summary>
''' This class contains the variables and methods to support the CIP360
''' Rate calculations.
''' </summary>
Public Class CIP360Calculator
    Inherits CIPRateCalculator



    ''' <summary>
    ''' Instantiate new instance of CIP360Calculator, populating member
    ''' variables with all data necessary for calculations.
    ''' </summary>
    Public Sub New(ByVal reqRateDate As Date,
                   ByVal term As Integer,
                   ByVal amort As Integer,
                   ByVal accBasis As AccrualBasis,
                   ByVal amortType As AmortizationType,
                   ByVal prinFreq As PaymentFrequency,
                   ByVal intFreq As PaymentFrequency,
                   ByVal forward As Integer,
                   ByVal prePmtWaiver As PrepaymentWaiver,
                   ByVal interestOnly As Integer
                   )
        MyBase.New(reqRateDate, term, amort, accBasis, amortType, prinFreq, intFreq, forward, prePmtWaiver, interestOnly)
    End Sub
    ''' <summary>
    ''' Calculates the CIP360 rate using the CIP360 curve.
    ''' TPP-7119 detolle 07/09/2025
    ''' </summary>
    Protected Overrides Function CalculateCIPRate() As Double
        Try
            ' Delegate to the shared CalculateCIP360 helper, which returns the CIP360 COF including any IO adjustment.
            Return CalculateCIP360(_term, _amortization, _accrualBasis, _amortizationType,
                                   _principalFrequency, _interestFrequency, 0, _interestOnly, 0, 0)
        Catch ex As Exception
            'Re-throw to calling method.
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}",
                               (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name,
                               (New StackTrace()).GetFrame(0).GetMethod().Name,
                               ex.Message)
            App.EventLog.LogException(msg, ex.StackTrace)
            Throw
        End Try
    End Function
End Class
