<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeBehind="ApproveMember.aspx.cs" Inherits="ApproveMember" EnableViewState="false" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <script type="text/javascript">

        $(document).ready(function () {
            var count = 1;
            reset();
            function reset() {
                count = count + 1;
                PopulateRequest();
                $('#Approve').hide();
                $('#successfull_approval').hide();
                $('#successfull_rejection').hide();
                $('#NoPendingRequest').hide();
                $('#PendingRequest').hide();
            }
            function PopulateRequest() {
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/associate/' + count + '/getPendingRequest',
                    complete: function (result) {
                        var data = JSON.parse(result.responseText);
                        var targetCntrl = $("#ddlRequest");
                        var options = "<option value=''></option>";
                        for (k = 0; k < (data.length); k++) {
                            options += "<option value=''>" + data[k].AssociateID + "</option>";
                        }
                        targetCntrl.empty().append(options);
                        if (data.length > 0)
                            $('#PendingRequest').show();
                        else
                            $('#NoPendingRequest').show();
                    }
                });
            }

            $("#ddlRequest").change(function () {
                var AssociateID = $(":selected", $('#ddlRequest')).text();
                if (AssociateID == "")
                    $('#Approve').hide();
                else {
                    $.ajax({
                        type: "GET",
                        url: '../../Service/Associate.svc/associate/' + AssociateID + '/getDetails',
                        complete: function (result) {
                            $('#Approve').show();
                            var data = JSON.parse(result.responseText);
                            $('#<%=lblID.ClientID %>').text(data.AssociateID);
                            $('#<%=lblName.ClientID %>').text(data.FirstName + " " + data.LastName);
                            $('#<%=lblDesignation.ClientID %>').text(data.Designation);
                            $('#<%=lblPractice.ClientID %>').text(data.PracticeName);
                            $('#<%=lblAccount.ClientID %>').text(data.AccountName);
                            $('#<%=lblLocation.ClientID %>').text(data.Location);
                            $('#<%=lblMobile.ClientID %>').text(data.Mobile);
                            $('#<%=lblEmail.ClientID %>').text(data.email);
                            $('#<%=lblDOJ.ClientID %>').text(data.DOJ);
                            $('#<%=lblProject.ClientID %>').text(data.ProjectName);
                            $('#lblGroup').text(data.GroupName);

                            getRole();
                            getGroup(data.GroupName);
                        }
                    });
                }
            });

            function getRole() {
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/getRoles',
                    complete: function (result) {
                        var data = JSON.parse(result.responseText);
                        var targetCntrl = $("#ddlRole");
                        var options = "";
                        for (k = 0; k < (data.length); k++) {
                            options += "<option value='" + data[k].RoleID + "'>" + data[k].RoleDesc + "</option>";
                        }
                        targetCntrl.empty().append(options);
                    }
                });
            }

            function getGroup(GroupName) {
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/getGroups',
                    complete: function (result) {
                        var data = JSON.parse(result.responseText);
                        var targetCntrl = $("#ddlGroup");
                        var options = "";
                        for (k = 0; k < (data.length); k++) {
                            options += "<option value='" + data[k].GroupID + "'>" + data[k].GroupDesc + "</option>";
                        }
                        targetCntrl.empty().append(options);
                    }
                });
                
            }

            $('#btnApprove').click(function () {
                var AssociateID = $('#<%=lblID.ClientID%>').text();
                var RoleID = $(":selected", $('#ddlRole')).val();
                var GroupID = "";
                var Approver = "<%=HttpContext.Current.Session["UserName"].ToString()%>";
                var len = $(":selected", $('#ddlGroup')).length;
                for (var i = 0; i < len; i++) {
                    var val = $(":selected", $('#ddlGroup'))[i].value;
                    if (i == 0)
                        GroupID = val;
                    else
                        GroupID = GroupID + "," + val;
                }
                //var GroupID = $(":selected", $('#ddlGroup')).val();
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/Associate/' + AssociateID + '/' + RoleID + '/' + GroupID + '/' + Approver + '/approveRequest',
                    complete: function (result) {
                        if (result.responseText == "1") {
                            reset();
                            $('#successfull_approval').show();
                        }
                        //window.location = "../Default.aspx";
                        else;
                        //$('#Login_failed').show();
                    }
                });
            });

            $('#btnReject').click(function () {
                var AssociateID = $('#<%=lblID.ClientID%>').text();
                var RoleID = $(":selected", $('#ddlRole')).val();
                var GroupID = $(":selected", $('#ddlGroup')).val();
                var Approver = "<%=HttpContext.Current.Session["UserName"].ToString()%>";
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/Associate/' + AssociateID + '/' + RoleID + '/' + GroupID + '/' + Approver + '/rejectRequest',
                    complete: function (result) {
                        if (result.responseText == "1") {
                            reset();
                            $('#successfull_rejection').show();
                        }
                        //window.location = "../Default.aspx";
                        else;
                        //$('#Login_failed').show();
                    }
                });
            });
        });

    </script>

    <style type="text/css">
        .style3
        {
            width: 100px;
        }
        #Select1
        {
            width: 200px;
        }
        .style4
        {
            width: 60px;
        }
        #ddlRequest
        {
            width: 298px;
            height: 99px;
        }
        #ddlGroup
        {
            width: 200px;
        }
        #ddlRole
        {
            width: 200px;
        }
        .style5
        {
            margin-top: 10px;
            elevation: above;
            width: 158px;
        }
        .style6
        {
            width: 367px;
        }
        .style7
        {
            color: #ACA991;
        }
        .style8
        {
            color: #9E9D81;
        }
        #stGroup
        {
            width: 197px;
        }
    </style>

