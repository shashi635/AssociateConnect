﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestSMS.aspx.cs" Inherits="AssociateConnect.TestSMS" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <asp:TextBox ID="txtSMS" runat="server" TextMode="MultiLine"></asp:TextBox>
        <br />
        <asp:TextBox ID="txtCell" runat="server"></asp:TextBox>
     <br />
        <asp:Button ID="btn" runat="server" Text="Send SMS" onclick="btn1_Click" />
        <asp:Button ID="btn0" runat="server" Text="MVAyoo" onclick="btn_Click" />
    </div>
    </form>
   
</body>
</html>
