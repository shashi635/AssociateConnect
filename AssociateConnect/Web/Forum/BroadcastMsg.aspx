<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeBehind="BroadcastMsg.aspx.cs" Inherits="BroadcastMsg" EnableViewState="false" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <script type="text/javascript">

        $(document).ready(function () {
            GetGroups();
            //--------------------------------------------------------------------------------------------------------------------------------//
            function reset() {
                $("#ddlGroup").val('');
                $("#txtMsg").val('');
                $("#lblStatus").text("");
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function GetGroups() {
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/getGroups',
                    complete: function (result) {
                        var data = JSON.parse(result.responseText);
                        var targetCntrl = $("#ddlGroup");
                        var options = "<option value=''></option>";
                        for (k = 0; k < (data.length); k++) {
                            options += "<option value='" + data[k].GroupID + "'>" + data[k].GroupDesc + "</option>";
                        }
                        targetCntrl.empty().append(options);
                    }
                });
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            $('#btnSend').click(function () {
                var userid = '<%=Session["UserName"]%>';
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/associate/' + userid,
                    contentType: "application/json; charset=utf-8",
                    complete: function (result) {
                        if (result.status == 200) {
                            var data = JSON.parse(result.responseText);
                            SaveMessage(data.AssociateID);
                        }
                    }
                });

            });
            //--------------------------------------------------------------------------------------------------------------------------------//
            function SaveMessage(id) {
                var gid = $("#ddlGroup").val();
                var msg = $("#txtMsg").val();
                if (gid != "") {
                    $.ajax({
                        type: "PUT",
                        url: '../../Service/Associate.svc/Forum/broadcastmsg/' + gid + '/' + id,
                        data: JSON.stringify(msg),
                        contentType: "application/json; charset=utf-8",
                        complete: function (result) {
                            $("#lblStatus").text("Message Sent successFully!").attr("style", "color:red;");
                        }
                    });
                    GetGroupMembers($("#ddlGroup").val());
                }
                else
                    $("#lblStatus").text("Please Select a Group...").attr("style", "color:red;");
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function GetGroupMembers(selGrp) {
                $.ajax({
                    type: "GET",
                    url: '/service/associate.svc/associate/assocaitepergroup/' + selGrp,
                    contentType: 'application/json; charset=utf-8',
                    success: function (result) {
                        if (result != null)
                            createSMSObject(result);
                    },
                    error: function (e, xhr) {
                    }
                });
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function createSMSObject(list) {

                var smsObj = new Object();
                smsObj.smsBody = $("#txtMsg").val();
                var strtolist = '91';
                for (i = 0; i < list.length; i++) {
                    if (i <= (list.length - 2))
                        strtolist += list[i].Mobile + ';91';
                    else
                        strtolist += list[i].Mobile;
                }
                smsObj.toList = strtolist;
                sendSMS(smsObj);

            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function sendSMS(smsObj) {
                $.ajax({
                    type: "PUT",
                    url: "/service/associate.svc/SMS/Broadcast",
                    data: JSON.stringify(smsObj),
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        if (result != "Sent Successfully..")
                            alert('Failed sending sms...');
                        reset();
                    },
                    error: function (e, xhr) {
                        alert('Failed sending sms...');
                        reset();
                    }
                });
            }

        });

    </script>

    <style type="text/css">
        
        </style>

</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>

        <img src="../Images/Heading/Broadcast_SMS.JPG" alt="Broadcast SMS" style="padding-left:35px;" />
        <br/>
        <div id="dvStatus" style="margin-left:120px;">
            <label id="lblStatus" ></label>
        </div>
        <br/>
        <label style="color:#9E9D81;padding:0px 0px 0px 120px"><strong>Please select group and write the message.</strong></label>
        <br/>
    <br />
        <fieldset id="fsSendMessage" class="fldset">
            <legend id="lgdSendMessage" class="legend">Send Message..</legend>
            <div id="dvSendMessge" >
            <table style="margin:20px 50px 0px 50px; ">
                <tr>
                    <td style="padding:0px 0px 0px 50px;">
                        <asp:Label ID="Label2" runat="server" CssClass ="label" Text="Group "></asp:Label>
                        <select id="ddlGroup" name="D2" style="width:180px">
                            <option></option>
                        </select></td>
                </tr>
                <tr>
                    <td style="padding:20px 0px 0px 50px;">
                        <asp:Label ID="Label5" runat="server" CssClass ="label" Text="Message.."></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="padding:0px 0px 0px 50px;">
                        <textarea id="txtMsg" name="S1" cols="60" rows="5"></textarea></td>
                </tr>
                <tr>
                    <td style="padding:0px 0px 0px 50px;">
                        <input id="btnSend" type="button" class = "button" value="Send" /></td>
                </tr>
            </table>
            </div>
        </fieldset>
    <br />
    <br />
<br/>
<br/>
<br/>
<br/>
</asp:Content>