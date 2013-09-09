<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeBehind="FirewallDetails.aspx.cs" Inherits="AssociateConnect.Web.FireWalls.FirewallDetails" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link rel="stylesheet" type="text/css" href="../../Styles/Site.css" />
    <link href="../../Styles/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.8.12.custom.css"   />
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.7.2.custom.css"   />
    
    
<script type="text/javascript">
//.......................................ProjectName populate in add section................................................
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
            //.......................................ProjectName populate in Search section................................................
            function populateProjectNameSearch() {
                $.ajax({
                    url: "../../Service/Associate.svc/Project/get",
                    success: AjaxSucceeded,
                    error: AjaxFailed
                });

                function AjaxSucceeded(result) {
                    bindDropDownProjectName('ddlProjectNameSearch', result);
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

            $(document).ready(function () {
                var flag = false;
                populateProjectName();
                populateProjectNameSearch();
                $('#successfull_addition').hide();
                //        <%if (!this.User.IsInRole("Admin") ) {%>
                //               $('#add').hide();
                //                $('#addfw').hide();
                //        <%} %>

                //------------------------------------------------------ CODA POPUP -------------------------------------------------------
                var popupshow = false;
                function popup() {
                    if (!popupshow) {
                        $('.bubbleInfo').each(function () {
                            // options    
                            var distance = 10;
                            var time = 50;
                            var hideDelay = 50;
                            var hideDelayTimer = null;
                            // tracker    
                            var beingShown = false;
                            var shown = false;
                            var trigger = $('.trigger', this);
                            var popup = $('.popup', this).css('opacity', 0);

                            // set the mouseover and mouseout on both element    
                            $([trigger.get(0), popup.get(0)]).mouseover(function () {
                                // stops the hide event if we move from the trigger to the popup element      
                                if (hideDelayTimer)
                                    clearTimeout(hideDelayTimer);
                                // don't trigger the animation again if we're being shown, or already visible      
                                if (beingShown || shown) {
                                    return;
                                }
                                else {
                                    beingShown = true;
                                    // reset position of popup box        
                                    popup.css({
                                        top: -50,
                                        left: -5,
                                        display: 'block'
                                        // brings the popup back in to view        
                                    })
                                    // (we're using chaining on the popup) now animate it's opacity and position        
        .animate({
            top: '-=' + distance + 'px',
            opacity: 1
        },
        time,
        'swing',
        function () {
            // once the animation is complete, set the tracker variables          
            beingShown = false;
            shown = true;
        });
                                }
                            }).mouseout(function () {
                                // reset the timer if we get fired again - avoids double animations      
                                if (hideDelayTimer) clearTimeout(hideDelayTimer);
                                // store the timer so that it can be cleared in the mouseover if required      
                                hideDelayTimer = setTimeout(function () {
                                    hideDelayTimer = null;
                                    popup.animate({
                                        top: '-=' + distance + 'px',
                                        opacity: 0
                                    },
                        time,
                        'swing',
                        function () {
                            // once the animate is complete, set the tracker variables          
                            shown = false;
                            // hide the popup entirely after the effect (opacity alone doesn't do the job)          
                            popup.css('display', 'none');
                        });
                                },
        hideDelay);
                            });

                        });
                        popupshow = true;
                    }
                }
                //------------------------------------------------------- slidetoggle update section --------------------------------------

                var i = 0;
                $("#dvtbladdnewfw").slideToggle("slow");

                $("#lgdAdd").click(function () {
                    ClearWarning();
                    $('#gridinstruction').hide();
                    $('#tblDetailsdiv').hide();
                    $("#dvtblsearchfw").slideToggle("slow");
                    $("#dvtbladdnewfw").slideToggle("slow");

                    if (i == 0) {
                        document.getElementById("imgminus").src = "../Images/plus2.jpg";
                        document.getElementById("imgplus").src = "../Images/minus2.jpg";
                        i = 1;

                    }
                    else {
                        document.getElementById("imgminus").src = "../Images/minus2.jpg";
                        document.getElementById("imgplus").src = "../Images/plus2.jpg";
                        i = 0;
                    }
                });
                //var k = 0;
                $("#lgdSearch").click(function () {
                    ClearWarning();
                    $('#gridinstruction').hide();
                    $('#tblDetailsdiv').hide();
                    $("#dvtblsearchfw").slideToggle("slow");
                    $("#dvtbladdnewfw").slideToggle("slow");

                    if (i == 0) {
                        document.getElementById("imgplus").src = "../Images/minus2.jpg";
                        document.getElementById("imgminus").src = "../Images/plus2.jpg";
                        i = 1;
                    }
                    else {
                        document.getElementById("imgminus").src = "../Images/minus2.jpg";
                        document.getElementById("imgplus").src = "../Images/plus2.jpg";
                        i = 0;
                    }
                });

                //------------------------------------------------------------------------------------
                var grid = false;
                var key;
                var firstsrch = true;
                var ret = false;
                var searchkey = new Object();
                //        var SearchUrl = '../../Service/Associate.svc/Software/search?page='+gdata.page+'&row='+gdata.rows+'&count=0',
                $('#btnDelete').hide();
                $('#gridinstruction').hide();
                $('#ShowGrid').hide();
                ClearWarning();
                function ClearWarning() {
                    $('.trigger').hide();
                    $('#warning').hide();
                    $('#successfull_addition').hide();
                    $('#search_warning').hide();
                    $('#<%=Label3.ClientID%>').removeClass("labelerror");
                    $('#<%=Label18.ClientID%>').removeClass("labelerror");
                    $('#<%=Label100.ClientID%>').removeClass("labelerror");
                    $('#<%=Label99.ClientID%>').removeClass("labelerror");
                    $('#<%=Label98.ClientID%>').removeClass("labelerror");

                    //---------------------------------------------------------------------------------------------------------------------
                    $('.trigger').hide();
                    $('#warning').hide();

                    //----------------------------------------------------- Live textbox ------------------------------------------------------
                    $('.textbox').focus(function () {
                        $(this).removeClass("textbox");
                        $(this).addClass("textboxhover");
                    });
                    $(".textbox").blur(function () {
                        $(this).removeClass("textboxhover");
                        $(this).addClass("textbox");

                    });

                    function validate() {
                        ret = true;
                        $('#warning').show();
                        ValidateProjectName();
                        valdestinationadd();
                        valPortno();
                        valSource();
                        valRequestdesc();

                    }
                    //-------------------------------------------------------- submit firewall -----------------------------------------------------------------
                    $("#btnSubmit").unbind('click').click(function () {
                        flag = true;
                        $('#successfull_addition').hide();
                        $('#search_warning').hide();
                        validate();
                        $(".Warning").empty();
                        if (ret) {
                            $('#warning').hide();
                            submit();
                        }

                    });
                    function submit() {
                        var obj2 = new Object();
                        obj2.ProjectID = parseInt($(":selected", $('#ddlProjectName')).val());
                        obj2.Destination = $("#txtdestinationadd").val();
                        obj2.Port = $("#txtPortno").val();
                        obj2.Source = $("#txtSourceIP").val();
                        obj2.FirewallRequestDesc = $("#txtrequestdesc").val();

                        $.ajax({
                            type: "PUT",
                            data: JSON.stringify(obj2),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            url: "../../Service/Associate.svc/Firewall/add",
                            complete: function (result) {
                                clear();
                                $('#successfull_addition').show();
                                $('.trigger').hide();
                                $("#tblDetails").trigger("reloadGrid");
                            }
                        });
                    }

                    function ValidateProjectName() {

                        var username_length;
                        username_length = $(":selected", $('#ddlProjectName')).text();
                        if (username_length == 0) {
                            $('#warning_project').show();
                            popup();
                            $('#warning').show();
                            $('#<%=Label18.ClientID%>').addClass("labelerror");
                            valname = false;
                        }
                        else {
                            $('#warning_project').hide();
                            $('#<%=Label18.ClientID%>').removeClass("labelerror");
                            $('#warning').hide();
                            valname = true;
                        }
                    }
                    function valdestinationadd() {
                        var length;
                        length = $("#txtdestinationadd").val().length;
                        if (length == 0) {
                            $('#warning').show();
                            $('#warning_destinationadd').show();
                            popup();
                            $('#<%=Label100.ClientID%>').addClass("labelerror");
                            ret = false;
                        }
                        else {
                            if (ret == true)
                                $('#warning').hide();
                            $('#warning_destinationadd').hide();
                            $('#<%=Label100.ClientID%>').removeClass("labelerror");
                        }
                    }

                    function valPortno() {
                        var length;
                        length = $("#txtPortno").val().length;
                        if (length == 0) {
                            $('#warning').show();
                            $('#warning_portno').show();
                            popup();
                            $('#<%=Label99.ClientID%>').addClass("labelerror");
                            ret = false;
                        }
                        else {
                            if (ret == true)
                                $('#warning').hide();
                            $('#warning_portno').hide();
                            $('#<%=Label99.ClientID%>').removeClass("labelerror");
                        }
                    }

                    function valSource() {
                        var length;
                        length = $("#txtSourceIP").val().length;
                        if (length == 0) {
                            $('#warning').show();
                            $('#warning_servername').show();
                            popup();
                            $('#<%=Label98.ClientID%>').addClass("labelerror");
                            ret = false;
                        }
                        else {
                            if (ret == true)
                                $('#warning').hide();
                            $('#warning_servername').hide();
                            $('#<%=Label98.ClientID%>').removeClass("labelerror");
                        }
                    }

                    function valRequestdesc() {
                        var length;
                        length = $("#txtrequestdesc").val().length;
                        if (length == 0) {
                            $('#warning').show();
                            $('#warning_requestdesc').show();
                            popup();
                            $('#<%=Label3.ClientID%>').addClass("labelerror");
                            ret = false;
                        }
                        else {
                            if (ret == true)
                                $('#warning').hide();
                            $('#warning_requestdesc').hide();
                            $('#<%=Label3.ClientID%>').removeClass("labelerror");
                        }
                    }

                    $("#txtdestinationadd").blur(function () {
                        if (flag)
                            valdestinationadd();
                    });
                    $("#txtPortno").blur(function () {
                        if (flag)
                            valPortno();
                    });
                    $("#txtSourceIP").blur(function () {
                        if (flag)
                            valSource();
                    });

                    $("#txtrequestdesc").blur(function () {
                        if (flag)
                            valRequestdesc();
                    });
                    $("#btnClear").click(clear);
                    function clear() {
                        flag = false;
                        $('#ddlProjectName').selectedIndex = 0;
                        document.getElementById("txtdestinationadd").value = '';
                        document.getElementById("txtPortno").value = '';
                        document.getElementById("txtSourceIP").value = '';
                        document.getElementById("txtrequestdesc").value = '';
                        document.getElementById("ddlProjectName").selectedIndex = 0;
                        $('#warning').hide();
                        $('.trigger').hide();
                        $('#successfull_addition').hide();
                        $('#<%=Label3.ClientID%>').removeClass("labelerror");
                        $('#<%=Label100.ClientID%>').removeClass("labelerror");
                        $('#<%=Label99.ClientID%>').removeClass("labelerror");
                        $('#<%=Label98.ClientID%>').removeClass("labelerror");
                        $('#<%=Label18.ClientID%>').removeClass("labelerror");
                    }

                    $("#btnSearch").click(function () {
                        validateSearch();
                        $(".Warning").empty();
                        $('#successfull_addition').hide();

                        if (ret) {
                            $('#gridinstruction').show();
                            $('#tblDetailsdiv').show();
                            var ProjectID = $(":selected", $('#ddlProjectNameSearch')).val();
                            searchkey.ProjectID = (ProjectID == '') ? 0 : parseInt(ProjectID);
                            searchkey.Destination = $('#txtdestinationaddSearch').val();
                            if (!grid) {
                                quickSearch();
                                grid = true;
                            }
                            else
                                $("#tblDetails").trigger("reloadGrid");
                        }
                        else
                            $("#tblDetails").clearGridData();
                    });
                    //            -------------------------------------search--------------------------
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

                    function quickSearch() {
                        var Project = new Object();
                        $.ajax({ url: "../../Service/Associate.svc/Project/get", async: false, success: function (data, result) { Project = data; } });
                        var pro = formatePro(Project);
                        $('#gridinstruction').show();
                        $('#search_warning').hide();

                        jQuery("#tblDetails").jqGrid({
                            datatype: function (gdata) {
                                $.ajax({
                                    url: '../../Service/Associate.svc/Firewall/search?page=' + gdata.page + '&row=' + gdata.rows + '&count=0',
                                    data: JSON.stringify(searchkey),
                                    type: "PUT",
                                    contentType: "application/json; charset=utf-8",
                                    complete: function (jsondata) {
                                        var g = jQuery("#tblDetails")[0];
                                        var data = JSON.parse(jsondata.responseText);
                                        var obj = new Object();
                                        obj.FirewallDetails = data.Items;
                                        obj.page = data.Page;
                                        obj.total = data.PageTotal;
                                        obj.records = data.ItemCount;
                                        g.addJSONData(obj);
                                    }
                                });
                            },
                            height: 'auto',
                            colNames: ['FirewallRequestID', 'Destination', 'Port', 'Source', 'ProjectID', 'ProjectName'],
                            colModel: [{ name: 'FirewallRequestID', index: 'FirewallRequestID', formatoptions: { text: 'verdana', size: '8', width: 100 }, hidden: true },
                           { name: 'Destination', index: 'Destination', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: true} },
                           { name: 'Port', index: 'Port', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: true} },
                           { name: 'Source', index: 'Source', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50 }, editrules: { required: true} },
                           { name: 'ProjectID', index: 'ProjectID', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, hidden: true, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                          { name: 'ProjectName', index: 'ProjectName', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: pro, size: 30, maxlength: 50 }, editrules: { required: true}}],
                            pager: jQuery('#pager'),
                            rowNum: 5,
                            rowList: [5, 10, 20, 50],
                            multiselect: false,
                            sortname: 'DestinationAdd',
                            sortorder: "asc",
                            width: 1180,
                            scrollOffset: 0,
                            viewrecords: true,
                            loadonce: false,
                            imgpath: "~/App_Themes/Default/images",
                            editurl: "../../Service/Associate.svc/Firewall/edit",
                            jsonReader: {
                                root: "FirewallDetails",
                                page: "page",
                                total: "total",
                                records: "records",
                                cell: "",
                                id: "FirewallRequestID",
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
                    }


                }  // quickSearch() ends..
                //---------------------------------------validation for search section---------------------------------------------       
                function validateSearch() {
                    ret = true;
                    $(".Warning").empty();
                    var Val = new Object();
                    Val.ProjectID = $(":selected", $('#ddlProjectNameSearch')).val();
                    Val.DestiantionID = $('#txtdestinationaddSearch').val();
                    if ((Val.ProjectID == '0') && (Val.DestiantionID == "")) {
                        $('#search_warning').show();
                        ret = false;
                    }
                }  // validateSearch() ends..

            });                                           // document.ready ends..
</script>
    <style type="text/css">
        #fade { /*--Transparent background layer--*/
	display: none; /*--hidden by default--*/
	background: #000;
	position: fixed; left: 0; top: 0;
	width: 100%; height: 100%;
	z-index: 9999;
}

        .style4
        {
            color: #FF0000;
            font-weight: 700;
        }
        .style10
        {
            width: 280px;
        }
        .style11
        {
            color: #FF0000;
            font-weight: 700;
            width: 7px;
        }
        .style13
        {
            width: 8px;
        }
        #txtVersion
        {
            width: 193px;
        }
        #ddlResourceCategory
        {
            width: 283px;
        }
        #ddlresourceItem
        {
            width: 283px;
        }
        #ddlVersion
        {
            width: 283px;
        }
        #txtProjectname
        {
        }
        
               
    .LowLight
    {
        background-color:#EEEEEE;
    }
    
    .HighLight
    {
        background-color:Ivory;
    }
        
        .style14
        {
            color: #FF0000;
        }
                
        .style15
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 98px;
        }
        .style16
        {
            width: 98px;
        }
                
        .style17
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 7px;
        }
        .style18
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 8px;
        }
                
        .style19
        {
        }
        .style20
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            }
        .style21
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 280px;
        }
                
        #ddlProjectNameSearch
        {
            width: 283px;
        }
                
        #ddlProjectName
        {
            width: 283px;
        }
                
        </style>
