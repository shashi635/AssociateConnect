using System;
using System.Configuration;
using System.Data.Linq.Mapping;
using System.Data.Linq;
using System.Reflection;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Collections.Generic;
using Microsoft.SqlServer.Server;
using System.Data;

namespace Cog.MLIAD.Data
{
   public partial class AssociateConnDataContext : System.Data.Linq.DataContext
    {
       public AssociateConnDataContext() : base(ConfigurationManager.ConnectionStrings["AssociateConn"].ConnectionString,mappingSource)
        {
            OnCreated();
        }

       public List<Data_Associate> SearchAssociate(int AssociateID, int? DesignationID, string FirstName, string LastName, int? ProjectID, int? LocationID, ref int? count)
       {
           int DesID = (DesignationID == null) ? 0 : Convert.ToInt32(DesignationID);
           int ProID = (ProjectID == null) ? 0 : Convert.ToInt32(ProjectID);
           int LocID = (LocationID == null) ? 0 : Convert.ToInt32(LocationID);
           List<Data_Associate> Associates = new List<Data_Associate>();
           SqlConnection sqlConn = new SqlConnection(base.Connection.ConnectionString);
           using (sqlConn)
           {
               try
               {
                   SqlCommand cmd = sqlConn.CreateCommand();
                   cmd.CommandType = System.Data.CommandType.StoredProcedure;
                   cmd.CommandText = "dbo.Search_Associate";
                   cmd.Parameters.AddWithValue("@AssociateID", AssociateID);
                   cmd.Parameters.AddWithValue("@DesignationID", DesID);
                   cmd.Parameters.AddWithValue("@FirstName", FirstName);
                   cmd.Parameters.AddWithValue("@LastName", LastName);
                   cmd.Parameters.AddWithValue("@ProjectID", ProID);
                   cmd.Parameters.AddWithValue("@LocationID", LocID);

                   if (sqlConn.State != ConnectionState.Open)
                       sqlConn.Open();

                   SqlDataReader rdr = cmd.ExecuteReader();

                   while (rdr.Read())
                   {
                       Data_Associate associate = new Data_Associate()
                       {
                           AssociateID = (rdr["AssociateID"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["AssociateID"].ToString()),
                           FirstName = rdr["FirstName"].ToString(),
                           LastName = rdr["LastName"].ToString(),
                           Mobile = rdr["Mobile"].ToString(),
                           email = rdr["email"].ToString(),
                           DirectReportID = (rdr["DirectReportID"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["DirectReportID"].ToString()),
                           IsActive = (rdr["IsActive"].ToString() == string.Empty) ? false : Convert.ToBoolean(rdr["IsActive"].ToString()),
                           IsApproved = (rdr["IsApproved"].ToString() == string.Empty) ? false : Convert.ToBoolean(rdr["IsApproved"].ToString()),
                           ModifiedBy = (rdr["ModifiedBy"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["ModifiedBy"].ToString()),
                           //ModifiedOn = Convert.ToDateTime(rdr["ModifiedOn"]),
                           ProjectName = rdr["ProjectName"].ToString(),
                           Location = rdr["Location"].ToString(),
                           Designation = rdr["Designation"].ToString(),
                           DOJ = rdr["DOJ"].ToString(),
                           DOB = rdr["DOB"].ToString(),
                           UserId = rdr["UserId"].ToString(),
                       };
                       Associates.Add(associate);
                   }
                   rdr.Close();
               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           return Associates;

       }


       public List<Data_Software> SearchSoftware(int? ResourceID, int? CategoryID, int? ProjectID, ref int? Count)
       {
           Count = 0;
           int ResoID = (ResourceID == null) ? 0 : Convert.ToInt32(ResourceID);
           int CateID = (CategoryID == null) ? 0 : Convert.ToInt32(CategoryID);
           int ProjID = (ProjectID == null) ? 0 : Convert.ToInt32(ProjectID);
           List<Data_Software> softwares = new List<Data_Software>();
           SqlConnection sqlConn = new SqlConnection(base.Connection.ConnectionString);
           using (sqlConn)
           {
               try
               {
                   SqlCommand cmd = sqlConn.CreateCommand();
                   cmd.CommandType = System.Data.CommandType.StoredProcedure;
                   cmd.CommandText = "dbo.Search_Software";
                   cmd.Parameters.AddWithValue("@SoftResourceID", ResoID);
                   cmd.Parameters.AddWithValue("@SoftCategoryID", CateID);
                   cmd.Parameters.AddWithValue("@ProjectID", ProjID);

                   if (sqlConn.State != ConnectionState.Open)
                       sqlConn.Open();
                   SqlDataReader rdr = cmd.ExecuteReader();

                   while (rdr.Read())
                   {
                       Data_Software software = new Data_Software()
                       {
                           SoftRequestID = Convert.ToInt32(rdr["SoftRequestID"].ToString()),
                           SoftCategory = rdr["SoftCategoryDesc"].ToString(),
                           SoftResource = rdr["SoftResourceDesc"].ToString(),
                           SoftVersion = rdr["SoftVersionDesc"].ToString(),
                           ProjectName = rdr["ProjectName"].ToString(),
                       };
                       softwares.Add(software);
                       Count += 1;
                   }
                   rdr.Close();
               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           return softwares;
       }

       public List<Data_Firewall> SearchFirewall(string Destination, int? ProjectID)
       {
           string ProjID = (ProjectID == 0) ? string.Empty : ProjectID.ToString();
           List<Data_Firewall> Firewalls = new List<Data_Firewall>();
           SqlConnection sqlConn = new SqlConnection(base.Connection.ConnectionString);
           using (sqlConn)
           {
               try
               {
                   SqlCommand cmd = sqlConn.CreateCommand();
                   cmd.CommandType = System.Data.CommandType.StoredProcedure;
                   cmd.CommandText = "dbo.Search_Firewall";
                   cmd.Parameters.AddWithValue("@Destination", Destination);
                   cmd.Parameters.AddWithValue("@ProjectID", ProjID);

                   if (sqlConn.State != ConnectionState.Open)
                       sqlConn.Open();
                   SqlDataReader rdr = cmd.ExecuteReader();

                   while (rdr.Read())
                   {
                       Data_Firewall Firewall = new Data_Firewall()
                       {
                           FirewallRequestID = (rdr["FirewallRequestID"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["FirewallRequestID"].ToString()),
                           FirewallRequestDesc = rdr["FirewallRequestDesc"].ToString(),
                           Destination = rdr["Destination"].ToString(),
                           Source = rdr["Source"].ToString(),
                           Port = rdr["Port"].ToString(),
                           ProjectName = rdr["ProjectName"].ToString(),
                       };
                       Firewalls.Add(Firewall);
                   }
                   rdr.Close();
               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           return Firewalls;
       }

       public List<Data_Category> SearchCategory(int CategoryID, string CategoryDesc, int? IsActive)
       {
           List<Data_Category> categories = new List<Data_Category>();
           SqlConnection sqlConn = new SqlConnection(base.Connection.ConnectionString);
           using (sqlConn)
           {
               try
               {
                   int ia = (IsActive == null) ? 0 : Convert.ToInt32(IsActive);
                   SqlCommand cmd = sqlConn.CreateCommand();
                   cmd.CommandType = System.Data.CommandType.StoredProcedure;
                   cmd.CommandText = "dbo.Search_Category";
                   cmd.Parameters.AddWithValue("@CategoryID", CategoryID);
                   cmd.Parameters.AddWithValue("@CategoryDesc", CategoryDesc);
                   cmd.Parameters.AddWithValue("@Isactive", ia);

                   if (sqlConn.State != ConnectionState.Open)
                       sqlConn.Open();

                   SqlDataReader rdr = cmd.ExecuteReader();

                   while (rdr.Read())
                   {
                       Data_Category category = new Data_Category()
                       {
                           CategoryID = (rdr["CategoryID"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["CategoryID"].ToString()),
                           CategoryDesc = rdr["CategoryDesc"].ToString(),
                           IsActive = (rdr["IsActive"].ToString() == string.Empty) ? 0 : Convert.ToInt32(rdr["IsActive"].ToString()),

                       };
                       categories.Add(category);
                   }
                   rdr.Close();
               }
               catch (Exception ex)
               {
                   throw ex;
               }
           }
           return categories;

       }

       public partial class Data_Associate
       {
           public int AssociateID { get; set; }
           public List<Address> Address { get; set; }
           public List<Phone> Phones { get; set; }
           public string FirstName { get; set; }
           public string LastName { get; set; }
           public string Mobile { get; set; }
           public string email { get; set; }
           public int DirectReportID { get; set; }
           public DateTime CreatedOn { get; set; }
           public int? ModifiedBy { get; set; }
           public DateTime? ModifiedOn { get; set; }
           public bool IsApproved { get; set; }
           public string ProjectName { get; set; }
           public string Location { get; set; }
           public string Designation { get; set; }
           public string DOJ { get; set; }
           public string DOB { get; set; }
           public bool? IsActive { get; set; }
           public string UserId { get; set; }
           public string Password { get; set; }
           public Data_Associate()
           {
           }
       }

       public partial class Data_Software
       {
           public int SoftRequestID { get; set; }
           public string SoftResource { get; set; }
           public string SoftCategory { get; set; }
           public string SoftVersion { get; set; }
           public string ProjectName { get; set; }
           public Data_Software()
           {
           }
       }

       public partial class Data_Firewall
       {
           public int FirewallRequestID { get; set; }
           public string FirewallRequestDesc { get; set; }
           public string Destination { get; set; }
           public string Source { get; set; }
           public string Port { get; set; }
           public string ProjectName { get; set; }
           public Data_Firewall()
           {
           }
       }

       public partial class Data_Category
       {
           public int CategoryID { get; set; }
           public string CategoryDesc { get; set; }
           public int? IsActive { get; set; }
           public Data_Category()
           {
           }
       }
    }
}
