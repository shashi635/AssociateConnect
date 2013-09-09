<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeFile="SearchMember.aspx.cs" Inherits="SearchMember" EnableViewState="false"%>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link rel="stylesheet" type="text/css" href="../../Styles/Site.css" />
    <link rel="stylesheet" type="text/css" href="../../Styles/jquery.autocomplete.css" />
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.8.12.custom.css"   />
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.7.2.custom.css"   />
    
<%----------------------------------------------- script for Search section ---------------------------------------%>
    <script type="text/javascript">
        $(document).ready(function () {
            populateDesignation();
            populateProjectName();
            populateLocation();
            var popupshow = false;

            var ret;
            var searchkey = new Object();
            $('.trigger').hide();
            $('#warning').hide();
            $('#Label7').hide();
            $('#gridinstruction').hide();
            //----------------------------------------------------- Live textbox ------------------------------------------------------
            $('.textboxmember').focus(function () {
                $(this).removeClass("textboxmember");
                $(this).addClass("textboxhovermember");
            });

            $(".textboxmember").blur(function () {
                $(this).removeClass("textboxhovermember");
                $(this).addClass("textboxmember");
            });
            //-----------------------------------------------------------function populating location-----------------------------------------------------

            function populateLocation() {
                $.ajax({
                    url: "../../Service/Associate.svc/Location/get",
                    success: AjaxSucceeded,
                    error: AjaxFailed
                });

                function AjaxSucceeded(result) {
                    bindDropDownLocation('ddlLocation', result);
                }

                function AjaxFailed(result) { }

                function bindDropDownLocation(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].LocationID + "'>" + data[k].LocationName + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }

            //-----------------------------------------------------------function populating Projectname-----------------------------------------------------

            function populateProjectName() {
                $.ajax({
                    url: "../../Service/Associate.svc/Project/get",
                    success: AjaxSucceeded,
                    error: AjaxFailed
                });

                function AjaxSucceeded(result) {
                    bindDropDownProjectName('ddlProjectName', result);
                }

                function AjaxFailed(result) { }

                function bindDropDownProjectName(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].ProjectID + "'>" + data[k].ProjectName + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            //--------------------------------------------------------function populating title----------------------------------------------------
            function populateDesignation() {
                $.ajax({
                    url: "../../Service/Associate.svc/designation/get",
                    success: AjaxSucceeded,
                    error: AjaxFailed
                });
                function AjaxSucceeded(result) {
                    bindDropDownDesigantion('ddlDesignationSearch', result);
                }
                function AjaxFailed(result) {
                    alert("Title population failed!");
                }

                function bindDropDownDesigantion(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].DesignationID + "'>" + data[k].DesignationName + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            //------------------------------------------------------------------- search member ----------------------------------------------
            var grid = false;
            $('#btnsearch').click(function () {
                validate();
                if (ret) {
                    searchkey.AssociateID = ($("#txtAssociateIDSearch").val() == '') ? 0 : parseInt($("#txtAssociateIDSearch").val());
                    searchkey.DesignationID = parseInt($(":selected", $('#ddlDesignationSearch')).val());
                    searchkey.FirstName = $("#txtFirstNameSearch").val();
                    searchkey.LastName = $("#txtLastNameSearch").val().toString();
                    searchkey.ProjectID = parseInt($(":selected", $('#ddlProjectName')).val());
                    searchkey.LocationID = parseInt($(":selected", $('#ddlLocation')).val());
                    if (!grid) {
                        quickSearch();
                        grid = true;
                    }
                    else{
                        $("#tblDetails").setGridParam({rowNum:5});
                        $('.ui-pg-selbox')[0][0].selected = true;
                        $("#tblDetails").trigger("reloadGrid");
                    }
                }
                else
                $("#tblDetails").clearGridData();
            });

            function validate() {
                ret = true;
                $(".Warning").empty();
                var Val = new Object();
                Val.AssociateID = $("#txtAssociateIDSearch").val();
                Val.FirstName = $("#txtFirstNameSearch").val();
                Val.LastName = $("#txtLastNameSearch").val();
                Val.Designation = $(":selected", $('#ddlDesignationSearch')).text();
                Val.ProjectName = $(":selected", $('#ddlProjectName')).text();
                Val.Location = $(":selected", $('#ddlLocation')).text();
                if (Val.AssociateID == "" && Val.Designation == "" && Val.FirstName == "" && Val.LastName == "" && Val.ProjectName == "" && Val.Location == "") {
                    $('#<%=Label7.ClientID%>').append("Select any keyword to search member.");
                    ret = false;
                }
            }

            function formatePro(data) {
                //var data = JSON.parse(sdata.responseText);
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].ProjectID + ":" + data[k].ProjectName + " ";
                    else
                        rdata += "; " + data[k].ProjectID + ":" + data[k].ProjectName + " ";
                }
                return rdata;
            }
            function formateloc(data) {
                //var data = JSON.parse(sdata.responseText);
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].LocationID + ":" + data[k].LocationName + " ";
                    else
                        rdata += "; " + data[k].LocationID + ":" + data[k].LocationName + " ";
                }
                return rdata;
            }

            function formatedesg(data) {
                //var data = JSON.parse(sdata.responseText);
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].DesignationID + ":" + data[k].DesignationName + " ";
                    else
                        rdata += "; " + data[k].DesignationID + ":" + data[k].DesignationName + " ";
                }
                return rdata;
            }
            function quickSearch() {
                var Location = new Object();
                var Project = new Object();
                var Designation = new Object();
                $.ajax({ url: "../../Service/Associate.svc/Project/get", async: false, success: function (data, result) { Project = data; } });
                $.ajax({ url: "../../Service/Associate.svc/Location/get", async: false, success: function (data, result) { Location = data; } });
                $.ajax({ url: "../../Service/Associate.svc/Designation/get", async: false, success: function (data, result) { Designation = data; } });
                var pro = formatePro(Project);
                var loc = formateloc(Location);
                var desg = formatedesg(Designation);
                $('#gridinstruction').show();
                jQuery("#tblDetails").jqGrid({
                    datatype: function (gdata) {
                        $.ajax({
                            url: '../../Service/Associate.svc/associate/search?page=' + gdata.page + '&row=' + gdata.rows + '&count=0',
                            data: JSON.stringify(searchkey),
                            type: "PUT",
                            contentType: "application/json; charset=utf-8",
                            complete: function (jsondata) {
                                var g = jQuery("#tblDetails")[0];
                                var data = JSON.parse(jsondata.responseText);
                                var obj = new Object();
                                obj.MemberDetails = data.Items;
                                obj.page = data.Page;
                                obj.total = data.PageTotal;
                                obj.records = data.ItemCount;
                                g.addJSONData(obj);
                            }
                        });
                    },
                    colNames: ['AssociateID', 'FirstName', 'LastName', 'Email', 'Address', 'DOB', 'DOJ', 'Designation', 'DesignationID', 'DirectReportID', 'IsActive', 'IsApproved', 'Location', 'LocationID', 'ModifiedBy', 'ModifiedOn', 'Password', 'Phones', 'ProjectID', 'ProjectName', 'UserID', 'Mobile'],
                    colModel: [{ name: 'AssociateID', index: 'associateID', formatoptions: { text: 'verdana', size: '8' }, sortable: true },
                               { name: 'FirstName', index: 'FirstName', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'LastName', index: 'LastName', formatoptions: { text: 'verdana', size: '8' }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'email', index: 'email', formatoptions: { text: 'verdana', size: '8' }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { email: true} },
                               { name: 'Address', index: 'Address', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'DOB', index: 'DOB', formatoptions: { text: 'verdana', size: '8' }, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { date: true} },
                               { name: 'DOJ', index: 'DOJ', formatoptions: { text: 'verdana', size: '8' }, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { date: true} },
                               { name: 'Designation', index: 'Designation', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: desg, size: 30, maxlength: 50 }, editrules: { required: true} },
                               { name: 'DesignationID', index: 'DesignationID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'DirectReportID', index: 'DirectReportID', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'IsActive', index: 'IsActive', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'IsApproved', index: 'IsApproved', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'Location', index: 'Location', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: loc, size: 30, maxlength: 50 }, editrules: { required: true} },
                               { name: 'LocationID', index: 'LocationID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ModifiedBy', index: 'ModifiedBy', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ModifiedOn', index: 'ModifiedOn', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Password', index: 'Password', formatoptions: { text: 'verdana', size: '8' }, hidden: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: true} },
                               { name: 'Phones', index: 'Phones', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ProjectID', index: 'ProjectID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ProjectName', index: 'ProjectName', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: pro, size: 30, maxlength: 50 }, editrules: { required: true} },
                               { name: 'UserID', index: 'UserID', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: true} },
                               { name: 'Mobile', index: 'Mobile', formatoptions: { text: 'verdana', size: '8' }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: false}}],
                    rowNum: 5,
                    rowList: [5, 10, 20, 50],
                    pager: jQuery("#pager"),
                    height: 'auto',
                    width: 1180,
                    imgpath: "~/App_Themes/Default/images",
                    scrollOffset: 0,
                    sortname: 'AssociateID',
                    sortorder: "asc",
                    viewrecords: true,
                    editurl: "../../Service/Associate.svc/associate/edit",         // "EditMember.ashx",
                    jsonReader: {
                        root: "MemberDetails",
                        page: "page",
                        total: "total",
                        records: "records",
                        cell: "",
                        id: "AssociateID",
                        repeatitems: false
                    },
                    gridComplete: function () {
                        grid = true;
                    }
                });
                <%if (HttpContext.Current.Session["IsAdmin"].ToString() == "True" ) {%>
                    jQuery("#tblDetails").jqGrid('navGrid', '#pager', { view: true, add: false, search: false, del: false }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true}, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { reloadAfterSubmit: false, jqModal: false, closeOnEscape: true }, { closeOnEscape: true }, { navkeys: [true, 38, 40], height: 250, jqModal: false, closeOnEscape: true });
                <%}else{ %>
                    jQuery("#tblDetails").jqGrid('navGrid', '#pager', { view: true, add: false, search: false, edit: false, del: false }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { reloadAfterSubmit: false, jqModal: false, closeOnEscape: true }, { closeOnEscape: true }, { navkeys: [true, 38, 40], height: 250, jqModal: false, closeOnEscape: true });
                <%} %>

            }  // quickSearch() ends..
           
        });
    </script>

