using System;
using System.Collections;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace USBank.USBnet.Treasury.Web
{
    /// <summary>
    /// Summary description for ErrorHandler.
    /// </summary>
    public partial class ErrorHandler : System.Web.UI.Page
    {
        protected Support.Header Header1;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //Retrieve exception object from session
                Exception ex = (Exception) Session["Exception"];

                //Set general info
                DateTimeLabel.Text = DateTime.Now.ToShortDateString() + " @ " + DateTime.Now.ToShortTimeString();
                ServerLabel.Text = Server.MachineName.ToString();

                //Get username if the AppUserObject is not null
                if (Header1.AppUserObject != null)
                {
                    UsernameLabel.Text = Header1.AppUserObject.IntranetID();
                }

                PageThrewLabel.Text = Request.FilePath.ToString();
                QuerystringLabel.Text = HttpUtility.HtmlEncode(Request.QueryString.ToString());

                //Set up stack trace dataset
                DataSet stackTrace = new DataSet();

                //Set up exception table
                stackTrace.Tables.Add("exceptions");
                stackTrace.Tables["exceptions"].Columns.Add("Message");
                stackTrace.Tables["exceptions"].Columns.Add("Source");
                stackTrace.Tables["exceptions"].Columns.Add("TargetSite");
                stackTrace.Tables["exceptions"].Columns.Add("StackTrace");
                stackTrace.Tables["exceptions"].Columns.Add("Index");

                //Get exception trace
                CrawlStackTrace(ref stackTrace, ex);

                //Set exception title
                ExceptionLabel.Text = "Exception: " + stackTrace.Tables["exceptions"].Rows[stackTrace.Tables["exceptions"].Rows.Count - 1]["Message"];

                //Bind repeater
                ErrorRepeater.DataSource = new DataView(stackTrace.Tables["exceptions"],null ,"Index DESC", DataViewRowState.CurrentRows);
                ErrorRepeater.DataBind();

                //Set support labels
                //HelpDeskLabel.Text = System.Configuration.ConfigurationManager.AppSettings["HelpDeskPhone"].ToString();
                //OPASGroupLabel.Text = System.Configuration.ConfigurationManager.AppSettings["OPASGroup"].ToString();
            }
        }

        /// <summary>
        /// Build the dataset of stack trace information and exception details
        /// </summary>
        /// <param name="stackTrace">Dataset of stack info</param>
        /// <param name="ex">Current exception</param>
        private void CrawlStackTrace(ref DataSet stackTrace, Exception ex)
        {
            //Set up exception array
            object[] exceptionArray = new object[5];

            //Log this step in the exception chain
            exceptionArray[0] = ex.Message;
            exceptionArray[1] = ex.Source;
            exceptionArray[2] = ex.TargetSite;
            exceptionArray[3] = ex.StackTrace;
            exceptionArray[4] = stackTrace.Tables["exceptions"].Rows.Count + 1;

            //Add this row to the result array
            stackTrace.Tables["exceptions"].Rows.Add(exceptionArray);

            if (ex.InnerException != null)
            {
                //Set a new exception to the inner exception
                Exception newEx = ex.InnerException;

                //Recurse this function
                CrawlStackTrace(ref stackTrace, newEx);
            }
    }

        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }
        
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {    

        }
        #endregion
    }
}
