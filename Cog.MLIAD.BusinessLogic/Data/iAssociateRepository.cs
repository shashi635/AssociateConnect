using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Text;
using Cog.MLIAD.Data;
using Cog.MLIAD.BusinessLogic;
using Cog.MLIAD.BusinessLogic.Associate;

namespace Cog.MLIAD.BusinessLogic.Data
{
    public interface iAssociateRepository
    {
        #region AssociateConnect
            #region Associate
              Associate.Associate GetAssociate(string userid);
              string AddAssociate(Associate.Associate associate);
              string AddPhone(Associate.Phone phone, string AssociateID);
              string AddAddress(Associate.Address address, string AssociateID);
              string EditAssociate(Associate.Associate associate);
              string DeleteAssociate(string id);
              List<Cog.MLIAD.BusinessLogic.Associate.Associate> SearchAssociate(Associate.Associate associate, int pageIndex, int pageSize, ref int? count);
              List<Associate.Designation> GetDesignation();
              List<Associate.Location> GetLocation();
              List<Associate.AddressType> GetAddressType();
              List<Associate.PhoneType> GetPhoneType();
              List<Associate.Practice> GetPractice();
              List<Associate.Account> GetAccount(int PracticeID);
              List<Associate.Project> GetProject();
              List<Associate.Associate> GetApprovalRequest();
              Associate.Associate GetAssociateByID(string AssociateID);
              List<Associate.Role> GetRole();
              List<Associate.Group> GetGroup();
              int ApproveRequest(string AssociateID, string Role, string[] GroupIDs, string Approver);
              int RejectRequest(string AssociateID, string Group, string Role, string Approver);
              int UpdateGroup(string GroupID, string RoleID, string[] AddList, string[] RemoveList);
              int CreateGroup(string gName, string gDesc);
              List<BusinessLogic.Associate.Associate> GetAssociatesPerGroupAndRole(int groupid, int roleid);
              List<Cog.MLIAD.BusinessLogic.Associate.Category> SearchCategory(Associate.Category search, int pageIndex, int pageSize, ref int? count);
              string AddCategory(Associate.Category category);
              string EditCategory(Associate.Category category);
              string DeleteCategory(string id);
              
            #endregion
            #region Software
              string AddSoftware(Associate.SoftwareRequest software);
              string EditSoftware(Associate.SoftwareRequest software);
              string DeleteSoftware(string id);
              List<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> SearchSoftware(Associate.SoftwareRequest software, int pageIndex, int pageSize, ref int? count);
              List<Associate.SoftwareCategory> GetSoftwareCategory();
              List<Associate.SoftwareResource> GetSoftwareResource(int softCategoryID);
              List<Associate.SoftwareVersion> GetSoftwareVersion(int softResourceID);
            #endregion

            #region Firewall
              string AddFirewall(Associate.FirewallRequest firewall);
              string EditFirewall(Associate.FirewallRequest firewall);
              string DeleteFirewall(string id);

              List<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> SearchFirewall(Associate.FirewallRequest firewall, int pageIndex, int pageSize, ref int? count);
            #endregion

            #region Discussion
              List<Associate.Discussion> GetTopics(int CategoryID, int groupID);
              Associate.Discussion GetTopic(int topicID);
              List<Associate.DiscussionDetails> GetTopicDetails(int topicID);
              List<Associate.Category> GetCategories();
              List<Associate.Group> GetGroupsByUser(int uid);
              int SaveMessage(int AssociateID, int GroupID, string Message);
            #endregion
        
            #region "Authenticate"
              int AuthenticateUser(string userid, string pwd);
              Associate.Associate LoginUser(string userid, string pwd);
              Associate.Associate ForgotPassword(string userid, int associateid, string name);
            #endregion

        #endregion
    }
}