</asp:Content>

    <asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
        <br/>
        <img src="../Images/Heading/firewall.JPG" alt="Firewall" align="middle" style="padding-left:35px;" />
        <br/>
        <strong id="addfw">
        <em style="padding-left:120px;">Fields marked with <span class="style14">*</span> is mandatory.</em>
        </strong>
        <br />
        <div id="warning" style="padding-left:120px;" class="error">
            <span>Bring the mouse over </span>
            <img src="../Images/attention-icon.JPG" alt="warning" />
            <span>icon to see the warning(s).</span>
        </div>
        <div id="successfull_addition" style="padding-left:120px;">
        <span class="style4">
        <strong><em>Firewall addition successfull.</em></strong>
        </span>
        </div>
        <div id="search_warning" style="padding-left:120px;">
        <span><em style="color: #FF0000">
        You didnt selected any keyword to search.
        </em></span>
        </div>
        <asp:Panel ID="pnl" runat="server" style="padding-left:120px;" Visible="false">
         <asp:Label ID="Label15" runat="server" class="Warning"></asp:Label>
            <br/>
            <asp:Label ID="Label16" runat="server" class="Warning"></asp:Label>
            <br />
             <asp:Label ID="Label17" runat="server" class="Warning"></asp:Label>
            <br/>
            </asp:Panel>
        <div id="add">
        <fieldset id="fdstfirewall" class="fldset">
    <legend id="lgdAdd" class="legend"><img src="../Images/plus2.jpg" id="imgplus" alt=""/>Add new Firewall</legend>
        <div id="dvtbladdnewfw" align="center" >
        <table style="margin-bottom: 0px;" align="center">
           
        <tr>
            <td  style="padding-left:100px;" class="style19" align="right">
                <asp:Label ID="Label18" runat="server" CssClass="label" Text="Project Name"></asp:Label>
            </td>
            <td class="style10">
                <select  id= "ddlProjectName" class="ddl" tabindex="2" ></select></td>
            <td class="style11">
                *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_project" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Select your Project Name ! 
                    </div>
                        
                </div></td>
        </tr>
           
            <tr>
            <td class="style20" align="right" colspan="4">
                &nbsp;</td>
        </tr>
           
        <tr>
            <td  style="padding-left:100px;" class="style19" align="right">
                <asp:Label ID="Label100" runat="server"  CssClass="label" Text="Destination Address"></asp:Label>
                 </td>
            <td class="style10">
                <input id="txtdestinationadd" class="textbox" tabindex="1" type="text" /></td>
            <td class="style11">
                *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_destinationadd" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Enter Destination Address ! 
                    </div>
                        
                </div>
            </td>
        </tr>
        <tr>
            <td class="style20" align="right" colspan="4">
                &nbsp;</td>
        </tr>
        <tr>
            <td  style="padding-left:100px;" class="style19" align="right">
                 <asp:Label ID="Label99" runat="server"  CssClass="label" Text="Port No"></asp:Label>
            </td>
            <td class="style10">
                <input id="txtPortno" class="textbox" tabindex="2"/>

            </td>
            <td class="style11">
                *</td>
            <td>
                <div class="bubbleInfo">
                    <img id="warning_portno" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Enter Port No. ! 
                    </div>
                        
                </div>
            </td>
        </tr>
        <tr>
            <td class="style20" align="right" colspan="4">
                &nbsp;</td>
        </tr>
        <tr>
            <td style="padding-left:100px;"  class="style19" align="right">
                <asp:Label ID="Label98" runat="server" CssClass="label" Text="Source IP"></asp:Label>
            </td>
            <td class="style10">
                <input id="txtSourceIP" type="text" class="textbox" tabindex="3"/>
            </td>
            <td class="style11">
                *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_servername" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Enter ur Source IP! 
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="style20" align="right" colspan="4">
                &nbsp;</td>
        </tr>
        <tr>
            <td style="padding-left:100px;" class="style19" align="right">
                <asp:Label ID="Label3" runat="server" CssClass="label" Text="FirewallRequest Desc"></asp:Label></td>
            <td class="style10">
                <input id="txtrequestdesc" type="text" class="textbox" tabindex="4"/></td>
            <td class="style11">
                *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_requestdesc" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Please enter the firewall request descripton! 
                    </div>
                </div></td>
        </tr>
        <tr>
            <td class="style19" align="right" colspan="4">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style19" align="right">
                &nbsp;</td>
            <td  align="right" colspan="3">
               <input type="button" id="btnSubmit" value="Submit" 
                    class="button"
                    tabindex="4"  />

                     <input type="button" id="btnClear" value="Clear" style="margin-left:50px;" 
                    class="button"
                    tabindex="4"  /></td>
        </tr>
        <tr>
            <td style="padding-left:100px;" class="style19" colspan="4">
                &nbsp;
               <asp:Label ID="lblMsgadd" runat="server" Font-Size="Medium" ForeColor="Red" Font-Bold="False" Font-Italic="True" ></asp:Label>
            </td>
        </tr>
    </table>
    </div>
    </fieldset>
    <br />
    <br />
    <br />
    </div>
        <fieldset class="fldset">
    <legend id="lgdSearch" class="legend"><img src="../Images/minus2.jpg" id="imgminus" alt=""/> Search Firewall</legend>
    <div id="dvtblsearchfw" align="center" >
    <table style="margin-bottom: 0px;" align="center">
            <tr>
            <td class="style19" align="right">
                
                 <asp:Label ID="Label2" runat="server" CssClass="label" 
                     Text="ProjectName"></asp:Label></td>
            <td class="style10">
                <select  id= "ddlProjectNameSearch" class="ddl" tabindex="1" ></select></td>
        </tr>
        <tr>
            <td class="style20" align="right" colspan="2">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style19" align="right">
                 <asp:Label ID="Label1" runat="server" CssClass="label" 
                     Text="Destination Address"></asp:Label>
            </td>
            <td class="style10">
                <input id="txtdestinationaddSearch" class="textbox" tabindex="1" type="text" /></td>
        </tr>
        <tr>
            <td class="style19" align="right" colspan="2">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style19" align="right">
                </td>
            <td  align="right">
               <input type="button" id="btnSearch" value="Search" 
                    class="button"
                    tabindex="4"  /></td>
        </tr>
        <tr>
            <td class="style19" colspan="2">
                
               <asp:Label ID="Label4" runat="server" Font-Size="Medium" ForeColor="Red" Font-Bold="False" Font-Italic="True" ></asp:Label>
                
            </td>
        </tr>
        </table>
        </div>
        
    </fieldset>
        <br />
    <span id="gridinstruction">
    <strong><em style="padding-left:120px;">Select any row for updating the record.</em></strong>
    </span>
    <br/>
    <br/>
    
    <div id="tblDetailsdiv" style="font-size: 8pt;" align="center">
    <table id="tblDetails" class="scroll"  cellpadding="0" cellspacing="0" style="font-size: 8pt;
      top: 50px;">
    </table>
    <div id="pager" style="TEXT-ALIGN: center"></div>
  </div>
        <br />
        <br />
        <br />
        <p align="center">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </p>
        <br />
</asp:Content>