<style type="text/css">
    .popup 
    {
        font-style:normal;
        position: absolute;
        display: none;
        color:Red;
        font-style:normal;
        background-color:#AAAAAA;
    }
    .grid
    {
        max-width:1000px;
    }
    #ddltitle
    {
        width: 57px;
    }
        #ddlTitle
    {
        width: 222px;
    }
        #ddlTitleUp
    {
        width: 222px;
    }
    #txtareaaddressup
    {
        width: 218px;
    }
        #ddlAccountSearch
    {
        width: 222px;
    }
        #ddlDesignationSearch
    {
        width: 222px;
    }
        .style10
    {
        width: 220px;
    }
        #ddlPracticeSearch
    {
        width: 222px;
    }
        #ddlProjectSearch
    {
        width: 222px;
    }
        #ddlLocation
    {
        width: 222px;
    }
        #ddlProjectName
    {
        width: 222px;
    }
        </style>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>
        <img src="../Images/Heading/Search_Member.JPG" alt="Edit Member" style="padding-left:35px;"/>
        <br/>
        <asp:Label ID="Label7" runat="server" style="padding-left:120px;" class="Warning"></asp:Label>
        
<div id="SearchMember">
    <br />
    <fieldset class="fldset" >
    <legend>Search Member</legend>
        <table style="margin-bottom: 0px;" align="center">
            <tr>
                <td>
        <asp:Label ID="Label1" runat="server" Text="Associate ID" CssClass="label"></asp:Label>
                </td>
                <td class="style10">
        <input id="txtAssociateIDSearch" class="textboxmember" type="text" /></td>
                <td  style="padding-left:100px;">
        <asp:Label ID="lblDesignation" runat="server"  CssClass="label"
            Text="Designation"></asp:Label>
                </td>
                <td>
                    <select id="ddlDesignationSearch" >
                        <option></option>
                    </select></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="4">
                     </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label17" runat="server" class="label" Text="First Name"></asp:Label> </td>
                <td width="81" class="style10">
                
    <input id="txtFirstNameSearch" class="textboxmember" type="text" /></td>
                <td style="padding-left:100px;">
    <asp:Label ID="Label8" runat="server" class="label" Text=" Last Name"></asp:Label>
                </td>
                <td class="style16">
                    <input id="txtLastNameSearch" type="text" class="textboxmember" /></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="4">
                     </td>
            </tr>
           
            <tr>
                <td>
                    <asp:Label ID="Label18" runat="server" CssClass="label"
                        Text="Project"></asp:Label>
                </td>
                <td class="style10">
                    <select id="ddlProjectName" name="D2">
                        <option></option>
                    </select></td>
                <td  style="padding-left:100px;">
                    <asp:Label ID="Label3" runat="server" CssClass="label"
                        Text="Location"></asp:Label>
                </td>
                <td>
                    <select id="ddlLocation" name="D1">
                        <option></option>
                    </select></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="4">
                    </td>
            </tr>
            <tr>
                <td colspan="2">
                     </td>
                <td colspan="2">
        <input id="btnsearch" type="button" class="button" value="Search" /></td>
            </tr>
           
            </table>
        </fieldset>
    <br/>
    <br/>
    <span id="gridinstruction">
    <strong><em style="padding-left:120px;">Select any row for updating the record.</em></strong>
    </span>
    <br/>
    <br/>
    <div id="tblDetailsdiv" style="font-size: 8pt;" align="center">
    <table id="tblDetails" class="Scroll"  cellpadding="0" cellspacing="0" style="font-size: 8pt;
      top: 50px;">
    </table>
    <div id="pager" style="TEXT-ALIGN: center"></div>
  </div>
  
    
    </div>
    <br />
        <br />
    
</asp:Content>
