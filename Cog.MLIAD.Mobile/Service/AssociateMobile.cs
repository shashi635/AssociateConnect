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
using System.Web;
using System.Configuration;

namespace Cog.MLIAD.Mobile.Services.AssociateMobile
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class AssociateMobile : MLIADMobileService, IAssociateMobile
    {
        AssociateRepository repository = new AssociateRepository();
        #region Associate
        
        public string AddAssociate(Cog.MLIAD.BusinessLogic.Associate.Associate associate)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                var result = repository.AddMobileAssociate(associate);
                //if(result == "success")
                //{
                //    string smstext = "Thanks " + associate.FirstName + " " + associate.LastName + ". Your registration is successful. Your username is: '" + associate .AssociateID+ "'. You password is: 'password'. Please login to https://massociatecon.cognizant.com/mobile/login.htm";
                //    try
                //    {
                //        SendSMS(smstext, "91" + associate.Mobile);
                //    }
                //    catch (Exception ex)
                //    {
                //    }
                //    finally
                //    {
                //        //try
                //        //{
                //        //    repository.SendEmail("Registration Successful!", smstext, associate.email, associate.email, true);
                //        //}
                //        //catch (Exception ex) { }
                //        //finally
                //        //{
                //        //    //return result;
                //        //}
                //    }
                //    return result;
                //}
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public BusinessLogic.Associate.Associate GetAssociate(string userid)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                return repository.GetAssociate(userid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<BusinessLogic.Associate.Associate> GetAssociatesPerGroup(string groupid)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                return repository.GetAssociatesPerGroup(Convert.ToInt32(groupid));
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
                return associates;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int AddToGroups(string gid, string rid, string addlist)
        {
            var retval = 0;
            string[] AddList = addlist.Split(',');
            string[] RemoveList = "".Split(',');
            string[] glist = gid.Split(',');
            foreach (var item in glist)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    retval = repository.UpdateGroup(item, rid, AddList, RemoveList);
                }
            }
            return retval;
        }

        #endregion

        #region Discussion

        public List<Discussion> GetTopics(string catid, string groupid)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                int intCatID = -1;
                int intGroupID = -1;
      
                if (!string.IsNullOrEmpty(catid))
                    int.TryParse(catid, out intCatID);
                if (!string.IsNullOrEmpty(groupid))
                    int.TryParse(groupid, out intGroupID);

                return repository.GetTopics(intCatID, intGroupID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public Discussion GetTopic(string topicID)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                int intTopicID = -1;

                if (!string.IsNullOrEmpty(topicID))
                    int.TryParse(topicID, out intTopicID);

                return repository.GetTopic(intTopicID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<DiscussionDetails> GetTopicDetails(string topicid)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                int intTopicID = -1;
                if (!string.IsNullOrEmpty(topicid))
                    int.TryParse(topicid, out intTopicID);

                return repository.GetTopicDetails(intTopicID);
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Category> GetCategories()
        {
            try
            {
                MLIADMobileService.SetNoCache();
                return repository.GetCategories();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Group> GetGroupsByUser(string uid)
        {
            try
            {
                
                MLIADMobileService.SetNoCache();
                return repository.GetGroupsByUser(Convert.ToInt32(uid));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Group> GetGroups()
        {
            try
            {

                MLIADMobileService.SetNoCache();
                return repository.GetGroup();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public int PostTopic(Cog.MLIAD.BusinessLogic.Associate.Discussion newtopic)
        {
            int retVal = 0;
            try
            {
                MLIADMobileService.SetNoCache();
                retVal = repository.PostTopic(newtopic);
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
                MLIADMobileService.SetNoCache();
                retVal = repository.ReplyToPostTopic(replytopic);
            }
            catch (Exception e)
            {
                throw e;
            }
            return retVal;
        }

        #endregion

        #region SendSMS

        public string SendSMS(string loginid, string passwrd, string tolist, string msg)
        {
            string retVal = "Sent failed..";
            #region Previous Code
            //string status;
            //if (!(string.IsNullOrEmpty(loginid)) && !(string.IsNullOrEmpty(passwrd)))
            //{
            //    CookieContainer cookie = SMSClientLib.Login.Connect(loginid, passwrd, out status);
            //    if (status.ToLower() == "connected")
            //    {

            //        string[] siteParameters = SMSClientLib.Login.GetSiteParameters(cookie);
            //        string messgeSentResult = SMSClientLib.SendSMS.Send_Processing(tolist, msg, cookie, siteParameters);
            //        retVal = "Sent Successfully..";
            //    }
            //}
            //WebRequest request;
            //WebResponse response;
            //StreamReader reader;
            //string url = "";
            //string urlText = "";
            //string[] mobileNumber = tolist.Split(';');

            //for (int i = 0; i < mobileNumber.Length; i++)
            //{
            //    // sample url: "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=91<MobileNumber>&sender=COGNIZ&text=<SMS text>"
            //    url = "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=" + mobileNumber[i] + "&sender=COGNIZ&text=" + msg;
            //    request = HttpWebRequest.Create(url);
            //    response = request.GetResponse();
            //    reader = new StreamReader(response.GetResponseStream());
            //    urlText = reader.ReadToEnd();
            //    retVal = (urlText == "Message has been accepted.") ? "Sent Successfully.." : "Sent failed..";
            //}
            #endregion
            string[] mobileNumber = tolist.Split(';');
            bool valSMS = false;
            for (int i = 0; i < mobileNumber.Length; i++)
            {
                valSMS = SendSMS(msg, Convert.ToString(mobileNumber[i]));
                retVal = (valSMS == true) ? "Sent Successfully.." : "Sent failed..";
            }

            return retVal;
        }

        public string BroadCastSMS(Cog.MLIAD.BusinessLogic.Associate.SMS newSMS)
        {
            string retVal = "Sent failed..";
            #region previous Code
            //string status;
            //newSMS.userID = "8961540630";
            //newSMS.password = "cognizant";

            //CookieContainer cookie = SMSClientLib.Login.Connect(newSMS.userID, newSMS.password, out status);
            //    if (status.ToLower() == "connected")
            //    {
            //        string[] smsTextList = CreateSMSText(newSMS.smsBody, 140);
            //        string[] siteParameters = SMSClientLib.Login.GetSiteParameters(cookie);
            //        string messgeSentResult = "";                                        

            //        for (int i = 0; i < smsTextList.Length; i++)
            //        {
            //            messgeSentResult = SMSClientLib.SendSMS.Send_Processing(newSMS.toList, smsTextList[i], cookie, siteParameters);
            //        }                    

            //        retVal = "Sent Successfully..";
            //    }
            //WebRequest request;
            //WebResponse response;
            //StreamReader reader;
            //string url = "";
            //string urlText = "";
            //string[] mobileNumber = newSMS.toList.Split(';');

            //for (int i = 0; i < mobileNumber.Length; i++)
            //{
            //    // sample url: "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=91<MobileNumber>&sender=COGNIZ&text=<SMS text>"
            //    url = "http://203.92.40.186:8181/Sun3/Send_SMS2x?user=cogniz&password=cogniz123&PhoneNumber=" + mobileNumber[i] + "&sender=COGNIZ&text=" + newSMS.smsBody;
            //    request = HttpWebRequest.Create(url);
            //    response = request.GetResponse();
            //    reader = new StreamReader(response.GetResponseStream());
            //    urlText = reader.ReadToEnd();
            //    retVal = (urlText == "Message has been accepted.") ? "Sent Successfully.." : "Sent failed..";
            //}
            #endregion
            string[] mobileNumber = newSMS.toList.Split(';');
            bool valSMS = false;
            for (int i = 0; i < mobileNumber.Length; i++)
            {
                valSMS = SendSMS(newSMS.smsBody, Convert.ToString(mobileNumber[i]));
                retVal = (valSMS == true) ? "Sent Successfully.." : "Sent failed..";
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

        public bool SendSMS(string smsText, string destinationNumber)
        {
            bool retVal = false;
            string provider = "mvaayoo.com";
            try
            {
                provider = ConfigurationManager.AppSettings["SMSProvider"].ToString();
            }
            catch (Exception)
            {
                provider = "mvaayoo.com";
            }
            #region mvaayoo
            try
            {

                if (provider == "mvaayoo.com")
                {
                    string strUrl = "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=singh635@gmail.com:asdfgert&senderID=TEST SMS&receipientno=" + destinationNumber + "&msgtxt=" + smsText + "&state=4";
                    WebRequest request = HttpWebRequest.Create(strUrl);
                    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                    Stream s = (Stream)response.GetResponseStream();
                    StreamReader readStream = new StreamReader(s);
                    string dataString = readStream.ReadToEnd();
                    response.Close();
                    s.Close();
                    readStream.Close();
                    retVal = true;
                }
                else if (provider == "ubaid.tk")
                {
                    HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("http://ubaid.tk/sms/sms.aspx?uid=" + "7890851146" + "&pwd=" + "asdfgert" + "&msg=" + smsText + "&phone=" + destinationNumber + "&provider=fullonsms");

                    HttpWebResponse myResp = (HttpWebResponse)myReq.GetResponse();
                    System.IO.StreamReader respStreamReader = new System.IO.StreamReader(myResp.GetResponseStream());
                    string responseString = respStreamReader.ReadToEnd();
                    respStreamReader.Close();
                    myResp.Close();
                    retVal = true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            #endregion

            return retVal;
        }
        
        #endregion SendSMS

        #region "Authenticate"

        public int authenticate(string userid, string pwd)
        {
            int result = 0;
            try
            {
                result = repository.AuthenticateUser(userid, pwd);
            }
            catch (Exception)
            {

            }

            return result;
        }

        public Associate LoginUser(string userid, string pwd)
        {
            Associate result = null;
            try
            {
                result= repository.LoginUser(userid, pwd);
                return result;
            }
            catch (Exception ex)
            {
                //throw ex;
                return result;
            }

            
        }

        public Associate ForgotPassword(string userid, string associateid, string name)
        {
            Associate result = null;
            try
            {
                result = repository.ForgotPassword(userid == "-1" ? null : userid, Convert.ToInt32(associateid), name == "-1" ? null : name);
                return result;
            }
            catch (Exception ex)
            {
                //throw ex;
                return result;
            }
        }
        #endregion 

        #region Change Password

        public string ChangePassword(Cog.MLIAD.BusinessLogic.Associate.ChangePassword obj)
        {
            try
            {
                MLIADMobileService.SetNoCache();
                return repository.ChangePassword(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

    }
    
}
