using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Text;
using System.Net;
using System.Net.Mail;
using Cog.MLIAD.Data;
using Cog.MLIAD.BusinessLogic;
using Cog.MLIAD.BusinessLogic.Associate;
using System.IO;


namespace Cog.MLIAD.BusinessLogic.Data
{
    public class AssociateRepository : iAssociateRepository
    {
        #region AssociateConnect
        
        #region Associate
        public Associate.Associate GetAssociate(string userid)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var associate = (from a in asscon.Associates
                                 where a.UserId == userid
                                 select new Associate.Associate()
                              {
                                  AssociateID = a.AssociateID ,
                                  DesignationID = a.DesignationID ,
                                  DirectReportID =a.DirectReportID ,
                                  DOB =a.DOB ,
                                  DOJ =a.DOJ ,
                                  email =a.email ,
                                  FirstName =a.FirstName ,
                                  LastName =a.LastName ,
                                  LocationID =a.LocationID ,
                                  Mobile =a.Mobile

                              }).SingleOrDefault<Associate.Associate>();
                return  associate;
            }
        }
        public string AddAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Add_Associate(associate.AssociateID, associate.FirstName, associate.LastName, associate.Mobile, associate.email, associate.DirectReportID, associate.IsApproved, associate.ProjectID, associate.LocationID, associate.DesignationID, associate.DOJ, associate.DOB, associate.IsActive, associate.UserID, associate.Password, associate.GroupID);
                    if (!(retasct == 0))
                    {
                        BusinessLogic.Associate.Associate approver = (from a in asscon.get_AdminByGroup(associate.GroupID)
                                                                      select new Cog.MLIAD.BusinessLogic.Associate.Associate()
                                                                      {
                                                                          AssociateID = a.AssociateID,
                                                                          FirstName = (a.FirstName == null) ? "" : a.FirstName,
                                                                          LastName = (a.LastName == null) ? "" : a.LastName,
                                                                          Mobile = (a.Mobile == null) ? "" : a.Mobile,
                                                                          email = (a.email == null) ? "" : a.email,
                                                                          UserID = (a.UserId == null) ? "" : a.UserId
                                                                      }).SingleOrDefault<Cog.MLIAD.BusinessLogic.Associate.Associate>();
                        
                        string sendSubject = "Pending Request";
                        string mailbody = "<html><body>Dear " + approver.FirstName + ",<br /> You have pending request to approve for " + associate.FirstName + " " + associate.LastName + ".<br / >Please login to www.AssociateConnect.com to approve the request.<br / ><br />Regards,<br />AssociateConnect Admin Team<body><html>";
                        SendEmail(sendSubject, mailbody, associate.email, approver.email,true);
                        sendSubject = "Request Summited";
                        mailbody = "<html><body>Dear " + associate.FirstName + ",<br /> your request is successfully submitted to" + approver.FirstName + " " + approver.LastName + " for approval.<br / >You will get confirmation mail once your request gets appreved.<br / ><br />Regards,<br />AssociateConnect Admin Team<body><html>";
                        SendEmail(sendSubject, mailbody, approver.email, associate.email,true);

                        BusinessLogic.Associate.SMS sms = new SMS();
                        sms.smsBody = "You have pending request to approve for " + associate.FirstName + " " + associate.LastName + ".";
                        sms.toList = approver.Mobile;
                        SendSMS(sms);
                        sms.smsBody = "your request is successfully submitted to" + approver.FirstName + " " + approver.LastName + " for approval.";
                        sms.toList = associate.Mobile;
                        SendSMS(sms);
                        
                        return "success";
                    }
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string AddMobileAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Add_MobileAssociate(associate.AssociateID, associate.FirstName, associate.LastName, associate.Mobile, associate.email,true, associate.Password,associate.Gender);
                    if (!(retasct == 0))
                    {
                        return "success";
                    }
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string AddPhone(Associate.Phone phone, string AssociateID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retphn = 0;
                    int AssoID = Convert.ToInt32(AssociateID);
                    retphn = asscon.Add_Phone(AssoID, phone.PhoneTypeID, phone.PhoneNo);
                    if (!(retphn == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string AddAddress(Associate.Address address, string AssociateID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retadd = 0;
                    int AssoID = Convert.ToInt32(AssociateID);
                    retadd = asscon.Add_Address(AssoID, address.AddressTypeID, address.Address1, address.Address2, address.Address3, address.City, address.State, address.Country, address.Zip);
                    if (!(retadd == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string EditAssociate(Associate.Associate associate)
        {
            int AssociateID = Convert.ToInt32(associate.id);
            int ProjectID = Convert.ToInt32(associate.ProjectName);
            int LocationID = Convert.ToInt32(associate.Location);
            int DesignationID = Convert.ToInt32(associate.Designation);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Edit_Associate(AssociateID, associate.DirectReportID, associate.DOB, associate.DOJ, associate.email, associate.FirstName, associate.IsActive, associate.LastName, associate.Mobile, associate.ModifiedBy, DesignationID, LocationID, ProjectID);
                    //foreach (var Adrs in associate.Address)
                    //{
                    //    retadd=asscon.Edit_Address(associate.AssociateID, Adrs.Address1, Adrs.Address2, Adrs.Address3, Adrs.City, Adrs.State, Adrs.Country, Adrs.Zip, Adrs.AddressTypeID);
                    //}
                    //foreach (var Phn in associate.Phones)
                    //{
                    //    retphn=asscon.Edit_Phone(associate.AssociateID, Phn.PhoneNo, Phn.PhoneTypeID);
                    //}
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public string DeleteAssociate(string id)
        {
            int AssociateID = Convert.ToInt32(id);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Delete_Associate(AssociateID);
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public List<Cog.MLIAD.BusinessLogic.Associate.Associate> SearchAssociate(Associate.Associate associate, int pageIndex, int pageSize, ref int? count)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int AssociateID = Convert.ToInt32(associate.AssociateID);
                    var associates = (from a in asscon.SearchAssociate(AssociateID, associate.DesignationID, associate.FirstName, associate.LastName, associate.ProjectID, associate.LocationID, ref count)
                                      select new Cog.MLIAD.BusinessLogic.Associate.Associate()
                                      {
                                          AssociateID = a.AssociateID,
                                          FirstName = (a.FirstName == null) ? "" : a.FirstName,
                                          LastName = (a.LastName == null) ? "" : a.LastName,
                                          Mobile = (a.Mobile == null) ? "" : a.Mobile,
                                          email = (a.email == null) ? "" : a.email,
                                          DirectReportID = a.DirectReportID,
                                          IsActive = (a.IsActive == null) ? false : a.IsActive,
                                          IsApproved = a.IsApproved,
                                          ModifiedBy = (a.ModifiedBy == null) ? 0 : a.ModifiedBy,
                                          ModifiedOn = (a.ModifiedOn == null) ? null : a.ModifiedOn,
                                          DOJ = (a.DOJ == null) ? "" : a.DOJ,
                                          DOB = (a.DOB == null) ? "" : a.DOB,
                                          ProjectName = (a.ProjectName == null) ? "" : a.ProjectName,
                                          Location = (a.Location == null) ? "" : a.Location,
                                          Designation = (a.Designation == null) ? "" : a.Designation,
                                          UserID = (a.UserId == null) ? "" : a.UserId
                                      }).ToList<Cog.MLIAD.BusinessLogic.Associate.Associate>();

                    List<Cog.MLIAD.BusinessLogic.Associate.Associate> list = new List<Cog.MLIAD.BusinessLogic.Associate.Associate>();
                    list = associates;

                    pageSize = (pageSize < 1 ? 10 : pageSize);
                    pageIndex = (pageIndex < 0 ? 0 : pageIndex);
                    count = list.Count;
                    if (count < pageSize)
                    {
                        pageIndex = 0;
                        return list;
                    }
                    else if (list.Count < pageSize * pageIndex)
                    {
                        pageIndex = 0;
                        return new List<BusinessLogic.Associate.Associate>(list.Take(pageSize));
                    }
                    else
                    {
                        int a = Convert.ToInt32(((count - pageSize * pageIndex) >= pageSize) ? pageSize : (count - pageSize * pageIndex));
                        return new List<BusinessLogic.Associate.Associate>(list.Skip(pageSize * pageIndex).Take(a));
                    }


                    //foreach (var asct in associates)
                    //{
                    //    var address = (from add in asscon.Search_Address(asct.AssociateID)
                    //                     select new Cog.MLIAD.BusinessLogic.Associate.Address()
                    //                     {
                    //                         Address1=add.Address1,
                    //                         Address2=add.Address2,
                    //                         Address3=add.Address3,
                    //                         City=add.City,
                    //                         State=add.State,
                    //                         Country=add.Country,
                    //                         Zip=add.Zip,
                    //                         AddressTypeID=add.AddressTypeID
                    //                     }).ToList<Cog.MLIAD.BusinessLogic.Associate.Address>();
                    //    asct.Address = address;
                    //    var Phone = (from phn in asscon.Search_Phone(asct.AssociateID)
                    //                 select new Cog.MLIAD.BusinessLogic.Associate.Phone()
                    //                 {
                    //                     PhoneNo=phn.Phone,
                    //                     PhoneTypeID =Convert.ToInt32(phn.PhoneTypeID)
                    //                 }).ToList<Cog.MLIAD.BusinessLogic.Associate.Phone>();
                    //    asct.Phones = Phone;
                    //    list.Add(asct);
                    //}
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public List<Associate.Designation> GetDesignation()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var designations = (from a in asscon.Get_Designation()
                                    select new Associate.Designation()
                                    {
                                        DesignationID = a.DesignationID,
                                        DesignationName = a.Designation
                                    }).ToList<Associate.Designation>();
                return designations;
            }
        }

        public List<Associate.Location> GetLocation()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var locations = (from a in asscon.Get_Location()
                                 select new Associate.Location()
                                 {
                                     LocationID = a.LocationID,
                                     LocationName = a.Location
                                 }).ToList<Associate.Location>();
                return locations;
            }
        }

        public List<Associate.PhoneType> GetPhoneType()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var types = (from a in asscon.Get_PhoneType()
                             select new Associate.PhoneType()
                             {
                                 PhoneTypeID = Convert.ToInt32(a.PhoneTypeID),
                                 PhoneTypeDesc = a.PhoneType
                             }).ToList<Associate.PhoneType>();
                return types;
            }
        }

        public List<Associate.AddressType> GetAddressType()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var types = (from a in asscon.Get_AddressType()
                             select new Associate.AddressType()
                             {
                                 AddressTypeID = a.AddressTypeID,
                                 AddressTypeDesc = a.AddressType
                             }).ToList<Associate.AddressType>();
                return types;
            }
        }

        public List<Associate.Practice> GetPractice()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var practices = (from a in asscon.Get_Practice()
                                 select new Associate.Practice()
                                 {
                                     PracticeID = a.PracticeID,
                                     PracticeName = a.PracticeName
                                 }).ToList<Associate.Practice>();
                return practices;
            }
        }

        public List<Associate.Account> GetAccount(int PracticeID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var accounts = (from a in asscon.Get_Account(PracticeID)
                                select new Associate.Account()
                                {
                                    AccountID = a.AccountID,
                                    AccountName = a.AccountName
                                }).ToList<Associate.Account>();
                return accounts;
            }
        }

        public List<Associate.Project> GetProject()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var projects = (from a in asscon.Get_Project()
                                select new Associate.Project()
                                {
                                    ProjectID = a.ProjectID,
                                    ProjectName = a.ProjectName
                                }).ToList<Associate.Project>();
                return projects;
            }
        }

        public List<Associate.Associate> GetApprovalRequest()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var ids = (from a in asscon.Get_ApprovalRequest()
                           select new Associate.Associate()
                           {
                               AssociateID = a.AssociateID
                           }).ToList<Associate.Associate>();
                return ids;
            }
        }

        public Associate.Associate GetAssociateByID(string AssociateID)
        {
            int id = (AssociateID == string.Empty) ? 0 : Convert.ToInt32(AssociateID);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var associates = (from a in asscon.Get_AssociateByID(id)
                                  select new Associate.Associate()
                                  {
                                      AssociateID = a.AssociateID,
                                      FirstName = a.FirstName,
                                      LastName = a.LastName,
                                      Designation = a.Designation,
                                      Practice = a.PracticeName,
                                      Account = a.AccountName,
                                      Location = a.Location,
                                      email = a.email,
                                      Mobile = a.Mobile,
                                      DOJ = a.DOJ,
                                      ProjectName = a.ProjectName,
                                      Gender = a.Gender 
                                  }).SingleOrDefault<Associate.Associate>();
                return associates;
            }
        }

        public List<Associate.Role> GetRole()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var roles = (from a in asscon.Get_Role()
                             select new Associate.Role()
                             {
                                 RoleID = a.RoleID,
                                 RoleDesc = a.RoleDesc
                             }).ToList<Associate.Role>();
                return roles;
            }
        }

        public List<Associate.Group> GetGroup()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var groups = (from a in asscon.Get_Group()
                              select new Associate.Group()
                              {
                                  GroupID = a.GroupID,
                                  GroupDesc = a.GroupName
                              }).ToList<Associate.Group>();
                return groups;
            }
        }

        public int ApproveRequest(string AssociateID, string RoleID, string[] GroupIDs, string ApproverUserName)
        {
            int retval = 0;
            BusinessLogic.Associate.Associate approver = new BusinessLogic.Associate.Associate();
            BusinessLogic.Associate.Associate requester = new BusinessLogic.Associate.Associate();
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                int id = (AssociateID == "") ? 0 : Convert.ToInt32(AssociateID);
                int rid = (RoleID == "") ? 0 : Convert.ToInt32(RoleID);
                foreach (string GroupID in GroupIDs)
                {
                    int gid = (GroupID == "") ? 0 : Convert.ToInt32(GroupID);
                    retval = asscon.ApproveMember(id, rid, gid);
                }
                requester = GetAssociateByID(id.ToString());
                approver = GetAssociatesByUserID(ApproverUserName);
                approver = GetAssociateByID(approver.AssociateID.ToString());
            }
            string sendSubject = "Request Approved";
            string mailbody = "<html><body>Dear " + requester.FirstName + ",<br /> Your request has been successfuly approved by " + approver.FirstName + " " + approver.LastName + ".<br />You can logon to www.AssociateConnect.com<br /><br />Regards,<br />AssociateConnect Admin Team<body><html>";
            SendEmail(sendSubject, mailbody, approver.email, requester.email, true);

            sendSubject = "Request Approved";
            mailbody = "<html><body>Dear " + approver.FirstName + ",<br /> You have successfully approved the request of " + requester.FirstName + " " + requester.LastName + ".<br / ><br />Regards,<br />AssociateConnect Admin Team<body><html>";
            SendEmail(sendSubject, mailbody, requester.email, approver.email, true);

            BusinessLogic.Associate.SMS sms = new SMS();
            sms.smsBody = "Your request is approved by " + approver.FirstName + " " + approver.LastName + ". Now you can login to www.AssociateConnect.com";
            sms.toList = requester.Mobile;
            SendSMS(sms);

            sms.smsBody = "You have successfully approved the request of " + requester.FirstName + " " + requester.LastName + ". You can logon to www.AssociateConnect.com.";
            sms.toList = approver.Mobile;
            SendSMS(sms);

            return retval;

        }


        public int RejectRequest(string AssociateID, string Group, string Role, string ApproverUserName)
        {
            int retval = 0;
            int id = (AssociateID == "") ? 0 : Convert.ToInt32(AssociateID);
            BusinessLogic.Associate.Associate approver = new BusinessLogic.Associate.Associate();
            BusinessLogic.Associate.Associate requester = new BusinessLogic.Associate.Associate();
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                requester = GetAssociateByID(id.ToString());
                approver = GetAssociatesByUserID(ApproverUserName);
                approver = GetAssociateByID(approver.AssociateID.ToString());
                retval = asscon.RejectMember(id);
            }
            string sendSubject = "Request Rejected";
            string mailbody = "<html><body>Dear " + requester.FirstName + ",<br /> Your request has been rejected by " + approver.FirstName + " " + approver.LastName + ".<br /><br />Regards,<br />AssociateConnect Admin Team<body><html>";
            SendEmail(sendSubject, mailbody, approver.email, requester.email, true);

            sendSubject = "Request Approved";
            mailbody = "<html><body>Dear " + approver.FirstName + ",<br /> You have successfully rejected the request of " + requester.FirstName + " " + requester.LastName + ".<br / ><br />Regards,<br />AssociateConnect Admin Team<body><html>";
            SendEmail(sendSubject, mailbody, requester.email, approver.email, true);

            BusinessLogic.Associate.SMS sms = new SMS();
            sms.smsBody = "Your request is rejected by " + approver.FirstName + " " + approver.LastName + ".";
            sms.toList = requester.Mobile;
            SendSMS(sms);

            sms.smsBody = "You have successfully rejected the request of " + requester.FirstName + " " + requester.LastName + ".";
            sms.toList = approver.Mobile;
            SendSMS(sms);

            return retval;
        }
        
        public int CreateGroup(string gName, string gDesc)
        {
            int retval = 0;
            try
            {
                using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                {
                    int gid = asscon.CreateGroup(gName, gDesc);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return retval;
        }

        public int UpdateGroup(string GroupID, string RoleID, string[] AddList, string[] RemoveList)
        {
            int retval = 0;
            int gid = Convert.ToInt32(GroupID);
            int rid = Convert.ToInt32(RoleID);
            try
            {
                using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                {
                    if (AddList[0] != "none")
                    {
                        foreach (string AssociateID in AddList)
                        {
                            int id = Convert.ToInt32(AssociateID);
                            retval = asscon.AddToGroup(id, gid, rid);
                        }
                    }
                    //if (RemoveList[0] != "none")
                    //{
                    //    foreach (string AssociateID in RemoveList)
                    //    {
                    //        int id = Convert.ToInt32(AssociateID);
                    //        retval = asscon.RemoveFromGroup(id, gid, rid);
                    //    }
                    //}
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return retval;
        }

        public List<BusinessLogic.Associate.Associate> GetAssociatesPerGroup(int groupid)
        {
            try
            {

                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var assoList = (from d in asso.Get_AssoListPerGroup(groupid)
                                    select new Associate.Associate
                                    {
                                        AssociateID = d.AssociateID,
                                        FirstName = d.FirstName,
                                        LastName = d.LastName,
                                        email = d.email,
                                        Mobile = d.Mobile
                                    }).ToList<Associate.Associate>();


                    return assoList;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Associate> GetAssociatesPerGroupAndRole(int groupid, int roleid)
        {
            try
            {

                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var assoList = (from d in asso.GetMemberByGroupAndRole(groupid, roleid)
                                    select new Associate.Associate
                                    {
                                        AssociateID = d.AssociateID,
                                        FirstName = d.FirstName,
                                        LastName = d.LastName
                                    }).ToList<Associate.Associate>();
                    return assoList;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public BusinessLogic.Associate.Associate GetAssociatesByUserID(string UserID)
        {
            try
            {

                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var associate = (from d in asso.Get_AssociateByUserID(UserID)
                                     select new Associate.Associate
                                     {
                                         AssociateID = d.AssociateID,
                                         FirstName = d.FirstName,
                                         LastName = d.LastName
                                     }).SingleOrDefault<Associate.Associate>();


                    return associate;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<Cog.MLIAD.BusinessLogic.Associate.Category> SearchCategory(Associate.Category search, int pageIndex, int pageSize, ref int? count)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    //int CategoryID = (search.CategoryID == "")?0: Convert.ToInt32(search.CategoryID);
                    var associates = (from a in asscon.SearchCategory(search.CategoryID, search.CategoryDesc, search.IsActive)
                                      select new Cog.MLIAD.BusinessLogic.Associate.Category()
                                      {
                                          CategoryID = a.CategoryID,
                                          CategoryDesc = a.CategoryDesc,
                                          IsActive = a.IsActive
                                      }).ToList<Cog.MLIAD.BusinessLogic.Associate.Category>();

                    List<Cog.MLIAD.BusinessLogic.Associate.Category> list = new List<Cog.MLIAD.BusinessLogic.Associate.Category>();
                    list = associates;

                    pageSize = (pageSize < 1 ? 10 : pageSize);
                    pageIndex = (pageIndex < 0 ? 0 : pageIndex);
                    count = list.Count;
                    if (count < pageSize)
                    {
                        pageIndex = 0;
                        return list;
                    }
                    else if (list.Count < pageSize * pageIndex)
                    {
                        pageIndex = 0;
                        return new List<BusinessLogic.Associate.Category>(list.Take(pageSize));
                    }
                    else
                    {
                        int a = Convert.ToInt32(((count - pageSize * pageIndex) >= pageSize) ? pageSize : (count - pageSize * pageIndex));
                        return new List<BusinessLogic.Associate.Category>(list.Skip(pageSize * pageIndex).Take(a));
                    }

                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public string AddCategory(Cog.MLIAD.BusinessLogic.Associate.Category category)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Add_Category(category.CategoryDesc, category.IsActive);
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string EditCategory(Associate.Category category)
        {
            int CategoryID = Convert.ToInt32(category.CategoryID);
            int IsActive = Convert.ToInt32(category.IsActive);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retval = 0;
                    retval = asscon.Update_Category(CategoryID, category.CategoryDesc, IsActive);
                    if (!(retval == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public string DeleteCategory(string id)
        {
            int CategoryID = Convert.ToInt32(id);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Delete_Category(CategoryID);
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        #endregion

        #region Software

        public string AddSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retval = asscon.Add_Software(software.SoftResourceID, software.SoftCategoryID, software.SoftVersionID, software.ProjectID);
                    if (retval == 1)
                        return "sucess";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public string EditSoftware(Associate.SoftwareRequest software)
        {
            int SoftRequestID = Convert.ToInt32(software.id);
            int SoftCategoryID = Convert.ToInt32(software.SoftCategory);
            int SoftResourceID = Convert.ToInt32(software.SoftResource);
            int SoftVersionID = Convert.ToInt32(software.SoftVersion);
            int ProjectID = Convert.ToInt32(software.ProjectName);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retval = asscon.Edit_Software(SoftRequestID, SoftResourceID, SoftCategoryID, SoftVersionID, ProjectID);
                    if (retval == 1)
                        return "sucess";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public string DeleteSoftware(string id)
        {
            int SoftRequestID = Convert.ToInt32(id);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Delete_Software(SoftRequestID);
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public List<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> SearchSoftware(Associate.SoftwareRequest software, int pageIndex, int pageSize, ref int? count)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest retval = new Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest();
                    var softwares = (from s in asscon.SearchSoftware(software.SoftResourceID, software.SoftCategoryID, software.ProjectID, ref count)
                                     select new Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest()
                                     {
                                         SoftRequestID = s.SoftRequestID,
                                         SoftCategory = s.SoftCategory,
                                         SoftResource = s.SoftResource,
                                         SoftVersion = s.SoftVersion,
                                         ProjectName = s.ProjectName
                                     }).ToList<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest>();


                    pageSize = (pageSize < 1 ? 10 : pageSize);
                    pageIndex = (pageIndex < 0 ? 0 : pageIndex);
                    count = softwares.Count;
                    if (count < pageSize)
                    {
                        pageIndex = 0;
                        return softwares;
                    }
                    else if (softwares.Count < pageSize * pageIndex)
                    {
                        pageIndex = 0;
                        return new List<BusinessLogic.Associate.SoftwareRequest>(softwares.Take(pageSize));
                    }
                    else
                    {
                        int a = Convert.ToInt32(((count - pageSize * pageIndex) >= pageSize) ? pageSize : (count - pageSize * pageIndex));
                        return new List<BusinessLogic.Associate.SoftwareRequest>(softwares.Skip(pageSize * pageIndex).Take(a));
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public List<Associate.SoftwareCategory> GetSoftwareCategory()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var categories = (from a in asscon.Get_SoftwareCategory()
                                  select new Associate.SoftwareCategory()
                                  {
                                      SoftwareCategoryID = a.SoftCategoryID,
                                      SoftwareCategoryDesc = a.SoftCategoryDesc
                                  }).ToList<Associate.SoftwareCategory>();
                return categories;
            }
        }

        public List<Associate.SoftwareResource> GetSoftwareResource(int softCategoryID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var resources = (from a in asscon.Get_SoftwareResource(softCategoryID)
                                 select new Associate.SoftwareResource()
                                 {
                                     SoftwareResourceID = a.SoftResourceID,
                                     SoftwareResourceDesc = a.SoftResourceDesc
                                 }).ToList<Associate.SoftwareResource>();
                return resources;
            }
        }

        public List<Associate.SoftwareVersion> GetSoftwareVersion(int softResourceID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var resources = (from a in asscon.Get_SoftwareVersion(softResourceID)
                                 select new Associate.SoftwareVersion()
                                 {
                                     SoftwareVersionID = a.SoftVersionID,
                                     SoftwareVersionDesc = a.SoftVersionDesc
                                 }).ToList<Associate.SoftwareVersion>();
                return resources;
            }
        }
        #endregion

        #region Firewall

        public string AddFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retval = asscon.Add_Firewall(firewall.FirewallRequestDesc, firewall.Destination, firewall.Source, firewall.Port, firewall.ProjectID);
                    if (retval == 1)
                        return "sucess";
                    else
                        return "failure";

                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string EditFirewall(Associate.FirewallRequest firewall)
        {
            int RequestedID = Convert.ToInt32(firewall.id);
            int ProjectID = Convert.ToInt32(firewall.ProjectName);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retval = asscon.Edit_Firewall(RequestedID, firewall.FirewallRequestDesc, firewall.Destination, firewall.Source, firewall.Port, ProjectID);
                    if (retval == 1)
                        return "sucess";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
        }

        public string DeleteFirewall(string id)
        {
            int RequestedID = Convert.ToInt32(id);
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    int retasct = 0;
                    retasct = asscon.Delete_Firewall(RequestedID);
                    if (!(retasct == 0))
                        return "success";
                    else
                        return "failure";
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }


        public List<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> SearchFirewall(Associate.FirewallRequest firewall, int pageIndex, int pageSize, ref int? count)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                try
                {
                    Cog.MLIAD.BusinessLogic.Associate.FirewallRequest retval = new Cog.MLIAD.BusinessLogic.Associate.FirewallRequest();
                    var firewalls = (from f in asscon.SearchFirewall(firewall.Destination, firewall.ProjectID)
                                     select new Cog.MLIAD.BusinessLogic.Associate.FirewallRequest()
                                     {
                                         FirewallRequestID = f.FirewallRequestID,
                                         FirewallRequestDesc = f.FirewallRequestDesc,
                                         Destination = f.Destination,
                                         Source = f.Source,
                                         Port = f.Port,
                                         ProjectName = f.ProjectName
                                     }
                                    ).ToList<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest>();
                    pageSize = (pageSize < 1 ? 10 : pageSize);
                    pageIndex = (pageIndex < 0 ? 0 : pageIndex);
                    count = firewalls.Count;
                    if (count < pageSize)
                    {
                        pageIndex = 0;
                        return firewalls;
                    }
                    else if (firewalls.Count < pageSize * pageIndex)
                    {
                        pageIndex = 0;
                        return new List<BusinessLogic.Associate.FirewallRequest>(firewalls.Take(pageSize));
                    }
                    else
                    {
                        int a = Convert.ToInt32(((count - pageSize * pageIndex) >= pageSize) ? pageSize : (count - pageSize * pageIndex));
                        return new List<BusinessLogic.Associate.FirewallRequest>(firewalls.Skip(pageSize * pageIndex).Take(a));
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        #endregion

        #region user
        //public User GetUserInfo(string userID)
        //{
        //    using (CashNonCashDataContext comp = new CashNonCashDataContext())
        //    {
        //        User user = (from u in comp.GetUserTypeByUserID(userID)
        //                     select new User
        //                     {
        //                         UserID = userID,
        //                         EmployeeID = u.EmployeeID,
        //                         UserType = u.ApproverTypeID,
        //                         FirstName = u.Firstname,
        //                         LastName = u.Lastname,
        //                         EmailAddress = u.Email
        //                     }).FirstOrDefault();
        //        return user;
        //    }
        //}
        #endregion

        #region Discussion
        public List<Associate.Discussion> GetTopics(int CategoryID, int groupID)
        {
            try
            {

                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var discussions = (from d in asso.Get_Topics(CategoryID, groupID)
                                       orderby d.PostDateTime descending
                                       where d.IsParent == true
                                       select new Associate.Discussion
                                      {
                                          TopicDesc = d.TopicDesc,
                                          TopicHeader = d.topicheader,
                                          TopicID = d.TopicID,
                                          PostDateTime = d.PostDateTime,
                                          IsParent = d.IsParent,
                                          CreatedBy = d.CreatedBy,
                                          CreatedByname=d.FirstName + " " + d.LastName ,
                                          CommentCount = d.CommentCount,
                                          Category = new Category { CategoryID = d.CategoryID, IsActive = d.IsActive, CategoryDesc = d.CategoryDesc },
                                          Group = new Group { GroupID = d.GroupID, GroupDesc = d.GroupDesc },

                                      });
                    List<Associate.Discussion> diss = new List<Associate.Discussion>(discussions);
                    return diss;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public Associate.Discussion GetTopic(int topicID)
        {
            try
            {
              
                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var discussion = (from d in asso.Get_Topic(topicID)
                                       orderby d.PostDateTime descending
                                       where d.TopicID == topicID
                                       select new Associate.Discussion
                                       {
                                           TopicDesc = d.TopicDesc,
                                           TopicHeader = d.topicheader,
                                           TopicID = d.TopicID,
                                           PostDateTime = d.PostDateTime,
                                           IsParent = d.IsParent,
                                           CreatedBy = d.CreatedBy,
                                           CreatedByname = d.FirstName + " " + d.LastName,
                                           CommentCount = d.CommentCount,
                                           Category = new Category { CategoryID = d.CategoryID, CategoryDesc = d.CategoryDesc },
                                           Group = new Group { GroupID = d.GroupID, GroupDesc = d.GroupDesc },
                                           
                                       }).SingleOrDefault();

                    return discussion;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<Associate.DiscussionDetails> GetTopicDetails(int topicID)
        {
            try
            {

                using (AssociateConnDataContext asso = new AssociateConnDataContext())
                {
                    var dissDetails = (from d in asso.Get_TopicDetails(topicID)
                                       orderby d.CreatedOn descending
                                       select new Associate.DiscussionDetails
                                       {
                                           TopicDetailID = d.DiscussionDetailID,
                                           DetailDesc = d.DetailDesc,
                                           CreatedOn = d.CreatedOn,
                                           CreatedBy = d.CreatedBy,
                                           CreatedByname = d.CreatedByName,
                                           ParentID = topicID,

                                       }).ToList<Associate.DiscussionDetails>();

                    return dissDetails;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Associate.Category> GetCategories()
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var groups = (from a in asscon.Get_Category()
                              select new Associate.Category()
                              {
                                  CategoryID = a.CategoryID,
                                  CategoryDesc = a.CategoryDesc 
                              }).ToList<Associate.Category>();
                return groups;
            }
        }

        public List<Associate.Group> GetGroupsByUser(int uid)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var groups = (from a in asscon.Get_GroupByID(uid)
                              select new Associate.Group()
                              {
                                  GroupID = a.GroupID,
                                  GroupDesc = a.GroupName
                              }).ToList<Associate.Group>();
                return groups;
            }
        }

        public List<Associate.Group> GetGroupsByID(int AssociateID)
        {
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var groups = (from a in asscon.Get_GroupByID(AssociateID)
                              select new Associate.Group()
                              {
                                  GroupID = a.GroupID,
                                  GroupDesc = a.GroupName
                              }).ToList<Associate.Group>();
                return groups;
            }
        }
        
        public int PostTopic(Cog.MLIAD.BusinessLogic.Associate.Discussion newtopic)
        {
            int retVal = 0;
            try
            {
                using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                {
                    retVal = asscon.Post_NewTopic(newtopic.TopicHeader, newtopic.IsParent, newtopic.CreatedBy, newtopic.GroupID, newtopic.TopicDesc, newtopic.Category.CategoryID);
                }
            }
            catch (Exception e)
            {
                throw e;
            }
            return retVal;
        }

        public int ReplyToPostTopic(Cog.MLIAD.BusinessLogic.Associate.Discussion replytopic)
        {
            int retVal = 0;
            try
            {
                using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                {
                    retVal = asscon.Post_ReplyToTopic(replytopic.TopicID, replytopic.CreatedBy, replytopic.TopicDesc);
                }
            }
            catch (Exception e)
            {
                throw e;
            }
            return retVal;
        }

        public int SaveMessage(int AssociateID, int GroupID, string Message)
        {
            int retVal = 0;
            try
            {
                using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                {
                    retVal = asscon.Save_Message(AssociateID, GroupID, Message);
                }
            }
            catch (Exception e)
            {
                throw e;
            }
            return retVal;
        }
        #endregion

        #region SMS

        public string SendSMS(Cog.MLIAD.BusinessLogic.Associate.SMS newSMS)
        {
            string retVal = "Sent failed..";
            //string status;
            //newSMS.userID = "8961540630";
            //newSMS.password = "cognizant";

            //CookieContainer cookie = SMSClientLib.Login.Connect(newSMS.userID, newSMS.password, out status);
            //if (status.ToLower() == "connected")
            //{
            //    string[] smsTextList = CreateSMSText(newSMS.smsBody, 140);
            //    string[] siteParameters = SMSClientLib.Login.GetSiteParameters(cookie);
            //    string messgeSentResult = "";

            //    for (int i = 0; i < smsTextList.Length; i++)
            //    {
            //        messgeSentResult = SMSClientLib.SendSMS.Send_Processing(newSMS.toList, smsTextList[i], cookie, siteParameters);
            //    }

            //    retVal = "Sent Successfully..";
            //}

            WebRequest request;
            WebResponse response;
            StreamReader reader;
            string url = "";
            string urlText = "";
            string[] mobileNumber = newSMS.toList.Split(';');

            for (int i = 0; i < mobileNumber.Length; i++)
            {
                // sample url: "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=91<MobileNumber>&sender=COGNIZ&text=<SMS text>"
                url = "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=" + mobileNumber[i] + "&sender=COGNIZ&text=" + newSMS.smsBody;
                request = HttpWebRequest.Create(url);
                response = request.GetResponse();
                reader = new StreamReader(response.GetResponseStream());
                urlText = reader.ReadToEnd();
                retVal = (urlText == "Message has been accepted.") ? "Sent Successfully.." : "Sent failed..";
            }

            return retVal;
        }

        public string[] CreateSMSText(string text, int maxLen)
        {

            string tempText = text;
            int smsCount = (int)Math.Ceiling((double)text.Length / (double)maxLen);
            int tempLen = 0;
            string[] listText = new string[smsCount];

            for (int i = 0; i < smsCount; i++)
            {
                if (text.Length <= maxLen)
                    listText[i] = text;
                else
                {
                    if (maxLen > tempText.Length)
                        listText[i] = tempText;
                    else
                    {
                        tempLen = tempText.Substring(0, maxLen).LastIndexOf(" ");
                        listText[i] = tempText.Substring(0, tempLen);
                        tempText = tempText.Substring((tempLen + 1), (tempText.Length - (tempLen + 1)));
                    }
                }
            }
            return listText;
        }

        public List<SMSAccount> GetAllAccounts()
        {
            List<SMSAccount> acc = new List<SMSAccount>();
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var associate = (from a in asscon.sp_SMSAccounts("SELECT",null,null,null,null,null)
                                 
                                 select new SMSAccount()
                                 {
                                     id=a.Id,
                                     password=a.Password,
                                     phoneNumber=a.Phone,
                                     sentSMS=a.SentSMS,
                                     email=a.Email
                                 }).ToList<SMSAccount>();
                acc = associate;
                return acc;
            }
    
        }

        public void UpdateSMSNumber(int id)
        {
            List<SMSAccount> acc = new List<SMSAccount>();
            using (AssociateConnDataContext asscon = new AssociateConnDataContext())
            {
                var val = asscon.sp_SMSAccounts("UPDATE", id, null, null, null, null);
            }
        }
        #endregion

        #region Email

        public bool SendEmail(string sendSubject, string mailbody, string ApproverEmail, string RequesterEmail,bool IsHtml)
        {
            string csvFileName = string.Empty;
            string smtpServer = string.Empty;
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            message.To.Add(new System.Net.Mail.MailAddress(RequesterEmail));
            message.From = new System.Net.Mail.MailAddress(ApproverEmail);
            message.Sender = new System.Net.Mail.MailAddress(ApproverEmail);
            message.Body = mailbody;
            message.Subject = sendSubject;

            try
            {
                if (string.IsNullOrEmpty(smtpServer))
                    smtpServer = "10.236.145.165";

                SmtpClient smtp = new SmtpClient(smtpServer);
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                message.IsBodyHtml = IsHtml;
                smtp.Send(message);
                return true;
            }
            catch (Exception ex)
            {

                return false;
            }
        }

        #endregion

        #region Authenticate
            public int AuthenticateUser(string userid, string pwd)
            {
                int retVal = 0;
                try
                {
                    using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                    {
                        retVal = asscon.validateUser(userid,pwd);
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                return retVal;

            }

            public Associate.Associate LoginUser(string userid, string pwd)
            {
                try
                {
                    using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                    {
                        var Associate = (from a in asscon.getAthenticateUser(userid, pwd)
                                           select new Associate.Associate()
                                           {
                                               AssociateID=a.AssociateID,
                                               //Designation = a.Designation,
                                               //DesignationID = a.DesignationID ,
                                               //DirectReportID = a.DirectReportID,
                                               //DirectReporter = a.DirectReporter,
                                               //DOB = a.DOB,
                                               //DOJ = a.DOJ,
                                               email=a.email,
                                               Gender=a.Gender,
                                               //Location = a.Location,
                                               //LocationID = a.LocationID,
                                               Mobile = a.Mobile,
                                               Name=a.Name,
                                               //ProjectID=a.ProjectID.Value,
                                               //ProjectName=a.ProjectName,
                                               IsApproved=a.IsApproved
                                           }).SingleOrDefault();
                        
                        Associate.groupList = (from b in asscon.getAssociateRoleGroup(userid)
                                               select new Associate.Group()
                                               {
                                                   GroupDesc = b.GroupDesc,
                                                   GroupName=b.GroupName,
                                                   GroupID = b.GroupID.Value
                                               }).ToList<Associate.Group>();

                        Associate.Role = (from b in asscon.getAssociateRoleGroup(userid)
                                          select new Associate.Role()
                                          {
                                              RoleDesc = b.RoleDesc,
                                              RoleID = b.RoleID.Value
                                          }).FirstOrDefault();

                        if (Associate.groupList.Count > 0)
                        {
                            return Associate;
                        }
                        else
                        {
                            throw new Exception("No group available for the user");
                            //return null;
                        }
                    }
                }
                catch (Exception e)
                {
                    throw e;                    
                }
            }
            
            public Associate.Associate ForgotPassword(string userid, int associateid, string name)
            {
                try
                {
                    using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                    {
                        var Associate = (from a in asscon.GetUserPWD(userid, associateid, name)
                                         select new Associate.Associate()
                                         {
                                             email = a.email,
                                             Mobile = a.Mobile,
                                             Password = a.Password,

                                         }).SingleOrDefault();

                        return Associate;
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        #endregion

            #region Change Password

            public string ChangePassword(Cog.MLIAD.BusinessLogic.Associate.ChangePassword obj)
            {
                string returnValue = string.Empty;
                try
                {
                    using (AssociateConnDataContext asscon = new AssociateConnDataContext())
                    {
                        int? output = 0;
                        var retVal = asscon.sp_ChangePassword(obj.AssociateID, obj.CurrentPassword, obj.NewPassword, ref output);
                        if (output != null)
                        {
                            returnValue = Convert.ToString(output);
                        }
                        else
                        {
                            returnValue = "3";
                        }

                    }

                }
                catch (Exception ex)
                {
                    returnValue = "3";
                    throw ex;
                }
                return returnValue;
            }

            #endregion

        #endregion 

    }
}