</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>
        <img src="../Images/Heading/ApproveMember.JPG" alt="Approve Member" style="padding-left:35px;" />
        <br/>

        <div id="successfull_approval">
        <span class="style4">
        <strong><em style="padding-left:120px; color: #FF0000">Request has been successfully approved.</em></strong>
        </span>
        </div> 
        
        <div id="successfull_rejection">
        <span class="style4">
        <strong><em style="padding-left:120px;color: #FF0000">Request has been successfully rejected.</em></strong>
        </span>
        </div>
        <div id="NoPendingRequest">
        <span class="style4">
        <strong><em style="padding-left:120px;" class="style7">No pending request to Approve/Reject.</em></strong>
        </span>
        </div>
        <div id="PendingRequest">
        <span class="style4">
        <strong><em style="padding-left:120px;" class="style8">select any pending request to Approve/Reject.</em></strong>
        </span>
        </div>

        <br/>
    <table style="width: 100%;">
        <tr>
            <td class = "style5" align="left">
                </td>
            <td class = "tdapproval" align="left" colspan="3">
            <fieldset class="fldset_approve" >
        <legend>Pending Request</legend>

                <select id="ddlRequest" name="D3">
                    <option></option>
                </select>


    </fieldset></td>
        </tr>
        <tr id = "Approve">
            <td class = "style5" align="right">
                </td>
            <td align="left" class="style6">
              <fieldset class="fldset_approve" >
        <legend>Approve/Reject Request</legend>


        <table style="width:100%;">
            <tr>
                <td class="style3" align="left">
                    <asp:Label ID="Label1" runat="server" Text="Associate ID"></asp:Label>
                </td>
                <td align="left">
                    <asp:Label ID="lblID" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3" align="left">
                    <asp:Label ID="Label2" runat="server" Text="Name"></asp:Label>
                </td>
                <td align="left">
                    <asp:Label ID="lblName" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>
        <hr />
        <table style="width:100%;">
            <tr>
                <td class="style4" align="left">
                    <asp:Label ID="Label4" runat="server" Text="Role"></asp:Label>
                </td>
                <td align="left">
                    <select id="ddlRole" name="D2">
                        <option></option>
                    </select></td>
            </tr>
            <tr>
                <td class="style4" align="left">
                    <asp:Label ID="Label3" runat="server" Text="Group"></asp:Label>
                </td>
                <td align="left">
                    <select id="ddlGroup" name="D1" multiple="multiple">
                        <option></option>
                    </select></td>
            </tr>
            
        </table>
        <br/>
        <table style="width:100%;">
            <tr>
                <td>
                    <input id="btnApprove" class="button" type="button" value="Approve" /></td>
                <td>
                    <input id="btnReject" class="button" type="button" value="Reject" /></td>
            </tr>
            </table>
            <br/>
    </fieldset></td>
            <td>
            
    <fieldset class="fldset_approve" >
        <legend>Associate Details</legend>


        <table style="width:100%;">
            <tr>
                <td class="style3">
                    <asp:Label ID="Label7" runat="server" Text="Designation"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblDesignation" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label5" runat="server" Text="Practice"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblPractice" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label6" runat="server" Text="Account"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblAccount" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label8" runat="server" Text="Location"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblLocation" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label9" runat="server" Text="Mobile"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblMobile" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label10" runat="server" Text="Email"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblEmail" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label11" runat="server" Text="DOJ"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblDOJ" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="Label12" runat="server" Text="Project"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblProject" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <label>Group</label></td>
                <td>
                    <label id="lblGroup"></label>
                </td>
            </tr>
            </table>
    </fieldset></td>
            <td>
                </td>
        </tr>
    </table>
<br/>
<br/>
<br/>
<br/>
</asp:Content>