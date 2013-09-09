<%@ WebHandler Language="C#" Class="CheckUsername" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

public class CheckUsername : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        string UserID = context.Request.QueryString["UserID"];
        int check = 0;
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["AssociateConn"].ConnectionString;
            SqlDataReader DataReader = null;

            SqlCommand cmd1 = new SqlCommand();

            cmd1.CommandText = "select UserId from Associate";
            conn.Open();
            cmd1.Connection = conn;
            DataReader = cmd1.ExecuteReader();            
            
            if (DataReader.HasRows)
            {
                while (DataReader.Read())
                {
                    if (DataReader["UserId"].ToString().Equals(UserID))
                    {
                        check = 1;
                        break;
                    }
                    
                }
            }
            conn.Close();

            if(check==1)
                context.Response.Write("failure");
            else
                context.Response.Write("success");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}