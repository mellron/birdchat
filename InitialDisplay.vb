'*****************************************************************************
'BSDRate 
'Copyright © 2010 U.S. Bancorp
'    This source file contains the start page for the application.
'    This handle the vertical menu as well as launching all windows
' ==============================================================================
'
'Used By: 
'
'Created by: Douglas Weeks - Alto Consulting
'Created when: 09/07/2011
'Modifications:
'
'Date		By		    	Reason/What changed
'--------	---------		-------------------
'01/06/2012 D.Weeks         Handle errors when adding menus
'01/11/12   jrhald          Changed LaunchTaskForm to not create new form if one
'                           already exists for specified task.
'02/08/2012 D. Weeks        Add _missingFromAFSStatus
'03/08/2012 D. Weeks        Disable the double-click event
'03/20/2012 D. Weeks        Pass ParameterList via LaunchtaskForm/LaunchForm
'04/16/12   jrhald          Added DataTable for LEmailStatus lookup data.
'05/01/2012 D. Weeks        Set windowelement.taskdescription in LaunchTaskForm
'05/08/12   jrhald          Added DataTable for LGeneralLedgerTypes lookup data.
'07/13/12   jrhald          Utility method ReplaceTokens() was moved to App class.
'08/06/12   jrhald          Moved GetProcessTasks() method from LookupData to TaskData.
'10/03/12   jrhald          Added DataTable for LCurrencies lookup data.
'11/13/12   jrhald          Added DataTables for LSourceRateOrigins, LRateCategories, and
'                           LRateCollectionFrequencies lookup data.
'01/14/13   jrhald          Modified second LaunchForm method to accept form parameters.
'02/06/13   Larry Peteet    Changed Default Background Color of TreeView Control to Yellow
'                           Also added ability for User to change Background color of TreeView Control
'                           by Right-Clicking on any Node.  A Color Selection Dialog is displayed
'                           and lets them select a Color and change it or cancel from the Dialog.
'03/07/13   jrhald          Changed the tree view background change logic to only do so for UAT or Parallel.
'07/08/13   jrhald          Added LExportTypes lookup table DataTable.
'07/26/13   kkuusinen       Added LFrequencyDayToUse and LFrequencyDayType lookup tables.
'07/30/13   kkuusinen       Set LFrequencyDayToUse and LFrequencyDayType to their datatables.
'08/09/13   kkuusinen       Commented out all references to "FrequencyDayType".
'10/15/13   kkuusinen       Added code for LRoundingTypes.
'11/15/13   jrhald          Added back FrequencyDayType - it is needed.
'12/09/13   jrhald          Added support for new lookup table LRateCollectionTimes.
'05/21/2014 dweeks          Do not abort if user is not on database an we try to close the window
'07/07/14   jrhald          Added logging for exceptions for issue #565.
'03/04/21   stsadiq         Added LCurrencyGroups table
'01/08/2025 detolle         Added buildnumber to display and app.config
'TPP-0001   detolle         Set TreeView background color by environment from app.config (excluding Production)
'*****************************************************************************/
Imports System.Collections
Imports System.Configuration
Imports System.Reflection
Imports System.Threading
Imports BSDRateBusiness
Imports Microsoft.SqlServer

Public Class InitialDisplay

