using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Web.Security;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using System.Data;

namespace AssociateConnect.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Response.Redirect("../Mobile/Login.htm");
            if (Session["UserName"] != null)
                Session["UserName"] = null;
            if (Session["Role"] != null)
                Session["Role"] = null;

            RegisterHyperLink.NavigateUrl = "Register.aspx?ReturnUrl=" + HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
        }

        protected void Associate_Authenticate(object sender, AuthenticateEventArgs e)
        {
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["AssociateConn"].ConnectionString);
            SqlCommand cmd = sqlConn.CreateCommand();
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandText = "dbo.Get_Login";
            cmd.Parameters.AddWithValue("@id", AssociateLogin.UserName);
            cmd.Parameters.AddWithValue("@password", AssociateLogin.Password);
            if (sqlConn.State != ConnectionState.Open)
                sqlConn.Open();
            object o = cmd.ExecuteScalar();
            int Authenticated = Convert.ToInt32(cmd.ExecuteScalar());
            if (Authenticated == 1)
            {
                HttpContext.Current.Session["UserName"] = AssociateLogin.UserName.ToString();
                SqlCommand cmdRole = sqlConn.CreateCommand();
                cmdRole.CommandType = System.Data.CommandType.StoredProcedure;
                cmdRole.CommandText = "dbo.Get_RoleByUserID";
                cmdRole.Parameters.AddWithValue("@id", AssociateLogin.UserName);
                SqlDataReader rdr = cmdRole.ExecuteReader();
                while (rdr.Read())
                {
                    HttpContext.Current.Session["Role"] = rdr["RoleDesc"].ToString();
                    HttpContext.Current.Session["IsAdmin"] = rdr["IsAdmin"].ToString();
                    HttpContext.Current.Session.Timeout = 15; 
                }
                rdr.Close();
                Response.Redirect("~/default.aspx");
            }
            sqlConn.Close();
        }
    }
}