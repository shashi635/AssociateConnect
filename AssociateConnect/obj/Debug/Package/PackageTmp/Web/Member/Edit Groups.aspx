<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeBehind="Edit Groups.aspx.cs" Inherits="Edit_Groups" EnableViewState="false" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.7.2.custom.css"   />
    <script type="text/javascript">

        $(document).ready(function () {
            var i = 0;
            var j = 0;
            var k = 0;
            var gid = "";
            var rid = "";
            var grid2 = false;
            var oldlist = new Object();
            var searchkey = new Object();
            var searchkey2 = new Object();
            var selectedMember = new Object();
            selectedMember.value = "";
            selectedMember.text = "";
            reset();
            populateLocation();
            populateProjectName();
            populateDesignation();
            $("#dvManage").slideToggle("slow");
            function reset() {
                $('#lblStatus').text("");
                $('#btnAdd2').hide();
                $('#lstAssociate2').empty();
                $('#successfull_Update').hide();
                $("#dvmem2").slideToggle("slow");

            }
            //----------------------------------------------------- Live textbox ------------------------------------------------------
            $('.textboxmember').focus(function () {
                $(this).removeClass("textboxmember");
                $(this).addClass("textboxhovermember");
            });
            $(".textboxmember").blur(function () {
                $(this).removeClass("textboxhovermember");
                $(this).addClass("textboxmember");

            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $("#lgdAdd").click(function () {
                $('#lblStatus').text("");
                $("#dvAdd").slideToggle("slow");
                $("#dvManage").slideToggle("slow");
                j = 0;
                k = 0;
                if (i == 0) {
                    document.getElementById("imgadd").src = "../Images/plus2.jpg";
                    document.getElementById("imgmanage").src = "../Images/minus2.jpg";
                    i = 1;
                    getGroup();
                    getRole();
                }
                else {
                    document.getElementById("imgadd").src = "../Images/minus2.jpg";
                    document.getElementById("imgmanage").src = "../Images/plus2.jpg";
                    i = 0;
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $("#lgdManage").click(function () {
                $('#lblStatus').text("");
                $("#dvAdd").slideToggle("slow");
                $("#dvManage").slideToggle("slow");
                j = 0;
                k = 0;
                if (i == 0) {
                    document.getElementById("imgadd").src = "../Images/plus2.jpg";
                    document.getElementById("imgmanage").src = "../Images/minus2.jpg";
                    i = 1;
                    getGroup();
                    getRole();
                }
                else {
                    document.getElementById("imgadd").src = "../Images/minus2.jpg";
                    document.getElementById("imgmanage").src = "../Images/plus2.jpg";
                    i = 0;
                }

            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $("#lgdmem2").click(function () {
                $("#dvmem2").slideToggle("slow");
                if (j == 0) {
                    document.getElementById("imgmem2").src = "../Images/minus2.jpg";
                    j = 1;
                }
                else {
                    document.getElementById("imgmem2").src = "../Images/plus2.jpg";
                    j = 0;
                }
            });
            //-----------------------------------------------------------function populating location-----------------------------------------------------
            function populateLocation() {
                $.ajax({
                    url: "../../Service/Associate.svc/Location/get",
                    success: AjaxSucceeded,
                    error: AjaxFailed
                });

                function AjaxSucceeded(result) {
                    bindDropDownLocation('ddlLocation2', result);
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
                    bindDropDownProjectName('ddlProject2', result);
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
                    bindDropDownDesigantion('ddlDesignation2', result);
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
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnCreateGroup').click(function () {
                var gName = $('#txtGroupName')[0].value;
                var gDesc = $('#txtGroupName')[0].value;
                if (gName == "") {
                    $("#lblStatus").text("Please enter CategoryName.").attr("style", "color:red;");
                }
                else if (gDesc == "") {
                    $("#lblStatus").text("Please enter CategoryDesc.").attr("style", "color:red;");
                }
                else {
                    $.ajax({
                        type: "GET",
                        url: '../../Service/Associate.svc/CreateGroup/' + gName + '/' + gDesc + "",
                        complete: function (result) {
                        }
                    });
                    $('#lblStatus').text("");
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            function getGroup() {
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
            //------------------------------------------------------------------------------------------------------------------------------------//
            function getRole() {
                $.ajax({
                    type: "GET",
                    url: '../../Service/Associate.svc/getRoles',
                    complete: function (result) {
                        var data = JSON.parse(result.responseText);
                        var targetCntrl = $("#ddlRole");
                        var options = "<option value=''></option>";
                        for (k = 0; k < (data.length); k++) {
                            options += "<option value='" + data[k].RoleID + "'>" + data[k].RoleDesc + "</option>";
                        }
                        targetCntrl.empty().append(options);
                    }
                });
            }
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#search').click(function () {
                gid = $(":selected", $('#ddlGroup')).val();
                rid = $(":selected", $('#ddlRole')).val();
                if (gid == "") {
                    $("#lblStatus").text("Please select a group.").attr("style", "color:red;");
                }
                else if (rid == "") {
                    $("#lblStatus").text("Please select a role.").attr("style", "color:red;");
                }
                else {
                    $.ajax({
                        type: "GET",
                        url: '../../Service/Associate.svc/associate/assocaitepergroupandrole/' + gid + '/' + rid,
                        contentType: 'application/json; charset=utf-8',
                        success: function (result) {
                            var data = result;
                            oldlist = result;
                            var targetCntrl = $("#lstAssociate2");
                            var options = "";
                            for (k = 0; k < (data.length); k++) {
                                options += "<option value='" + data[k].AssociateID + "'>" + data[k].AssociateID + "," + data[k].FirstName + " " + data[k].LastName + "</option>";
                            }
                            targetCntrl.empty().append(options);
                        },
                        error: function (e, xhr) {
                        }
                    });
                    $("#lblStatus").text("");
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnRemove2').click(function () {
                if ($('#lstAssociate2 :selected').length == 0) {
                    $("#lblStatus").text("Please select a member to remove.").attr("style", "color:red;");
                }
                else {
                    $('#lstAssociate2 :selected').each(function (i, selected) {
                        $(selected).remove();
                    });
                    $("#lblStatus").text("");
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnClear2').click(function () {
                if ($('#lstAssociate2')[0].value == "") {
                    $("#lblStatus").text("Memberlist is already clear.").attr("style", "color:red;");
                }
                else {
                    $('#lstAssociate2').empty();
                    $("#lblStatus").text("");
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnUpdateGroup').click(function () {
                var add = true;
                var remove = true;
                var af = 1;
                var rf = 1;
                var list = "";
                var addlist = "none";
                var removelist = "none";
                var len = $('#lstAssociate2')[0].options.length;
                for (var i = 0; i < len; i++) {
                    var item = $('#lstAssociate2')[0].options[i].value;
                    add = true;
                    for (var j = 0; j < oldlist.length; j++) {
                        if (oldlist[j].AssociateID == item) {
                            add = false;
                            continue;
                        }
                    }
                    if (add == true) {
                        if (af == 1) {
                            addlist = item;
                            af++;
                        }
                        else
                            addlist = addlist + "," + item;
                    }
                }

                for (var i = 0; i < oldlist.length; i++) {
                    var item = oldlist[i].AssociateID;
                    remove = true;
                    for (var j = 0; j < len; j++) {
                        if ($('#lstAssociate2')[0].options[j].value == item) {
                            remove = false;
                            continue;
                        }
                    }
                    if (remove == true) {
                        if (rf == 1) {
                            removelist = item;
                            rf++;
                        }
                        else
                            removelist = removelist + "," + item;
                    }
                }

                if (gid == "") {
                    $("#lblStatus").text("Please select a group.").attr("style", "color:red;");
                }
                else if (rid == "") {
                    $("#lblStatus").text("Please select a role.").attr("style", "color:red;");
                }
                else {
                    $.ajax({
                        type: "GET",
                        url: '../../Service/Associate.svc/UpdateGroup/' + gid + '/' + rid + '/' + addlist + '/' + removelist + '',
                        complete: function (result) {
                        }
                    });
                    $("#lblStatus").text("");
                }
            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnsearch2').click(function () {
                validate2();

            });
            //------------------------------------------------------------------------------------------------------------------------------------//
            function validate2() {
                var Val = new Object();
                Val.AssociateID = $("#txtAssociateID2").val();
                Val.FirstName = $("#txtFirstName2").val();
                Val.LastName = $("#txtLastName2").val();
                Val.Designation = $(":selected", $('#ddlDesignation2')).text();
                Val.ProjectName = $(":selected", $('#ddlProject2')).text();
                Val.Location = $(":selected", $('#ddlLocation2')).text();
                if (Val.AssociateID == "" && Val.Designation == "" && Val.FirstName == "" && Val.LastName == "" && Val.ProjectName == "" && Val.Location == "") {
                    $("#lblStatus").text("Please select a group.").attr("style", "color:red;");
                }
                else {
                    searchmember();
                    $("#lblStatus").text("");
                }
            }
            //------------------------------------------------------------------------------------------------------------------------------------//
            function searchmember() {
                if (ret) {
                    searchkey2.AssociateID = ($("#txtAssociateID2").val() == '') ? 0 : parseInt($("#txtAssociateID2").val());
                    searchkey2.DesignationID = parseInt($(":selected", $('#ddlDesignation2')).val());
                    searchkey2.FirstName = $("#txtFirstName2").val();
                    searchkey2.LastName = $("#txtLastName2").val().toString();
                    searchkey2.ProjectID = parseInt($(":selected", $('#ddlProject2')).val());
                    searchkey2.LocationID = parseInt($(":selected", $('#ddlLocation2')).val());
                    if (!grid2) {
                        quickSearch2();
                        grid2 = true;
                    }
                    else
                        $("#tblDetails2").trigger("reloadGrid");
                }
                else
                    $("#tblDetails2").clearGridData();
            }
            //------------------------------------------------------------------------------------------------------------------------------------//
            function quickSearch2() {
                jQuery("#tblDetails2").jqGrid({
                    datatype: function (gdata) {
                        $.ajax({
                            url: '../../Service/Associate.svc/associate/search?page=' + gdata.page + '&row=' + gdata.rows + '&count=0',
                            data: JSON.stringify(searchkey2),
                            type: "PUT",
                            contentType: "application/json; charset=utf-8",
                            complete: function (jsondata) {
                                var g = jQuery("#tblDetails2")[0];
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
                    colModel: [{ name: 'AssociateID', index: 'associateID', formatoptions: { text: 'verdana', size: '8'} },
                               { name: 'FirstName', index: 'FirstName', formatoptions: { text: 'verdana', size: '8', width: 100} },
                               { name: 'LastName', index: 'LastName', formatoptions: { text: 'verdana', size: '8'} },
                               { name: 'email', index: 'email', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Address', index: 'Address', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'DOB', index: 'DOB', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'DOJ', index: 'DOJ', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Designation', index: 'Designation', formatoptions: { text: 'verdana', size: '8', width: 100} },
                               { name: 'DesignationID', index: 'DesignationID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'DirectReportID', index: 'DirectReportID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'IsActive', index: 'IsActive', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'IsApproved', index: 'IsApproved', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Location', index: 'Location', formatoptions: { text: 'verdana', size: '8', width: 100} },
                               { name: 'LocationID', index: 'LocationID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ModifiedBy', index: 'ModifiedBy', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ModifiedOn', index: 'ModifiedOn', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Password', index: 'Password', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Phones', index: 'Phones', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ProjectID', index: 'ProjectID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'ProjectName', index: 'ProjectName', formatoptions: { text: 'verdana', size: '8', width: 100 }, hidden: true },
                               { name: 'UserID', index: 'UserID', formatoptions: { text: 'verdana', size: '8' }, hidden: true },
                               { name: 'Mobile', index: 'Mobile', formatoptions: { text: 'verdana', size: '8'}}],
                    rowNum: 5,
                    //rowList: [5, 10, 20, 50],
                    pager: jQuery("#pager2"),
                    height: 'auto',
                    width: 'auto',
                    imgpath: "~/App_Themes/Default/images",
                    scrollOffset: 0,
                    sortname: 'AssociateID',
                    onSelectRow: function (id) {
                        var row = $('#tblDetails2').jqGrid('getRowData', id);
                        selectedMember.value = row.AssociateID.toString();
                        selectedMember.text = row.AssociateID.toString() + "," + row.FirstName.toString() + " " + row.LastName.toString();
                    },
                    sortorder: "asc",
                    viewrecords: true,
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
                        grid2 = true;
                    }
                });
                $('#btnAdd2').show();
                //jQuery("#tblDetails").jqGrid('navGrid', '#pager', { view: true, add: false, search: false, edit: false, del: false, reload:false }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { reloadAfterSubmit: false, jqModal: false, closeOnEscape: true }, { closeOnEscape: true }, { navkeys: [true, 38, 40], height: 250, jqModal: false, closeOnEscape: true });
            }  // quickSearch() ends..
            //------------------------------------------------------------------------------------------------------------------------------------//
            $('#btnAdd2').click(function () {
                if (selectedMember.value != "") {
                    var targetCntrl = $("#lstAssociate2");
                    var options = "<option value='" + selectedMember.value + "'>" + selectedMember.text + "</option>";
                    targetCntrl.append(options);
                    selectedMember.value = "";
                    selectedMember.text = "";
                }
            });
            
        });

    </script>

    <style type="text/css">
        .style4
        {
            width: 60px;
        }
        #ddlGroup
        {
            width: 200px;
        }
        #ddlRole
        {
            width: 200px;
        }
        .style8
        {
            color: #9E9D81;
        }
        #ddlDesignation2
        {
            width: 222px;
        }
        #ddlProject2
        {
            width: 222px;
        }
        #ddlLocation2
        {
            width: 222px;
        }
    </style>

</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<br/>
        <img src="../Images/Heading/Groups.JPG" alt="Approve Member" style="padding-left:35px;" />
        <br/>
        <div id="EditRoleGroup" style="padding-left:120px;">
        <span class="style4">
        <strong><em class="style8">Please enter AssociateID to edit Role/Group.</em></strong>
        </span>
        </div>
        <div id="successfull_Update" style="padding-left:120px;">
        <span class="style4">
        <strong><em style="color: #FF0000">Role/Group has been successfully updated.</em></strong>
        </span>
        </div> 
        <div id="dvStatus" style="margin-left:120px;">
        <label id="lblStatus" ></label>
        </div><br/>
        <br/>
        <fieldset id="fsAddGroup" class="fldset">
            <legend id="lgdAdd" class="legend"><img src="../Images/minus2.jpg" id="imgadd" alt=""/>Create new Group</legend>
            <div id="dvAdd" align="center" >
                <table style="width: 90%;">
                    <tr>
                        <td style="width:80px">
                            <asp:Label ID="Label13" runat="server" CssClass="label" Text="Group Name"></asp:Label>
                        </td>
                        <td>
                            <input id="txtGroupName" class="textboxmember" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width:80px">
                            <asp:Label ID="Label9" runat="server" CssClass="label" Text="Group Desc" ></asp:Label>
                        </td>
                        <td>
                            <textarea id="TextArea1" cols="60" rows="3"></textarea></td>
                    </tr>
                  
                    <tr>
                        <td style="width:80px">
                             </td>
                        <td>
                            <input id="btnCreateGroup" style="width: 120px;" type="button" class="button" value="Create Group" /></td>
                    </tr>
                  </table>
                <br />
                
            </div>
        </fieldset>
        <br />
        <br />
        <br />
    
        <fieldset id="fsManageGroup" class="fldset">
            <legend id="lgdManage" class="legend"><img src="../Images/plus2.jpg" id="imgmanage" alt=""/>Manage Groups</legend>
            <div id="dvManage" align="center" >

            
                <table style="width: 90%;">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="Label1" runat="server" CssClass="label" Text="Group "></asp:Label>
                            <select id="ddlGroup">
                                <option></option>
                            </select><asp:Label ID="Label8" runat="server" CssClass="label" style="padding:0px 0px 0px 40px" Text="Role "></asp:Label>
                            <select id="ddlRole">
                                <option></option>
                            </select><input id="search" type="button" value="Search" class="button" style="margin:0px 0px 0px 40px"/></td>
                    </tr>
                    <tr>
                        <td style="width: 90%;" rowspan="4">
                                        <select id="lstAssociate2" multiple="multiple" 
                                style="width: 100%; height: 200px" name="D3">
                                            <option></option>
                                        </select></td>
                        <td style="height: 50px">
                                         </td>
                    </tr>
                    <tr>
                        <td style="height: 50px">
                                        <input id="btnRemove2" type="button" class="button" value="Remove" /></td>
                    </tr>
                    <tr>
                        <td style="height: 50px">
                                        <input id="btnClear2" type="button" class="button" value="Clear" /></td>
                    </tr>
                    <tr>
                        <td style="height: 50px">
                            <input id="btnUpdateGroup" style="width: 120px;" type="button" class="button" value="Update Group" /></td>
                    </tr>
                </table>
                <br />
                <fieldset id="Fieldset1" style="width: 90%;">
                    <legend id="lgdmem2" class="legend"><img src="../Images/plus2.jpg" id="imgmem2" alt=""/>Add Members</legend>
                    <div id="dvmem2">
                    <table style="width: 90%;">
                        <tr>
                        <td colspan="2">
                            <table style="margin-bottom: 0px;" align="center">
                                <tr>
                                    <td>
                            <asp:Label ID="Label2" runat="server" Text="Associate ID" 
                                Font-Bold="False" ForeColor="#3366CC"></asp:Label>
                                    </td>
                                    <td class="style10">
                            <input id="txtAssociateID2" class="textboxmember" type="text" /></td>
                                    <td >
                                         </td>
                                    <td>
                            <asp:Label ID="Label3" runat="server" Font-Bold="False" ForeColor="#3366CC" 
                                Text="Designation"></asp:Label>
                                    </td>
                                    <td>
                                        <select id="ddlDesignation2" >
                                            <option></option>
                                        </select></td>
                                </tr>
                                <tr>
                                    <td class="emptyrow" colspan="5">
                                         </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" class="label" Text="First Name"></asp:Label> </td>
                                    <td width="81" class="style10">
                
                        <input id="txtFirstName2" class="textboxmember" type="text" /></td>
                                    <td >
                                        </td>
                                    <td class="style18">
                        <asp:Label ID="Label5" runat="server" class="label" Text=" Last Name"></asp:Label>
                                    </td>
                                    <td class="style16">
                                        <input id="txtLastName2" type="text" class="textboxmember" /></td>
                                </tr>
                                <tr>
                                    <td class="emptyrow" colspan="5">
                                        </td>
                                </tr>
           
                                <tr>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Font-Bold="False" ForeColor="#3366CC" 
                                            Text="Project"></asp:Label>
                                    </td>
                                    <td class="style10">
                                        <select id="ddlProject2" name="D2">
                                            <option></option>
                                        </select></td>
                                    <td >
                                        </td>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Font-Bold="False" ForeColor="#3366CC" 
                                            Text="Location"></asp:Label>
                                    </td>
                                    <td>
                                        <select id="ddlLocation2" name="D1">
                                            <option></option>
                                        </select></td>
                                </tr>
           
                                <tr>
                                    <td class="emptyrow" colspan="5">
                                         </td>
                                </tr>
           
                                <tr>
                                    <td align="center" colspan="5">
                            <input id="btnsearch2" type="button" class="button" value="Search" /></td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table id="tblDetails2" class="Scroll"  cellpadding="0" cellspacing="0" style="font-size: 8pt; top: 50px;"></table>
                            <div id="pager2" style="TEXT-ALIGN: center"></div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <input id="btnAdd2" type="button" class="button" value="Add to List" />
                        </td>
                    </tr>

                    </table>
                    </div>
                </fieldset>
            </div>
        </fieldset>
<br/>
<br/>
<br/>
<br/>
</asp:Content>
