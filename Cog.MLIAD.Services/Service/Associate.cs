using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel.Activation;
using System.IO;
using System.Net;
using System.ServiceModel.Web;
using Cog.MLIAD.BusinessLogic;
using Cog.MLIAD.BusinessLogic.Data;
using Cog.MLIAD.BusinessLogic.Associate;

namespace Cog.MLIAD.Services.Associate
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class Associate : MLIADService, IAssociate
    {
        Cog.MLIAD.BusinessLogic.Data.AssociateRepository repository = new Cog.MLIAD.BusinessLogic.Data.AssociateRepository();

        #region Associate
        public string AddAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddAssociate(associate);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string AddPhone(Cog.MLIAD.BusinessLogic.Associate.Phone phone, string AssociateID)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddPhone(phone, AssociateID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string AddAddress(Cog.MLIAD.BusinessLogic.Associate.Address address, string AssociateID)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddAddress(address, AssociateID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string EditAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = "failure";
                if (associate.oper == "edit")
                    retval = repository.EditAssociate(associate);
                else if (associate.oper == "delete")
                    retval = repository.DeleteAssociate(associate.id);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Pager<Cog.MLIAD.BusinessLogic.Associate.Associate> SearchAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate, string page, string row, string totalcount)
        {
            try
            {
                int? count = 0;
                int pageIndex = Convert.ToInt32(page);
                int pageSize = Convert.ToInt32(row);
                Pager<Cog.MLIAD.BusinessLogic.Associate.Associate> pager = new Pager<Cog.MLIAD.BusinessLogic.Associate.Associate>();
                MLIADService.SetNoCache();
                List<Cog.MLIAD.BusinessLogic.Associate.Associate> associates = repository.SearchAssociate(associate, (pageIndex - 1), pageSize, ref count);

                pager.Items = associates;
                pager.Page = pageIndex;
                pager.ItemCount = (count == null) ? 0 : Convert.ToInt32(count);
                pager.PageTotal = ((pager.ItemCount + pageSize - 1) / pageSize);
                pager.PageSize = pageSize;
                return pager;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Designation> GetDesignation()
        {
            try
            {
                List<BusinessLogic.Associate.Designation> designations = new List<BusinessLogic.Associate.Designation>();
                designations = repository.GetDesignation();
                return designations;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Location> GetLocation()
        {
            try
            {
                List<BusinessLogic.Associate.Location> locations = new List<BusinessLogic.Associate.Location>();
                locations = repository.GetLocation();
                return locations;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.PhoneType> GetPhoneType()
        {
            try
            {
                List<BusinessLogic.Associate.PhoneType> phoneTypes = new List<BusinessLogic.Associate.PhoneType>();
                phoneTypes = repository.GetPhoneType();
                return phoneTypes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.AddressType> GetAddressType()
        {
            try
            {
                List<BusinessLogic.Associate.AddressType> addressTypes = new List<BusinessLogic.Associate.AddressType>();
                addressTypes = repository.GetAddressType();
                return addressTypes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Practice> GetPractice()
        {
            try
            {
                List<BusinessLogic.Associate.Practice> practices = new List<BusinessLogic.Associate.Practice>();
                practices = repository.GetPractice();
                return practices;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Account> GetAccount(string PracticeID)
        {
            try
            {
                int PID = Convert.ToInt32(PracticeID);
                List<BusinessLogic.Associate.Account> accounts = new List<BusinessLogic.Associate.Account>();
                accounts = repository.GetAccount(PID);
                return accounts;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Project> GetProject()
        {
            try
            {
                List<BusinessLogic.Associate.Project> projects = new List<BusinessLogic.Associate.Project>();
                projects = repository.GetProject();
                return projects;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Associate> GetPendingApproval(string count)
        {
            try
            {
                List<BusinessLogic.Associate.Associate> ids = new List<BusinessLogic.Associate.Associate>();
                ids = repository.GetApprovalRequest();
                return ids;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public BusinessLogic.Associate.Associate GetDetailsByID(string AssociateID)
        {
            try
            {
                BusinessLogic.Associate.Associate associates = new BusinessLogic.Associate.Associate();
                associates = repository.GetAssociateByID(AssociateID);
                List<Group> groups = repository.GetGroupsByID(Convert.ToInt32(AssociateID));
                associates.GroupName = groups[0].GroupName;
                return associates;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Role> GetRole()
        {
            try
            {
                List<BusinessLogic.Associate.Role> roles = new List<BusinessLogic.Associate.Role>();
                roles = repository.GetRole();
                return roles;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Group> GetGroup()
        {
            try
            {
                List<BusinessLogic.Associate.Group> groups = new List<BusinessLogic.Associate.Group>();
                groups = repository.GetGroup();
                return groups;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int ApproveRequest(string AssociateID, string RoleID, string GroupID, string Approver)
        {
            string[] GroupIDs = GroupID.Split(',');

            return repository.ApproveRequest(AssociateID, RoleID, GroupIDs, Approver);
        }

        public int RejectRequest(string AssociateID, string RoleID, string GroupID, string Approver)
        {
            return repository.RejectRequest(AssociateID, RoleID, GroupID, Approver);
        }

        public int CreateGroup(string gName, string gDesc)
        {
            return repository.CreateGroup(gName, gDesc);
        }

        public int UpdateGroup(string gid, string rid, string addlist, string removelist)
        {
            string[] AddList = addlist.Split(',');
            string[] RemoveList = removelist.Split(',');

            return repository.UpdateGroup(gid, rid, AddList, RemoveList);
        }

        public List<BusinessLogic.Associate.Associate> GetAssociatesPerGroup(string groupid)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.GetAssociatesPerGroup(Convert.ToInt32(groupid));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.Associate> GetAssociatesPerGroupAndRole(string groupid, string roleid)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.GetAssociatesPerGroupAndRole(Convert.ToInt32(groupid), Convert.ToInt32(roleid));
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
                MLIADService.SetNoCache();
                return repository.GetAssociatesByUserID(UserID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Pager<Cog.MLIAD.BusinessLogic.Associate.Category> SearchCategory(Cog.MLIAD.BusinessLogic.Associate.Category search, string page, string row, string totalcount)
        {
            try
            {
                int? count = 0;
                int pageIndex = Convert.ToInt32(page);
                int pageSize = Convert.ToInt32(row);
                Pager<Cog.MLIAD.BusinessLogic.Associate.Category> pager = new Pager<Cog.MLIAD.BusinessLogic.Associate.Category>();
                MLIADService.SetNoCache();
                List<Cog.MLIAD.BusinessLogic.Associate.Category> categories = repository.SearchCategory(search, (pageIndex - 1), pageSize, ref count);

                pager.Items = categories;
                pager.Page = pageIndex;
                pager.ItemCount = (count == null) ? 0 : Convert.ToInt32(count);
                pager.PageTotal = ((pager.ItemCount + pageSize - 1) / pageSize);
                pager.PageSize = pageSize;
                return pager;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string AddCategory(Cog.MLIAD.BusinessLogic.Associate.Category category)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddCategory(category);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string EditCategory(Cog.MLIAD.BusinessLogic.Associate.Category category)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = "failure";
                retval = repository.EditCategory(category);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string DeleteCategory(Cog.MLIAD.BusinessLogic.Associate.Category category)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = "failure";
                retval = repository.DeleteCategory(category.id);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Software
        public string AddSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddSoftware(software);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string EditSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = "failure";
                if (software.oper == "edit")
                    retval = repository.EditSoftware(software);
                else if (software.oper == "delete")
                    retval = repository.DeleteSoftware(software.id);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Pager<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> SearchSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software, string page, string row, string totalcount)
        {
            try
            {
                int? count = 0;
                int pageIndex = Convert.ToInt32(page);
                int pageSize = Convert.ToInt32(row);
                Pager<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> pager = new Pager<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest>();
                MLIADService.SetNoCache();
                List<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> softwares = repository.SearchSoftware(software, (pageIndex - 1), pageSize, ref count);

                pager.Items = softwares;
                pager.Page = pageIndex;
                pager.ItemCount = (count == null) ? 0 : Convert.ToInt32(count);
                pager.PageTotal = ((pager.ItemCount + pageSize - 1) / pageSize);
                pager.PageSize = pageSize;
                return pager;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BusinessLogic.Associate.SoftwareCategory> GetSoftwareCategory()
        {
            List<BusinessLogic.Associate.SoftwareCategory> categories = new List<BusinessLogic.Associate.SoftwareCategory>();
            categories = repository.GetSoftwareCategory();
            return categories;
        }

        public List<BusinessLogic.Associate.SoftwareResource> GetSoftwareResource(string softCategoryID)
        {
            int SoftwareCategoryID = Convert.ToInt32(softCategoryID);
            List<BusinessLogic.Associate.SoftwareResource> resources = new List<BusinessLogic.Associate.SoftwareResource>();
            resources = repository.GetSoftwareResource(SoftwareCategoryID);
            return resources;
        }

        public List<BusinessLogic.Associate.SoftwareVersion> GetSoftwareVersion(string softResourceID)
        {
            int SoftwareResourceID = Convert.ToInt32(softResourceID);
            List<BusinessLogic.Associate.SoftwareVersion> versions = new List<BusinessLogic.Associate.SoftwareVersion>();
            versions = repository.GetSoftwareVersion(SoftwareResourceID);
            return versions;
        }
        #endregion

        #region Firewall
        public string AddFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall)
        {
            try
            {
                MLIADService.SetNoCache();
                return repository.AddFirewall(firewall);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string EditFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = "failure";
                if (firewall.oper == "edit")
                    retval = repository.EditFirewall(firewall);
                else if (firewall.oper == "delete")
                    retval = repository.DeleteFirewall(firewall.id);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Pager<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> SearchFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall, string page, string row, string totalcount)
        {
            try
            {
                int? count = 0;
                int pageIndex = Convert.ToInt32(page);
                int pageSize = Convert.ToInt32(row);
                Pager<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> pager = new Pager<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest>();
                MLIADService.SetNoCache();
                List<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> firewalls = repository.SearchFirewall(firewall, (pageIndex - 1), pageSize, ref count);

                pager.Items = firewalls;
                pager.Page = pageIndex;
                pager.ItemCount = (count == null) ? 0 : Convert.ToInt32(count);
                pager.PageTotal = ((pager.ItemCount + pageSize - 1) / pageSize);
                pager.PageSize = pageSize;
                return pager;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Forum

        public int SaveMessage(string gid, string id, string message)
        {
            int retVal = 0;
            try
            {
                MLIADService.SetNoCache();
                int AssociateID = Convert.ToInt32(id);
                int GroupID = Convert.ToInt32(gid);
                retVal = repository.SaveMessage(AssociateID, GroupID, message);
            }
            catch (Exception e)
            {
                throw e;
            }
            return retVal;
        }

        #endregion

        #region SendSMS

        public string BroadCastSMS(Cog.MLIAD.BusinessLogic.Associate.SMS newSMS)
        {
            try
            {
                MLIADService.SetNoCache();
                string retval = repository.SendSMS(newSMS);
                return retval;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion SendSMS

        //#region "Authenticate"

        //    public int authenticate(string userid, string pwd)
        //    {
        //        int result = 0;
        //        try
        //        {
        //            result = repository.AuthenticateUser(userid, pwd);
        //        }
        //        catch (Exception )
        //        {

        //        }  

        //        return result;
        //    }
        //#endregion 
    }
}
