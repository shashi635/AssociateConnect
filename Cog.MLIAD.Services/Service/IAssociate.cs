using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using Cog.MLIAD.BusinessLogic.Associate;

namespace Cog.MLIAD.Services.Associate
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IAssociate" in both code and config file together.
    [ServiceContract]
    public interface IAssociate
    {

        #region Associate
        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/phone/{AssociateID}/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddPhone(Cog.MLIAD.BusinessLogic.Associate.Phone phone, string AssociateID);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/address/{AssociateID}/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddAddress(Cog.MLIAD.BusinessLogic.Associate.Address address, string AssociateID);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/edit",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string EditAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate);


        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/search?page={page}&row={row}&count={count}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Pager<Cog.MLIAD.BusinessLogic.Associate.Associate> SearchAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate search, string page, string row, string count);

        [OperationContract]
        [WebGet(UriTemplate = "/designation/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Designation> GetDesignation();

        [OperationContract]
        [WebGet(UriTemplate = "/Location/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Location> GetLocation();

        [OperationContract]
        [WebGet(UriTemplate = "/PhoneType/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.PhoneType> GetPhoneType();

        [OperationContract]
        [WebGet(UriTemplate = "/AddressType/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.AddressType> GetAddressType();

        [OperationContract]
        [WebGet(UriTemplate = "/Practice/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Practice> GetPractice();

        [OperationContract]
        [WebGet(UriTemplate = "/Account/{PID}/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Account> GetAccount(string PID);

        [OperationContract]
        [WebGet(UriTemplate = "/Project/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Project> GetProject();

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{count}/getPendingRequest",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Associate> GetPendingApproval(string count);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{AssociateID}/getDetails",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Cog.MLIAD.BusinessLogic.Associate.Associate GetDetailsByID(string AssociateID);

        [OperationContract]
        [WebGet(UriTemplate = "/getRoles",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Role> GetRole();

        [OperationContract]
        [WebGet(UriTemplate = "/getGroups",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.Group> GetGroup();

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{AssociateID}/{RoleID}/{GroupID}/{Approver}/approveRequest",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int ApproveRequest(string AssociateID, string RoleID, string GroupID, string Approver);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{AssociateID}/{RoleID}/{GroupID}/{Approver}/rejectRequest",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int RejectRequest(string AssociateID, string RoleID, string GroupID, string Approver);

        [OperationContract]
        [WebGet(UriTemplate = "/CreateGroup/{gName}/{gDesc}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int CreateGroup(string gName, string gDesc);

        [OperationContract]
        [WebGet(UriTemplate = "/UpdateGroup/{gid}/{rid}/{addlist}/{removelist}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int UpdateGroup(string gid, string rid, string addlist, string removelist);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/assocaitepergroup/{groupid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<BusinessLogic.Associate.Associate> GetAssociatesPerGroup(string groupid);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/assocaitepergroupandrole/{groupid}/{roleid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<BusinessLogic.Associate.Associate> GetAssociatesPerGroupAndRole(string groupid, string roleid);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{userid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        BusinessLogic.Associate.Associate GetAssociatesByUserID(string UserID);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/category/search?page={page}&row={row}&count={count}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Pager<Cog.MLIAD.BusinessLogic.Associate.Category> SearchCategory(Cog.MLIAD.BusinessLogic.Associate.Category search, string page, string row, string count);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/category/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddCategory(Cog.MLIAD.BusinessLogic.Associate.Category category);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/category/edit",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string EditCategory(Cog.MLIAD.BusinessLogic.Associate.Category category);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/category/delete",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string DeleteCategory(Cog.MLIAD.BusinessLogic.Associate.Category category);

        #endregion

        #region Software
        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Software/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Software/edit",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string EditSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Software/search?page={page}&row={row}&count={count}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Pager<Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest> SearchSoftware(Cog.MLIAD.BusinessLogic.Associate.SoftwareRequest software, string page, string row, string count);

        [OperationContract]
        [WebGet(UriTemplate = "/softcategory/get",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.SoftwareCategory> GetSoftwareCategory();

        [OperationContract]
        [WebGet(UriTemplate = "/softResource/{softCategoryID}/getDetails",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.SoftwareResource> GetSoftwareResource(string SoftCategoryID);

        [OperationContract]
        [WebGet(UriTemplate = "/softVersion/{softResourceID}/getDetails",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Cog.MLIAD.BusinessLogic.Associate.SoftwareVersion> GetSoftwareVersion(string SoftResourceID);


        #endregion

        #region Firewall
        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Firewall/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Firewall/edit",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string EditFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "Firewall/search?page={page}&row={row}&count={count}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Pager<Cog.MLIAD.BusinessLogic.Associate.FirewallRequest> SearchFirewall(Cog.MLIAD.BusinessLogic.Associate.FirewallRequest firewall, string page, string row, string count);

        #endregion

        #region Forum

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/Forum/broadcastmsg/{gid}/{id}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int SaveMessage(string gid, string id, string message);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/SMS/Broadcast",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string BroadCastSMS(Cog.MLIAD.BusinessLogic.Associate.SMS newSMS);

        #endregion
        //#region "Authenticate"

        //[OperationContract]
        //[WebGet(UriTemplate = "/associate/{userid}/{pwd}/authenticate",
        //  RequestFormat = WebMessageFormat.Json,
        //  ResponseFormat = WebMessageFormat.Json,
        //  BodyStyle = WebMessageBodyStyle.Bare)]
        //int authenticate(string userid, string pwd);
        //#endregion
    }
}