#Region "Properties"
    Dim _accrualBasis As DataTable
    Dim _amortizationType As DataTable
    Dim _consumerLoanType As DataTable
    Dim _currencies As DataTable
    Dim _currencygroups As DataTable
    Dim _divisions As DataTable
    Dim _emailStatus As DataTable
    Dim _exportDataTypes As DataTable
    Dim _exportTypes As DataTable
    Dim _frequencyDayToUse As DataTable
    Dim _frequencyDayType As DataTable
    Dim _loanSystems As DataTable
    Dim _ftpAmortizationType As DataTable
    Dim _ftpPaymentFrequency As DataTable
    Dim _ftpPrepaymentWaiver As DataTable
    Dim _generalLedgerTypes As DataTable
    Dim _piPaymentFrequency As DataTable
    Dim _mainMenu As DataTable
    Dim _missingFromAFSStatus As DataTable
    Dim _nonRateDataTypes As DataTable
    Dim _paymentFrequency As DataTable
    Dim _prepaymentType As DataTable
    Dim _prepaymentWaiver As DataTable
    Dim _rateCategories As DataTable
    Dim _rateCollectionFrequencies As DataTable
    Dim _rateCollectionTimes As DataTable
    Dim _rateLockChargeTypes As DataTable
    Dim _sourceRateOrigins As DataTable
    Dim _taxPercentage As DataTable
    Dim _roundingTypes As DataTable
    Dim _windowList As ArrayList
    Private WithEvents _task As ITask = Nothing

    Private _curveNameSearch As String
    Private _curveDateSearch As Date

    Public ReadOnly Property LAccuralBasis() As DataTable
        Get
            Return _accrualBasis
        End Get
    End Property

    Public ReadOnly Property LAmortizationType() As DataTable
        Get
            Return _amortizationType
        End Get
    End Property

    Public ReadOnly Property LConsumerLoanType() As DataTable
        Get
            Return _consumerLoanType
        End Get
    End Property

    Public ReadOnly Property LCurrencies() As DataTable
        Get
            Return _currencies
        End Get
    End Property

    Public ReadOnly Property LCurrencyGroups() As DataTable
        Get
            Return _currencygroups
        End Get
    End Property

    Public ReadOnly Property LDivisions() As DataTable
        Get
            Return _divisions
        End Get
    End Property

    Public ReadOnly Property LFTPAmortizationType() As DataTable
        Get
            Return _ftpAmortizationType
        End Get
    End Property

    Public ReadOnly Property LFTPPaymentFrequency() As DataTable
        Get
            Return _ftpPaymentFrequency
        End Get
    End Property

    Public ReadOnly Property LFTPPrepaymentWaiver() As DataTable
        Get
            Return _ftpPrepaymentWaiver
        End Get
    End Property

    Public ReadOnly Property LMissingFromAFSStatus() As DataTable
        Get
            Return _missingFromAFSStatus
        End Get
    End Property

    Public ReadOnly Property LPIPaymentFrequency() As DataTable
        Get
            Return _piPaymentFrequency
        End Get
    End Property

    Public ReadOnly Property LPaymentFrequency() As DataTable
        Get
            Return _paymentFrequency
        End Get
    End Property

    Public ReadOnly Property LPrepaymentType() As DataTable
        Get
            Return _prepaymentType

        End Get
    End Property

    Public ReadOnly Property LPrepaymentWaiver() As DataTable
        Get
            Return _prepaymentWaiver
        End Get
    End Property

    Public ReadOnly Property LRateCategories() As DataTable
        Get
            Return _rateCategories
        End Get
    End Property

    Public ReadOnly Property LRateCollectionFrequencies() As DataTable
        Get
            Return _rateCollectionFrequencies
        End Get
    End Property

    Public ReadOnly Property LRateCollectionTimes() As DataTable
        Get
            Return _rateCollectionTimes
        End Get
    End Property

    Public ReadOnly Property LRateLockChargeTypes() As DataTable
        Get
            Return _rateLockChargeTypes
        End Get
    End Property

    Public ReadOnly Property LSourceRateOrigins() As DataTable
        Get
            Return _sourceRateOrigins
        End Get
    End Property

    Public ReadOnly Property LTaxPercentage() As DataTable
        Get
            Return _taxPercentage
        End Get
    End Property

    Public ReadOnly Property LRoundingTypes() As DataTable
        Get
            Return _roundingTypes
        End Get
    End Property

    Public ReadOnly Property LEmailStatus() As DataTable
        Get
            Return _emailStatus
        End Get
    End Property

    Public ReadOnly Property LExportDataTypes() As DataTable
        Get
            Return _exportDataTypes
        End Get
    End Property

    Public ReadOnly Property LExportTypes() As DataTable
        Get
            Return _exportTypes
        End Get
    End Property

    Public ReadOnly Property LGeneralLedgerTypes() As DataTable
        Get
            Return _generalLedgerTypes
        End Get
    End Property

    Public ReadOnly Property LFrequencyDayToUse() As DataTable
        Get
            Return _frequencyDayToUse
        End Get
    End Property

    Public ReadOnly Property LFrequencyDayType() As DataTable
        Get
            Return _frequencyDayType
        End Get
    End Property

    Public ReadOnly Property LLoanSystems() As DataTable
        Get
            Return _loanSystems
        End Get
    End Property

    Public ReadOnly Property LNonRateDataTypes() As DataTable
        Get
            Return _nonRateDataTypes
        End Get
    End Property

    Public ReadOnly Property WindowList() As ArrayList
        Get
            Return _windowList
        End Get
    End Property


