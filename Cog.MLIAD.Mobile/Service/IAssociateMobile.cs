using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Syndication;
using System.Text;
using Cog.MLIAD.BusinessLogic;
using Cog.MLIAD.BusinessLogic.Associate;

namespace Cog.MLIAD.Mobile.Services.AssociateMobile 
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IAssociate" in both code and config file together.
    [ServiceContract]
    public interface IAssociateMobile
    {
        #region discussion
        [OperationContract]
        [WebGet(UriTemplate = "/discussions/{catid}/{groupid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Discussion> GetTopics(string catid, string groupid);

        [OperationContract]
        [WebGet(UriTemplate = "/discussion/{topicid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Discussion GetTopic(string topicid);
       

        [OperationContract]
        [WebGet(UriTemplate = "/discussions/details/{topicid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<DiscussionDetails> GetTopicDetails(string topicid);

        [OperationContract]
        [WebGet(UriTemplate = "/discussions/categories",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Category> GetCategories();

        [OperationContract]
        [WebGet(UriTemplate = "/discussions/groups/uid/{uid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Group> GetGroupsByUser(string uid);

        [OperationContract]
        [WebGet(UriTemplate = "/discussions/groups",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<Group> GetGroups();

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/discussions/newPost",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int PostTopic(Cog.MLIAD.BusinessLogic.Associate.Discussion  newtopic);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/discussions/ReplyToPost",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int ReplyToPostTopic(Cog.MLIAD.BusinessLogic.Associate.Discussion replytopic);

        #endregion

        #region associate
        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/associate/add",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string AddAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{userid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
          BusinessLogic.Associate.Associate GetAssociate(string userid);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/assocaitepergroup/{groupid}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        List<BusinessLogic.Associate.Associate> GetAssociatesPerGroup(string groupid);

        [OperationContract]
        [WebGet(UriTemplate = "/associateDetails/assoID/{assoID}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Cog.MLIAD.BusinessLogic.Associate.Associate GetDetailsByID(string assoID);

        [OperationContract]
        [WebGet(UriTemplate = "/UpdateGroup/{gid}/{rid}/{addlist}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int AddToGroups(string gid, string rid, string addlist);

        #endregion

        #region SendSMS

        [OperationContract]
        [WebGet(UriTemplate = "/SMS?loginid={loginid}&passwrd={passwrd}&tolist={tolist}&msg={msg}",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string SendSMS(string loginid, string passwrd, string tolist, string msg);

        [OperationContract]
        [WebInvoke(Method = "PUT",
          UriTemplate = "/SMS/Broadcast",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        string BroadCastSMS(Cog.MLIAD.BusinessLogic.Associate.SMS  newSMS);

        #endregion SendSMS

        #region "Authenticate"

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{userid}/{pwd}/authenticate",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        int authenticate(string userid, string pwd);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{userid}/{pwd}/login",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Associate LoginUser(string userid, string pwd);

        [OperationContract]
        [WebGet(UriTemplate = "/associate/{userid}/{associateid}/{name}/forgot",
          RequestFormat = WebMessageFormat.Json,
          ResponseFormat = WebMessageFormat.Json,
          BodyStyle = WebMessageBodyStyle.Bare)]
        Associate ForgotPassword(string userid, string associateid, string name);
        #endregion

        #region Change Password

        [WebInvoke(Method = "POST",
            UriTemplate = "/associate/changepassword",
         RequestFormat = WebMessageFormat.Json,
         ResponseFormat = WebMessageFormat.Json,
         BodyStyle = WebMessageBodyStyle.Bare)]
        string ChangePassword(Cog.MLIAD.BusinessLogic.Associate.ChangePassword obj);

        #endregion

    }
}
