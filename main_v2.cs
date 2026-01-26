#region Namespaces
using System;
using System.Data;
using Microsoft.SqlServer.Dts.Pipeline.Wrapper;
using Microsoft.SqlServer.Dts.Runtime.Wrapper;
using Util;
using System.Collections.Generic;
using System.Linq;
#endregion

/// <summary>
/// SSIS Script Component for building Workday Import_Accounting_Journal XML payload.
/// Uses JournalEntryBuilder to process rows and generate XML with intercompany affiliate worktags.
/// </summary>
[Microsoft.SqlServer.Dts.Pipeline.SSISScriptComponentEntryPointAttribute]
public class ScriptMain : UserComponent
{
    /// <summary>
    /// The builder instance that handles journal entry creation and XML generation.
    /// </summary>
    private JournalEntryBuilder _builder;

    /// <summary>
    /// Called once before rows begin to be processed in the data flow.
    /// </summary>
    public override void PreExecute()
    {
        base.PreExecute();
        _builder = new JournalEntryBuilder();
    }

    /// <summary>
    /// Called after all rows have passed through this component.
    /// Finalizes the payload and outputs the XML.
    /// </summary>
    public override void PostExecute()
    {
        Variables.WorkdayXMLPayload = _builder.FinalizeAndGetXml();
        base.PostExecute();
    }

    /// <summary>
    /// Processes each input row from the data flow and adds it as a journal entry line.
    /// </summary>
    /// <param name="Row">The row that is currently passing through the component.</param>
    public override void Input0_ProcessInputRow(Input0Buffer Row)
    {
        bool success = _builder.AddJournalEntry(
            Row.BankNumber,
            Row.CostCenter,
            Row.Account,
            Row.SpendCategoryID,
            Row.RevenueCategoryID,
            Row.TransactionAmount,
            Row.CRDBFLAG,
            Row.TransactionDescription
        );

        if (!success)
        {
            bool cancel;
            ComponentMetaData.FireError(0, "AddJournalEntry", "Failed to add journal entry.", "", 0, out cancel);
            throw new Exception("AddJournalEntry failed. Stopping data flow.");
        }
    }
}