#End Region

    ''' <summary>
    ''' InitialDisplay_Load - Called one time when the program starts
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub InitialDisplay_Load(ByVal sender As System.Object, ByVal e As EventArgs) Handles Me.Load
        Try
            '*************  Create our connector ***********************
            CommonUI.Setup(My.Settings.Context("GroupName").ToString())

            'do a alert here
            'CommonUI.Connector.ConnectionString = '"Server=VMBKSA69901MRS,49001;Database=BSDRate;Trusted_Connection=True;Persist Security Info=False"

            CommonUI.EventLog.ConnectionString = CommonUI.Connector.ConnectionString
            CommonUI.EventLog.AddLog(String.Format("User {0} started BSDRate", CommonUI.Connector.UserName), "Connection")
            _windowList = New ArrayList()
            Me.ToolStripStatusLabelDatabase.Text = String.Format("Database: {0}", CommonUI.Connector.DatabaseName)
            Me.ToolStripStatusLabelEnvironment.Text = String.Format("Environment: {0}", CommonUI.Connector.Environment)
            'TPP-0001 detolle - Set TreeView background color by environment from app.config (excluding Production)
            SetEnvironmentColor()
            Me.ToolStripStatusLabelRole.Text = String.Format("Role: {0}", CommonUI.Connector.UserRole)
            Me.ToolStripStatusLabelServer.Text = String.Format("Server: {0}", CommonUI.Connector.ServerName)

            Me.ToolStripStatusLabelUserName.Text = CommonUI.Connector.UserName

            BSDRateBusiness.App.Connector = CommonUI.Connector
            BSDRateBusiness.App.EventLog = CommonUI.EventLog

            SetBuildNumber()



            '***********************************************************
            '           Get our record from Lenders
            '***********************************************************
            Try
                Dim lenderSet As DataSet = BSDRateBusiness.PrepaymentData.GetLenders(String.Empty, CommonUI.Connector.UserName, String.Empty, String.Empty, String.Empty, String.Empty)
                If (lenderSet IsNot Nothing AndAlso lenderSet.Tables(0).Rows.Count = 1) Then
                    Dim dt = lenderSet.Tables(0)
                    CommonUI.Connector.UserDisplayName = Convert.ToString(dt.Rows(0)("lendername"))
                    CommonUI.Connector.UserEmail = Convert.ToString(dt.Rows(0)("lenderemail"))
                    CommonUI.Connector.UserPhone = Convert.ToString(dt.Rows(0)("lenderphone"))
                End If
            Catch ex As Exception
                Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
                CommonUI.EventLog.LogException(msg, ex.StackTrace)
            End Try

            '***********************************************************
            '       Load all the validation tables
            '       The first dataset contains a single value that
            '       holds a csv list of the table names (in order)
            '***********************************************************
            Dim ds As DataSet = BSDRateBusiness.LookupData.GetLookups()
            Dim tableNames As String = ds.Tables(0)(0)(0).ToString()   'First table, first row, first column
            Dim idx As Integer = 1
            For Each seg As String In tableNames.Split(Convert.ToChar(","))
                ds.Tables(idx).TableName = seg
                idx = idx + 1
            Next
            _accrualBasis = ds.Tables("LAccrualBasis")
            _amortizationType = ds.Tables("LAmortizationType")
            _consumerLoanType = ds.Tables("LConsumerLoanType")
            _currencies = ds.Tables("LCurrencies")
            _currencygroups = ds.Tables("LCurrencyGroups")
            _divisions = ds.Tables("LDivisions")
            _emailStatus = ds.Tables("LEmailStatus")
            _exportDataTypes = ds.Tables("LExportDataTypes")
            _exportTypes = ds.Tables("LExportTypes")
            _ftpAmortizationType = ds.Tables("LFTPAmortizationType")
            _ftpPaymentFrequency = ds.Tables("LFTPPaymentFrequency")
            _ftpPrepaymentWaiver = ds.Tables("LFTPPrepaymentWaiver")
            _generalLedgerTypes = ds.Tables("LGeneralLedgerTypes")
            _missingFromAFSStatus = ds.Tables("LMissingFromAFSStatus")
            _piPaymentFrequency = ds.Tables("LPIPaymentFrequency")
            _paymentFrequency = ds.Tables("LPaymentFrequency")
            _prepaymentType = ds.Tables("LPrepaymentType")
            _prepaymentWaiver = ds.Tables("LPrepaymentWaiver")
            _rateCategories = ds.Tables("LRateCategories")
            _rateCollectionFrequencies = ds.Tables("LRateCollectionFrequencies")
            _rateCollectionTimes = ds.Tables("LRateCollectionTimes")
            _frequencyDayToUse = ds.Tables("LFrequencyDayToUse")
            _frequencyDayType = ds.Tables("LFrequencyDayType")
            _loanSystems = ds.Tables("LLoanSystems")
            _rateLockChargeTypes = ds.Tables("LRateLockChargeTypes")
            _sourceRateOrigins = ds.Tables("LSourceRateOrigins")
            _taxPercentage = ds.Tables("LTaxPercentage")
            _roundingTypes = ds.Tables("LRoundingTypes")
            _nonRateDataTypes = ds.Tables("LNonRateDataTypes")

            '***********************************************************
            '       Load the menu from the "Main Menu" process
            '***********************************************************
            _mainMenu = BSDRateBusiness.TaskData.GetProcessTasks("Main Menu")
            For Each row As DataRow In _mainMenu.Rows
                If (Convert.ToInt32(row("Level")) = 1) Then
                    Dim newNode As TreeNode = New TreeNode(Convert.ToString(row("TaskDescription")))
                    newNode.Name = Convert.ToString(row("TaskDescription"))
                    newNode.ToolTipText = Convert.ToString(row("TaskNotes"))
                    newNode.Tag = Convert.ToString(row("TaskID"))
                    InitialDisplayTreeView.Nodes.Add(newNode)
                    AddTreeChildren(_mainMenu, Convert.ToInt32(row("TaskID")), newNode)     'Add our own children
                End If

            Next
            'stsadiq
            Dim overridetext As String = ""
            Dim check As Boolean = CommonData.CheckRateOverRide()
            If (CommonData.CheckRateOverRide()) Then
                overridetext = " Rates sent to loan system have been modified please check the source rates"
            End If

            Me.OverridedRates.Text = overridetext

        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(ex.Message, "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error) 'No SLOG since we are not sure what went wrong
            If (ex.InnerException IsNot Nothing) Then
                MessageBox.Show(ex.InnerException.Message, "Inner Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Else
                MessageBox.Show("No inner exception", "Inner Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
            MessageBox.Show(ex.StackTrace, "Stack Trace", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub


    ''' <summary>
    ''' AddTreeChildren - Recursive routine to load menu tree
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <param name="parentTaskID"></param>
    ''' <param name="parentNode"></param>
    ''' <remarks></remarks>
    Private Sub AddTreeChildren(ByVal dt As DataTable, ByVal parentTaskID As Integer, ByVal parentNode As TreeNode)
        Try
            For Each row As DataRow In dt.Rows
                If (Convert.ToInt32(row("ParentTaskID")) = parentTaskID) Then
                    Dim newNode As TreeNode = New TreeNode(Convert.ToString(row("TaskDescription")))
                    newNode.Name = Convert.ToString(row("TaskDescription"))
                    newNode.Tag = Convert.ToString(row("TaskID"))
                    parentNode.Nodes.Add(newNode)
                    AddTreeChildren(dt, Convert.ToInt32(row("TaskID")), newNode)     'Add our own children
                End If

            Next
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(String.Format("Error building submenu for taskid {0} ({1}){2}{3}", parentTaskID, parentNode.Text, vbCrLf, ex.Message), "Error building submenu", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' CloseAllButton_Click - event handler called when user clicks the "Close All" button.
    ''' Issue a Close request to each form.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub CloseAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseAllButton.Click
        Try
            If ((_windowList IsNot Nothing) AndAlso (_windowList.Count > 0)) Then
                For Each we As BSDRateBusiness.WindowElement In _windowList
                    we.CloseFlag = True
                Next
                Dim firstWe As BSDRateBusiness.WindowElement = DirectCast(_windowList(0), WindowElement)
                firstWe.FormControl.Close()     'Event handler will close the rest
            End If
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred while closing forms:" + Environment.NewLine + ex.Message, _
                            "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' MinimizeAllButton_Click - event handler called when user clicks the "Minimize All" button
    ''' Reduce all the windows to a minimized state
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub MinimizeAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MinimizeAllButton.Click
        For Each we As BSDRateBusiness.WindowElement In _windowList
            we.FormControl.WindowState = FormWindowState.Minimized
        Next

    End Sub


#Region "Window Methods"

    ''' <summary>
    ''' LaunchForm - create and display a form.  This routine handles the updates to the vertical menu
    ''' </summary>
    ''' <param name="formName"></param>
    ''' <param name="TaskDescription"></param>
    ''' <param name="FormParameters"></param>
    ''' <remarks>1</remarks>
    Public Sub LaunchForm(ByVal formName As String, ByVal TaskDescription As String, ByVal FormParameters As String, Optional ByVal Taskid As Integer = -1, Optional ByVal ToolbarButtons As List(Of Button) = Nothing)
        Try
            Const [nameSpace] = "BSDRate"
            Name = [nameSpace] & "." & formName

            Dim assem = Assembly.GetExecutingAssembly()
            Dim frm As Form = DirectCast(assem.CreateInstance(Name, True), Form)
            If frm Is Nothing Then
                Throw New Exception(String.Format("Unable to instantiate the control {0} - check the EntryPoint column in STask for {1}", Name, formName))
            End If
            'frm.TopLevel = False
            'Me.FormsPanel.Controls.Add(frm)
            frm.MdiParent = Me


            Dim we = New BSDRateBusiness.WindowElement()
            we.WindowType = formName
            we.ID = Date.Now.Ticks
            we.FormControl = frm
            'we.TaskID = rows(0)("TaskID")
            we.TaskID = Taskid
            we.TaskDescription = TaskDescription

            we.HashCode = frm.GetHashCode()
            _windowList.Add(we)
            ResetToDefaults(we)
            we.MenuParameters = FormParameters

            'TPP-73 detolle 01/08/2025
            If ToolbarButtons IsNot Nothing AndAlso TypeOf frm Is PrepaymentBase Then
                DirectCast(frm, PrepaymentBase).InitializeWithToolbarButtons(ToolbarButtons)
            End If

            AddHandler frm.FormClosed, AddressOf WindowClosed


            Dim wNode As TreeNode = InitialDisplayTreeView.Nodes("Windows")
            If wNode IsNot Nothing Then
                we.TreeNode = New TreeNode(we.MenuLabel)
                we.TreeNode.Tag = we.ID.ToString()
                wNode.Nodes.Add(we.TreeNode)

            End If
            'frm.Dock = DockStyle.Fill
            frm.WindowState = FormWindowState.Maximized

            frm.Show()
            frm.BringToFront()
            wNode.Expand()
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred while launching form:" + Environment.NewLine + ex.Message, _
                            "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' LaunchForm - Same routine as above, except that the caller is responsible for creating and populating the WindowElement
    ''' </summary>
    ''' <param name="formName"></param>
    ''' <param name="TaskDescription"></param>
    ''' <param name="we"></param>
    ''' <remarks>2</remarks>
    Public Sub LaunchForm(ByVal formName As String, ByVal TaskDescription As String, ByRef we As WindowElement, ByVal FormParameters As String)
        Try
            Const [nameSpace] = "BSDRate"
            Name = [nameSpace] & "." & formName

            Dim assem = Assembly.GetExecutingAssembly()
            Dim frm As Form = DirectCast(assem.CreateInstance(Name, True), Form)
            If frm Is Nothing Then
                Throw New Exception(String.Format("Unable to instantiate the control {0} - check the EntryPoint column in STask for {1}", Name, formName))
            End If
            'frm.TopLevel = False
            'Me.FormsPanel.Controls.Add(frm)
            frm.MdiParent = Me


            we.WindowType = formName
            we.ID = Date.Now.Ticks
            we.FormControl = frm
            we.TaskID = -1
            we.TaskDescription = TaskDescription

            we.HashCode = frm.GetHashCode()
            _windowList.Add(we)
            we.MenuParameters = FormParameters

            AddHandler frm.FormClosed, AddressOf WindowClosed


            Dim wNode As TreeNode = InitialDisplayTreeView.Nodes("Windows")
            If wNode IsNot Nothing Then
                we.TreeNode = New TreeNode(we.MenuLabel)
                we.TreeNode.Tag = we.ID.ToString()
                wNode.Nodes.Add(we.TreeNode)

            End If
            'frm.Dock = DockStyle.Fill
            frm.WindowState = FormWindowState.Maximized

            frm.Show()
            frm.BringToFront()
            wNode.Expand()
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred while launching form:" + Environment.NewLine + ex.Message, _
                            "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Public Sub LaunchTask(ByVal taskId As Integer)
        Try
            _task = TaskFactory.CreateTask(taskId, 0)

            If (_task Is Nothing) Then
                Throw New Exception("The task with ID " + taskId.ToString() + " does not exist. Cannot load task.")
            End If

            Dim thrd As New Thread(AddressOf _task.Execute)
            thrd.Start()
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(ex.Message, "Error running task", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    ''' <summary>
    ''' Loads the generic task window for the specified task.
    ''' </summary>
    ''' <param name="taskId">The database row id of the task.</param>
    ''' <param name="taskDescription">The short description of the task.</param>
    ''' <param name="taskParameters">Default parameters required by the task.</param>
    ''' <remarks></remarks>
    Public Sub LaunchTaskForm(ByVal taskId As Integer, ByVal parentTaskId As Integer, ByVal taskDescription As String, ByVal taskParameters As String)
        Try
            ' We only allow one TaskForm for any given task to be open at a time.
            For Each winElmt As WindowElement In _windowList
                If (winElmt.FormControl.Name = taskId.ToString()) Then
                    winElmt.FormControl.BringToFront()
                    Exit Sub
                End If
            Next

            Dim frm As TaskForm = New TaskForm()
            If frm Is Nothing Then
                Throw New Exception("Unable to instantiate task window.")
            End If

            Dim we = New WindowElement()
            we.WindowType = taskDescription
            we.TaskDescription = taskDescription
            we.ID = Date.Now.Ticks
            we.FormControl = frm
            we.TaskID = taskId
            we.HashCode = frm.GetHashCode()
            we.MenuParameters = taskParameters
            _windowList.Add(we)
            ResetToDefaults(we)

            Dim wNode As TreeNode = InitialDisplayTreeView.Nodes("Windows")
            If wNode IsNot Nothing Then
                we.TreeNode = New TreeNode(we.MenuLabel)
                we.TreeNode.Tag = we.ID.ToString()
                wNode.Nodes.Add(we.TreeNode)
                wNode.Expand()
            End If

            frm.MdiParent = Me
            frm.Dock = DockStyle.Fill
            frm.LoadTask(taskId, parentTaskId)

            If Not (frm.IsDisposed) Then
                frm.Show()
                frm.BringToFront()

                AddHandler frm.FormClosed, AddressOf WindowClosed
            End If
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(ex.Message, "Menu Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' ReplaceForm - open a different form but retain the original form's window element
    ''' </summary>
    ''' <param name="originalForm"></param>
    ''' <param name="formName"></param>
    ''' <param name="menuTitle"></param>
    ''' <param name="FormParameters"></param>
    ''' <remarks></remarks>
    Public Sub ReplaceForm(ByVal originalForm As Form, ByVal formName As String, ByVal menuTitle As String, ByVal FormParameters As String)
        Try
            Const [nameSpace] = "BSDRate"
            Name = [nameSpace] & "." & formName

            Dim we As BSDRateBusiness.WindowElement = FindWindowElement(originalForm)
            we.MenuParameters = FormParameters
            'we.TaskID = rows(0)("TaskID")
            we.TaskID = -1

            Dim assem = Assembly.GetExecutingAssembly()
            Dim frm As Form = DirectCast(assem.CreateInstance(Name, True), Form)
            If frm Is Nothing Then
                Throw New Exception(String.Format("Unable to instantiate the control {0} - check the EntryPoint column in STask for {1}", Name, formName))
            End If
            'frm.TopLevel = False
            'Me.FormsPanel.Controls.Add(frm)
            frm.MdiParent = Me


            we.FormControl = frm
            we.HashCode = frm.GetHashCode()
            we.WindowType = formName
            we.TreeNode.Text = we.MenuLabel




            Dim wNode As TreeNode = InitialDisplayTreeView.Nodes("Windows")
            wNode.Expand()

            'frm.Location = originalForm.Location
            originalForm.WindowState = FormWindowState.Minimized
            frm.Show()
            'frm.BringToFront()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred while replacing form:" + Environment.NewLine + ex.Message, _
                         "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' ResetToDefaults - User clicked on "Reset" button.
    ''' </summary>
    ''' <param name="we"></param>
    ''' <remarks></remarks>
    Public Sub ResetToDefaults(ByVal we As BSDRateBusiness.WindowElement)
        Try
            we.AccrualBasisValue = Convert.ToString(LAccuralBasis.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.AmortizationTypeValue = Convert.ToString(LAmortizationType.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.InterestFrequencyValue = Convert.ToString(LPaymentFrequency.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.PrepaymentTypeValue = Convert.ToString(LPrepaymentType.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.PrepaymentWaiverValue = Convert.ToString(LPrepaymentWaiver.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.PrincipalFrequencyValue = Convert.ToString(LPaymentFrequency.Select("DefaultFlag=True").FirstOrDefault()("Code"))
            we.CustomerName = ""
            we.Lender = ""
            we.DirtyFlag = False
            we.ObligationNumber = ""
            we.ObligorNumber = ""
            we.PrepaymentNumber = 0

        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(ex.Message, "Error resetting defaults", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub


    ''' <summary>
    ''' WindowClosed - this EventHandler is called when one of the windows closes
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Public Sub WindowClosed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim frm As Form = DirectCast(sender, Form)
            For Each we As BSDRateBusiness.WindowElement In _windowList
                If we.HashCode = frm.GetHashCode() Then
                    Dim wNode As TreeNode = InitialDisplayTreeView.Nodes("Windows")
                    wNode.Nodes.Remove(we.TreeNode)
                    _windowList.Remove(we)
                    Exit For
                End If
            Next

            For Each we As BSDRateBusiness.WindowElement In _windowList
                If we.CloseFlag Then
                    we.FormControl.Close()
                    Exit For
                End If
            Next
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred while proceesing form close event:" + Environment.NewLine + ex.Message,
                         "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ''' <summary>
    ''' Find one window element in the list of active window elements
    ''' </summary>
    ''' <param name="frm"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function FindWindowElement(ByVal frm As Form) As BSDRateBusiness.WindowElement
        Try
            For Each we As BSDRateBusiness.WindowElement In _windowList
                If we.HashCode = frm.GetHashCode() Then
                    Return we
                End If
            Next
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show("An error ocurred finding window elemnt from form:" + Environment.NewLine + ex.Message, _
                         "Initial Display Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        Return Nothing
    End Function

#End Region

    Private Sub InitialDisplayTreeView_NodeMouseClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeNodeMouseClickEventArgs) Handles InitialDisplayTreeView.NodeMouseClick
        ' NOTE: The NodeMouseClick event fires when ANY part of a node is clicked (including
        ' the +/- expand/collapse area). We don't want to launch a form when a user is just
        ' expanding or collapsing a node, so we need to determine where on the node they clicked.
        ' You wouldn't think the following would work, but it does because node.Bounds is the
        ' location and size of the label part of the node only. Those microsoft devs are nuts!

        If (e.Node.Bounds.Contains(e.Location)) Then
            InitialDisplayTreeView_AfterSelect(sender, e)
        End If
    End Sub

    ''' <summary>
    ''' InitialDisplayTreeView_AfterSelect - User clicked on a tree view item
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub InitialDisplayTreeView_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeNodeMouseClickEventArgs)
        Try
            '***** Find the entry in _mainMenu for this row ***************
            Dim rows As DataRow() = _mainMenu.Select(String.Format("TaskID={0}", e.Node.Tag))
            If (rows.Count > 0) Then
                'If (String.Compare(rows(0)("RunType").ToString(), "Menu Item", True) = 0) Then
                If Not (String.Compare(rows(0)("RunType").ToString(), "Menu", True) = 0) Then
                    If (rows(0).IsNull("EntryPoint")) Then
                        MessageBox.Show(String.Format("The programming for {0} is not completed", e.Node.Text), "Menu Error", MessageBoxButtons.OK, MessageBoxIcon.Asterisk)
                    Else
                        Dim formParameters As String = String.Empty
                        If rows(0).IsNull("ParameterList") Then formParameters = String.Empty Else formParameters = Convert.ToString(rows(0)("ParameterList"))
                        If (formParameters.Contains("<")) Then
                            App.ReplaceTokens(formParameters)
                        End If
                        'formParameters = rows(0)("TaskDescription")    'Pass the task Description

                        Select Case Convert.ToString(rows(0)("RunType"))
                            Case "Custom Form"
                                LaunchForm(Convert.ToString(rows(0)("EntryPoint")), Convert.ToString(rows(0)("TaskDescription")), formParameters, Convert.ToInt32(rows(0)("TaskId")))
                            Case Else
                                If (rows(0).IsNull("AutomationFlag") OrElse Convert.ToBoolean(rows(0)("AutomationFlag")) = False) Then
                                    Dim parentTaskID As Integer = Convert.ToInt32(If(e.Node.Parent IsNot Nothing, e.Node.Parent.Tag, Nothing))
                                    LaunchTaskForm(Convert.ToInt32(rows(0)("TaskID")), parentTaskID, Convert.ToString(rows(0)("TaskDescription")), formParameters)
                                Else
                                    LaunchTask(Convert.ToInt32(rows(0)("TaskID")))
                                End If
                        End Select
                    End If
                End If

            Else
                '***** The menu option is not from Main Menu.  Perhaps it is an open window ******
                For Each we As BSDRateBusiness.WindowElement In _windowList
                    If we.ID.ToString() = e.Node.Tag.ToString() Then
                        If we.FormControl.WindowState = FormWindowState.Minimized Then
                            we.FormControl.WindowState = FormWindowState.Normal
                        End If
                        we.FormControl.BringToFront()
                        Exit For
                    End If
                Next

            End If

        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
            MessageBox.Show(ex.Message, "Menu Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InitialDisplayTreeView_MouseClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles InitialDisplayTreeView.MouseClick
        Try
            'Allow Right Click to popup choice of Colors for background!
            If e.Button = Windows.Forms.MouseButtons.Right Then
                Debug.Print("TreeView MouseClick")
                Dim cDialog As New ColorDialog()
                cDialog.Color = InitialDisplayTreeView.BackColor ' initial selection is current color.

                If (cDialog.ShowDialog() = DialogResult.OK) Then
                    InitialDisplayTreeView.BackColor = cDialog.Color ' update with user selected color.
                End If
            End If
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
        End Try
    End Sub
    '*********************************************************************************
    ' Name : SetBuildNumber
    ' Description: Get the build number from the App.Config file and display it
    '
    '*********************************************************************************
    Private Sub SetBuildNumber()
        Try
            Dim buildNumber As String = ""
            App.Connector.GetAppConfig("buildnumber", buildNumber, "")
            Me.ToolStripStatusLabelBuildNumber.Text = String.Format("Build: {0}", buildNumber)
        Catch ex As Exception
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
        End Try

    End Sub

    '*********************************************************************************
    ' Name : SetEnvironmentColor
    ' Description: TPP-0001 detolle - Set TreeView background color based on environment
    '              from app.config settings. Production uses default system color.
    '              User can still override via right-click color picker.
    '              If config values are missing or invalid, default system color is used.
    '              Supports both named colors (e.g., "LightBlue") and RGB format (e.g., "183,183,255")
    '*********************************************************************************
    Private Sub SetEnvironmentColor()
        Try
            Dim colorValue As String = String.Empty

            Select Case CommonUI.Connector.Environment
                Case "Development"
                    colorValue = GetSettingOrDefault("DevEnvironmentColor")
                Case "IT"
                    colorValue = GetSettingOrDefault("ITEnvironmentColor")
                Case "UAT"
                    colorValue = GetSettingOrDefault("UATEnvironmentColor")
                Case "Parallel"
                    colorValue = GetSettingOrDefault("ParallelEnvironmentColor")
                Case Else
                    'Production or unknown environments use default system color
                    Exit Sub
            End Select

            If Not String.IsNullOrEmpty(colorValue) Then
                Dim envColor As Color = ParseColorValue(colorValue)
                If envColor <> Color.Empty Then
                    Me.InitialDisplayTreeView.BackColor = envColor
                End If
            End If
        Catch ex As Exception
            'If any error occurs, just leave the default color - don't break the application
            Dim msg As String = String.Format("Exception caught in {0}.{1}(): {2}", (New StackTrace()).GetFrame(0).GetMethod().ReflectedType.Name, (New StackTrace()).GetFrame(0).GetMethod().Name, ex.Message)
            CommonUI.EventLog.LogException(msg, ex.StackTrace)
        End Try
    End Sub

    '*********************************************************************************
    ' Name : ParseColorValue
    ' Description: Parses a color value from string. Supports:
    '              - Named colors (e.g., "LightBlue", "Yellow")
    '              - RGB format (e.g., "183,183,255")
    '              Returns Color.Empty if the value cannot be parsed.
    '*********************************************************************************
    Private Function ParseColorValue(colorValue As String) As Color
        Try
            'First try to parse as RGB format (R,G,B)
            If colorValue.Contains(",") Then
                Dim parts() As String = colorValue.Split(","c)
                If parts.Length = 3 Then
                    Dim r As Integer = Integer.Parse(parts(0).Trim())
                    Dim g As Integer = Integer.Parse(parts(1).Trim())
                    Dim b As Integer = Integer.Parse(parts(2).Trim())
                    If r >= 0 AndAlso r <= 255 AndAlso g >= 0 AndAlso g <= 255 AndAlso b >= 0 AndAlso b <= 255 Then
                        Return Color.FromArgb(r, g, b)
                    End If
                End If
            End If

            'Try as named color
            Dim namedColor As Color = Color.FromName(colorValue)
            'Color.FromName returns a color with IsKnownColor=False and ARGB=0 if invalid
            If namedColor.IsKnownColor OrElse (namedColor.A <> 0 OrElse namedColor.R <> 0 OrElse namedColor.G <> 0 OrElse namedColor.B <> 0) Then
                Return namedColor
            End If
        Catch
            'Parse error - return empty
        End Try
        Return Color.Empty
    End Function

    '*********************************************************************************
    ' Name : GetSettingOrDefault
    ' Description: TPP-0001 detolle - Safely retrieves a setting value from app.config.
    '              Returns empty string if setting is missing or cannot be read.
    '*********************************************************************************
    Private Function GetSettingOrDefault(settingName As String) As String
        Try
            Dim value As Object = My.Settings.Item(settingName)
            If value IsNot Nothing Then
                Return value.ToString()
            End If
        Catch
            'Setting not found or error reading - return empty string
        End Try
        Return String.Empty
    End Function
End Class
