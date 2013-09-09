<%@ WebHandler Language="C#" Class="SearchState" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

public class SearchState : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string Country = context.Request.QueryString["Country"];
        int i = 0;
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager
                    .ConnectionStrings["AssociateConn"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select State from State where Country='"+Country+"'";
                cmd.Connection = conn;
                StringBuilder sb = new StringBuilder();
                conn.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        if (i != 0)
                        {
                            sb.Append("|");
                        }
                        else 
                        {
                            i = 1;
                        }
                        sb.Append(sdr["State"]);
                    }
                }
                conn.Close();
                context.Response.Write(sb.ToString());
            }
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}