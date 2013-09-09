using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AssociateConnect
{
    public partial class Associate : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["UserName"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
            }
            if (HttpContext.Current.Session["IsAdmin"].ToString() != "True")
            {
                NavigationMenu.Items[1].ChildItems.RemoveAt(3);
                NavigationMenu.Items[1].ChildItems.RemoveAt(2);
                NavigationMenu.Items[1].ChildItems.RemoveAt(1);
            }
            lblUserName.Text = HttpContext.Current.Session["UserName"].ToString();

        }
    }
}