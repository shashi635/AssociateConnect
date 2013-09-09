<%@ WebHandler Language="C#" Class="SearchCity" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

public class SearchCity : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        string State = context.Request.QueryString["State"];
        int i = 0;
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager
                    .ConnectionStrings["AssociateConn"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select City from City where State='"+State+"'";
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
                        sb.Append(sdr["City"]);
                        //sb.Append(sdr["State"]).Append(Environment.NewLine);
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