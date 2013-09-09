using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Net.Mail;

namespace AssociateConnect
{
    public partial class TestSMS : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        
        
        

        protected void btn_Click(object sender, EventArgs e)
        {
            string strUrl = "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=singh635@gmail.com:asdfgert&senderID=TEST SMS&receipientno=91"+txtCell.Text.Trim()+"&msgtxt="+txtSMS.Text.Trim()+"&state=4";
            WebRequest request = HttpWebRequest.Create(strUrl);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            Stream s = (Stream)response.GetResponseStream();
            StreamReader readStream = new StreamReader(s);
            string dataString = readStream.ReadToEnd();
            response.Close();
            s.Close();
            readStream.Close();
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            //HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("http://ubaid.tk/sms/sms.aspx?uid=" + "arghaece" + "&pwd=" + "argha007" + "&msg=" + "hekl" + "&phone=" + "9674653032" + "&provider=indyarocks");
            HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("http://ubaid.tk/sms/sms.aspx?uid=" + "7890851146" + "&pwd=" + "asdfgert" + "&msg=" + txtSMS.Text.Trim() + "&phone=" + txtCell.Text.Trim() + "&provider=fullonsms");

            HttpWebResponse myResp = (HttpWebResponse)myReq.GetResponse();
            System.IO.StreamReader respStreamReader = new System.IO.StreamReader(myResp.GetResponseStream());
            string responseString = respStreamReader.ReadToEnd();
            respStreamReader.Close();
            myResp.Close();
            return;

        }

    }
}