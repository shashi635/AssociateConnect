<%@ Page Title="" Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeFile="SoftwareDetails.aspx.cs" Inherits="SoftwareDetails" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link rel="stylesheet" type="text/css" href="../../Styles/Site.css" />
    <link href="../../Styles/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.7.2.custom.css"   />
    
    <script type="text/javascript">

        $(document).ready(function () {
            var flag = false;
            reset();
            populateProjectName();
            RC();
            RCS();
            populateProjectNameSearch();
            function reset() {
                flag = false;
                ClearWarning();
                $('#ddlProjectName').empty();
                $('#ddlResourceCategory').empty();
                $('#ddlresourceItem').empty();
                $('#ddlVersion').empty();
                populateProjectName();
                RC();
                category = false;
            }
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
            //---------------------------------------------------------- Ready function ----------------------------------------------------
            var grid = false;
            var categoryindex;
            var itemindex;
            var versionindex;
            var y = 0;
            var key = new Object();
            var searchkey = new Object();
            $("#dvtbladdnewsw").slideToggle(.1);
            $('.trigger').hide();
            $('#warning').hide();
            $('#gridinstruction').hide();
            var valname = false;
            var valcategory = false;
            var valitem = false;
            var valversion = false;
            function ClearWarning() {
                $('.trigger').hide();
                $('#warning').hide();
                $('#successfull_addition').hide();
                $('#search_warning').hide();
                $('#Label16').removeClass("labelerror");
                $('#Label1').removeClass("labelerror");
                $('#Label22').removeClass("labelerror");
                $('#Label24').removeClass("labelerror");
            }
            //------------------------------------------------------- slidetoggle update section --------------------------------------

            var i = 0;
            $("#lgdAdd").click(function () {
                ClearWarning();
                $('#gridinstruction').hide();
                $('#tblDetailsdiv').hide();
                $("#dvtbladdnewsw").slideToggle("slow");
                $("#dvtblsearchsw").slideToggle("slow");

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
                $("#dvtblsearchsw").slideToggle("slow");
                $("#dvtbladdnewsw").slideToggle("slow");

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
            //----------------------------------------------------- Live textbox ------------------------------------------------------
            $('.textbox').focus(function () {
                $(this).removeClass("textbox");
                $(this).addClass("textboxhover");
            });

            $(".textbox").blur(function () {
                $(this).removeClass("textboxhover");
                $(this).addClass("textbox");
            });


            //........................Fill Resource Category in add section...........................................
            function RC() {
                $.ajax({
                    url: "../../Service/Associate.svc/softcategory/get",
                    success: AjaxSucceeded0,
                    error: AjaxFailed
                });

                function AjaxSucceeded0(result) {
                    bindDropDownResourceCategory('ddlResourceCategory', result);
                }

                function AjaxFailed(result) { }

                function bindDropDownResourceCategory(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].SoftwareCategoryID + "'>" + data[k].SoftwareCategoryDesc + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }

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
                    bindDropDownProjectNameSearch('ddlProjectNameSearch', result);
                }

                function AjaxFailed(result) { }

                function bindDropDownProjectNameSearch(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].ProjectID + "'>" + data[k].ProjectName + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }

            //-----------------------------------------Fill Resource Category in search section---------------------------------

            function RCS() {
                $.ajax({
                    url: "../../Service/Associate.svc/softcategory/get",
                    success: AjaxSucceeded00,
                    error: AjaxFailed00
                });

                function AjaxSucceeded00(result) {
                    bindDropDownResourceCategory('ddlResourceCategorySearch', result);
                }

                function AjaxFailed00(result) { }

                function bindDropDownResourceCategory(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");

                    var options = "<option value=0></option>";
                    for (k = 0; k < (data.length); k++) {
                        options += "<option value='" + data[k].SoftwareCategoryID + "'>" + data[k].SoftwareCategoryDesc + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            //...................................Fill Resource Item in add section.............................
            function RI(ResourceCategory) {
                $.ajax({
                    url: "../../Service/Associate.svc/softResource/" + ResourceCategory + "/getDetails",
                    type: "GET",
                    success: AjaxSucceeded1,
                    error: AjaxFailed1
                });
                function AjaxSucceeded1(result) {
                    bindDropDownResourceItem('ddlresourceItem', result);
                }

                function AjaxFailed1(result) {
                }

                function bindDropDownResourceItem(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");

                    var options = "<option value=0></option>";
                    for (k = 0; k < data.length; k++) {
                        options += "<option value='" + data[k].SoftwareResourceID + "'>" + data[k].SoftwareResourceDesc + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            // ...................................Fill Resource Item in search section.............................................
            function RIS(ResourceCategory) {
                $.ajax({
                    url: "../../Service/Associate.svc/softResource/" + ResourceCategory + "/getDetails",
                    type: "GET",
                    success: AjaxSucceeded1,
                    error: AjaxFailed1
                });
                function AjaxSucceeded1(result) {
                    bindDropDownResourceItem('ddlresourceItemSearch', result);
                }

                function AjaxFailed1(result) {
                }

                function bindDropDownResourceItem(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");

                    var options = "<option value=0></option>";
                    for (k = 0; k < data.length; k++) {
                        options += "<option value='" + data[k].SoftwareResourceID + "'>" + data[k].SoftwareResourceDesc + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            //.............................................fill version in add section................................
            function RV(ResourceName) {
                $.ajax({
                    url: "../../Service/Associate.svc/softVersion/" + ResourceName + "/getDetails",
                    type: "GET",
                    success: AjaxSucceeded1,
                    error: AjaxFailed1
                });
                function AjaxSucceeded1(result) {
                    bindDropDownVersion('ddlVersion', result);
                }
                function AjaxFailed1(result) {
                }
                function bindDropDownVersion(cntrl, data) {
                    var targetCntrl = $("#" + cntrl + "");
                    var options = "<option value=0></option>";
                    for (k = 0; k < data.length; k++) {
                        options += "<option value='" + data[k].SoftwareVersionID + "'>" + data[k].SoftwareVersionDesc + "</option>";
                    }
                    targetCntrl.empty().append(options);
                }
            }
            // .............................................ResourceItem Populate after select Resource Category --------------------------

            $('#ddlResourceCategory').change(function () {
                var ResourceCategoryID = $(":selected", $('#ddlResourceCategory')).val();
                if (ResourceCategoryID == "0")
                    $('#ddlresourceItem').empty();
                else
                    RI(ResourceCategoryID);

            });
            // .............................................ResourceItem Populate after select Resource Category in Search  Section--------------------------

            $('#ddlResourceCategorySearch').change(function () {
                var ResourceCategoryID = $(":selected", $('#ddlResourceCategorySearch')).val();
                if (ResourceCategoryID == "0")
                    $('#ddlresourceItemSearch').empty();
                else
                RIS(ResourceCategoryID);
            });
            // ............................................. Version Populate after select Resource Item -----------------

            $('#ddlresourceItem').change(function () {
                var ResourceName = $(":selected", $('#ddlresourceItem')).text();
                if (ResourceName == "")
                    $('#ddlVersion').empty();
                else {
                    var ResourceID = $(":selected", $('#ddlresourceItem')).val();
                    RV(ResourceID);
                }
            });

            //........................................................ submit button .............................................

            $("#btnSubmit").click(function () {
            debugger;
                flag = true;
                $('#successfull_addition').hide();
                $('#search_warning').hide();
                validate();
                if (valname & valcategory & valitem & valversion) {
                    $('#warning').hide();
                    var obj2 = new Object();
                    obj2.ProjectID = parseInt($(":selected", $('#ddlProjectName')).val());
                    obj2.SoftCategoryID = parseInt($(":selected", $('#ddlResourceCategory')).val());
                    obj2.SoftResourceID = parseInt($(":selected", $('#ddlresourceItem')).val());
                    obj2.SoftVersionID = parseInt($(":selected", $('#ddlVersion')).val());
                    $.ajax({
                        type: "PUT",
                        data: JSON.stringify(obj2),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "../../Service/Associate.svc/Software/add",
                        success: function (result) {
                            reset();
                            $('#successfull_addition').show();
                            $('.trigger').hide();
                        },
                        error: function (result) {
                        }
                    });
                }
            });

            function validate() {
                ClearWarning();
                ValidateProjectName();
                if (valname)
                    ValidateResourceCategory();
                if (valname & valcategory)
                    ValidateResourceItem();
                if (valname & valcategory & valitem)
                    ValidateVersion();

            }

            $('#btnClear').click(reset);

            var category = false;
            function ValidateProjectName() {

                var username_length;
                username_length = $(":selected", $('#ddlProjectName')).text();
                if (username_length == 0) {
                    $('#warning_name').show();
                    popup();
                    $('#warning').show();
                    $('#Label16').addClass("labelerror");
                    valname = false;
                }
                else {
                    $('#warning_name').hide();
                    $('#Label16').removeClass("labelerror");
                    $('#warning').hide();
                    valname = true;
                }
            }
            function ValidateResourceCategory() {
                var Validate = new Object();
                Validate.ResourceCategory = $(":selected", $('#ddlResourceCategory')).text();
                if (Validate.ResourceCategory == "" || Validate.ResourceCategory == "select") {
                    $('#warning_category').show();
                    popup();
                    $('#Label1').addClass("labelerror");
                    $('#warning').show();
                    valcategory = false;
                }
                else {
                    $('#warning_category').hide();
                    $('#warning').hide();
                    $('#Label1').removeClass("labelerror");
                    valcategory = true;
                }
            }
            function ValidateResourceItem() {
                var Validate = new Object();
                Validate.ResourceItem = $(":selected", $('#ddlresourceItem')).text();
                if (Validate.ResourceItem == "" || Validate.ResourceItem == "select") {
                    $('#warning_item').show();
                    popup();
                    $('#Label22').addClass("labelerror");
                    $('#warning').show();
                    valitem = false;
                }
                else {
                    $('#warning_item').hide();
                    $('#Label22').removeClass("labelerror");
                    $('#warning').hide();
                    valitem = true;
                }
            }
            function ValidateVersion() {
                var Validate = new Object();
                Validate.Version = $(":selected", $('#ddlVersion')).text();
                if (Validate.Version == "" || Validate.Version == "select") {
                    $('#warning_version').show();
                    popup();
                    $('#Label24').addClass("labelerror");
                    $('#warning').show();
                    valversion = false;
                }
                else {
                    $('#warning_version').hide();
                    $('#Label24').removeClass("labelerror");
                    $('#warning').hide();
                    valversion = true;
                }
            }

            $("#ddlProjectName.Client").blur(function () {
                if (flag)
                    ValidateProjectName();
            });
            $("#ddlResourceCategory").blur(function () {
                if (flag) {
                    ValidateProjectName();
                    if (valname)
                        ValidateResourceCategory();
                }

            });
            $("#ddlresourceItem").blur(function () {
                if (flag) {
                    ValidateProjectName();
                    if (valname)
                        ValidateResourceCategory();
                    if (valname & valcategory)
                        ValidateResourceItem();
                }
            });
            $("#ddlVersion").blur(function () {
                if (flag) {
                    ValidateProjectName();
                    if (valname)
                        ValidateResourceCategory();
                    if (valname & valcategory)
                        ValidateResourceItem();
                    if (valname & valcategory & valitem)
                        ValidateVersion();
                }
            });

            $("#btnSearch").click(function () {
                validateSearch();
                $(".Warning").empty();
                $('#successfull_addition').hide();

                if (ret) {
                    $('#gridinstruction').show();
                    $('#tblDetailsdiv').show();
                    var ProjectID = $(":selected", $('#ddlProjectNameSearch')).val();
                    searchkey.ProjectID = (ProjectID == '') ? 0 : parseInt(ProjectID);
                    var SoftCategoryID = $(":selected", $('#ddlResourceCategorySearch')).val();
                    searchkey.SoftCategoryID = (SoftCategoryID == '') ? 0 : parseInt(SoftCategoryID);
                    if (searchkey.SoftCategoryID != 0) {
                        var SoftResourceID = $(":selected", $('#ddlresourceItemSearch')).val();
                        searchkey.SoftResourceID = (SoftResourceID == '') ? 0 : parseInt(SoftResourceID);
                    }
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

            function formateCat(data) {
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].SoftwareCategoryID + ":" + data[k].SoftwareCategoryDesc + " ";
                    else
                        rdata += "; " + data[k].SoftwareCategoryID + ":" + data[k].SoftwareCategoryDesc + " ";
                }
                return rdata;
            }

            function formateRes(data) {
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].SoftwareResourceID + ":" + data[k].SoftwareResourceDesc + " ";
                    else
                        rdata += "; " + data[k].SoftwareResourceID + ":" + data[k].SoftwareResourceDesc + " ";
                }
                return rdata;
            }

            function formateVer(data) {
                var rdata;
                for (k = 0; k < (data.length); k++) {
                    if (k == 0)
                        rdata = data[k].SoftwareVersionID + ":" + data[k].SoftwareVersionDesc + " ";
                    else
                        rdata += "; " + data[k].SoftwareVersionID + ":" + data[k].SoftwareVersionDesc + " ";
                }
                return rdata;
            }

            function quickSearch() {
                var Project = new Object();
                var Category = new Object();
                var Item = new Object();
                var Version = new Object();
                $.ajax({ url: "../../Service/Associate.svc/Project/get", async: false, success: function (data, result) { Project = data; } });
                $.ajax({ url: "../../Service/Associate.svc/softcategory/get", async: false, success: function (data, result) { Category = data } });
                $.ajax({ url: "../../Service/Associate.svc/softResource/0/getDetails", async: false, success: function (data, result) { Item = data } });
                $.ajax({ url: "../../Service/Associate.svc/softVersion/0/getDetails", async: false, success: function (data, result) { Version = data } });
                var pro = formatePro(Project);
                var cat = formateCat(Category);
                var item = formateRes(Item);
                var ver = formateVer(Version);
                $('#gridinstruction').show();
                $('#search_warning').hide();

                jQuery("#tblDetails").jqGrid({
                    datatype: function (gdata) {
                        $.ajax({
                            url: '../../Service/Associate.svc/Software/search?page=' + gdata.page + '&row=' + gdata.rows + '&count=0',
                            data: JSON.stringify(searchkey),
                            type: "PUT",
                            contentType: "application/json; charset=utf-8",
                            complete: function (jsondata) {
                                var g = jQuery("#tblDetails")[0];
                                var data = JSON.parse(jsondata.responseText);
                                var obj = new Object();
                                obj.SoftwareDetails = data.Items;
                                obj.page = data.Page;
                                obj.total = data.PageTotal;
                                obj.records = data.ItemCount;
                                g.addJSONData(obj);
                            }
                        });
                    },
                    colNames: ['SoftRequestID', 'ProjectName', 'SoftCategory', 'SoftResource', 'SoftVersion'],    //'Category', 'Notes', 'Sub Category', 'User Name', 'Last Edited', 'Last Edited By', '', ''],
                    colModel: [{ name: 'SoftRequestID', index: 'SoftRequestID', formatoptions: { text: 'verdana', size: '8', width: 100 }, hidden: true, sortable: true },
                                    { name: 'ProjectName', index: 'ProjectName', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: pro, size: 30, maxlength: 50 }, editrules: { required: true} },
                                    { name: 'SoftCategory', index: 'SoftCategory', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: cat, size: 30, maxlength: 50 }, editrules: { required: true} },
                                    { name: 'SoftResource', index: 'SoftResource', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: item, size: 30, maxlength: 50 }, editrules: { required: true} },
                                    { name: 'SoftVersion', index: 'SoftVersion', formatoptions: { text: 'verdana', size: '8', width: 100 }, sortable: true, editable: true, edittype: 'select', editoptions: { value: ver, size: 30, maxlength: 50 }, editrules: { required: true}}],
                    rowNum: 5,
                    rowList: [5, 10, 20, 50],
                    multiselect: false,
                    pager: jQuery("#pager"),
                    height: 'auto',
                    width: 1180,
                    scrollOffset: 0,
                    sortname: 'SoftRequestID',
                    sortorder: "asc",
                    viewrecords: true,
                    loadonce: false,
                    imgpath: "~/App_Themes/Default/images",
                    editurl: "../../Service/Associate.svc/Software/edit",
                    jsonReader: {
                        root: "SoftwareDetails",
                        page: "page",
                        total: "total",
                        records: "records",
                        cell: "",
                        id: "SoftRequestID",
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
            //---------------------------------------validation for search section---------------------------------------------       
            function validateSearch() {
                ret = true;
                $(".Warning").empty();
                var Val = new Object();
                Val.ProjectName = $(":selected", $('#ddlProjectNameSearch')).text();
                Val.ResourceCategory = $(":selected", $('#ddlResourceCategorySearch')).text();
                Val.ResourceItem = $(":selected", $('#ddlresourceItemSearch')).text();
                if ((Val.ResourceCategory == "") && (Val.ProjectName == "") && (Val.ResourceItem == "")) {
                    $('#search_warning').show();
                    ret = false;
                }
            }  // validateSearch() ends..
        });
        
    </script>
  
    <style type="text/css">
        .style4
        {
            color: #FF0000;
            font-weight: 700;
            width:100px;
        }
        .style10
        {
            width: 288px;
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
        #ddlResourceCategoryUpdate
        {
            width: 284px;
        }
        #ddlresourceItemUpdate
        {
            width: 282px;
        }
        #ddlVersionUpdate
        {
            width: 283px;
        }
        .style15
        {
            color: #FF0000;
            font-weight: 700;
            width: 6px;
        }
        .style9
        {
            color: #FF0000;
        }
        #ddlCategoryUpdate
        {
            width: 283px;
        }
        #ddlItemUpdate
        {
            width: 283px;
        }
        #txtProjectnameUpdate
        {
            width: 280px;
        }
        #warning_version
        {
            height: 13px;
        }
        #ddlResourceCategorySearch
        {
            width: 283px;
        }
        #ddlresourceItemSearch
        {
            width: 283px;
        }
        #search_warning
        {
            color: #FF0000;
        }
        #Select1
        {
            width: 283px;
        }
        #ddlProjectName
        {
            width: 283px;
        }
        #ddlProjectNameSearch
        {
            width: 283px;
        }
        </style>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>
    <img src="../Images/Heading/Software.JPG" alt="Software" style="padding-left:35px;"/>
        <br/>
    <strong id="addsw">
        <em style="padding-left:120px;">Fields marked with <span class="style9">*</span> is mandatory.</em></strong>    
     <br />
     <div id="warning" style="padding-left:120px;" class="error">
            <span>Bring the mouse over </span>
            <img src="../Images/attention-icon.JPG" alt="warning" />
            <span>icon to see the warning(s).</span>
        </div>
       <div id="successfull_addition" style="padding-left:120px;">
        <span class="style4">
        <strong><em>Software has been addded successfully.</em></strong>
        </span>
        </div>
        <div id="search_warning" style="padding-left:120px;">
        <span><em>
        You didnt selected any keyword to search.
        </em></span>
        </div>
      <div id="add">
    <fieldset id="fdstadd" class="fldset">
    <legend id="lgdAdd" class="legend"><img src="../Images/plus2.jpg" id="imgplus" alt=""/>Add new Software</legend>
    <div id="dvtbladdnewsw" align="center" >
    <table style="margin-bottom: 0px;">
        <tr>
            <td style="padding-left:100px;"   align="right">
                <label id="Label16" class="label">Project Name</label>
                </td>
            <td class="style10">
                        
  
           <select  id= "ddlProjectName" class="ddl" tabindex="2" ></select></td>
            <td class="style15">
                *</td>
            <td>
                <div class="bubbleInfo">
                    <img id="warning_name" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Enter Project name ! 
                    </div>
                </div>
               
            </td>
        </tr>
        <tr>
            <td class="emptyrow" colspan="4">
                </td>
        </tr>
        <tr>
            <td style="padding-left:100px;"    align="right">
                 <label id="Label1" class="label" >Resource Category</label>
                 </td>
            <td class="style10">
               <select  id= "ddlResourceCategory" class="ddl" tabindex="2" ></select></td>
            <td class="style15">
               *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_category" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Select Resource Category ! 
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="emptyrow" align="right" colspan="4">
                <span id="resourcecategory_warning" style="color:red"></span></td>
        </tr>
        <tr>
            <td  style="padding-left:100px;"    align="right">
                <label id="Label22" class="label" >Resource Item</label>
            </td>
            <td class="style10">
            <select  id= "ddlresourceItem" class="ddl" tabindex="3" ></select></td>
            <td class="style15">
               *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_item" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" />
                    <div class="popup">
                        Select Resource Item !
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="emptyrow" align="right" colspan="4">
                <span id="resourceitem_warning" style="color:red"></span>  </td>
        </tr>
        <tr>
            <td  style="padding-left:100px;"   align="right">
                <label id="Label24" class="label" >Version</label>
            </td>
            <td class="style10">
               <select  id= "ddlVersion" tabindex="4"></select></td>
            <td class="style15">
                *</td>
            <td >
                <div class="bubbleInfo">
                    <img id="warning_version" alt="warning" class="trigger" 
                        src="../Images/attention-icon.JPG" onclick="return warning_version_onclick()" />
                    <div class="popup">
                         Enter Version !
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td   align="right" colspan="4">
                <span id="version_warning" style="color:red"></span>  </td>
        </tr>
        <tr>
            <td   align="right">
                 </td>
            <td align="right" colspan="3">
               <input type="button" id="btnSubmit" value="Add" class="button" tabindex="5"  />
                <input id="btnClear" type="button" class="button" value="Clear" style="margin-left:50px;" />
            </td>
        </tr>
        <tr>
            <td style="padding-left:100px;"   colspan="4">
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
    <legend id="lgdSearch" class="legend"><img src="../Images/minus2.jpg" id="imgminus" alt=""/> Search Software</legend>
    <div id="dvtblsearchsw" align="center" >
    <table style="margin-bottom: 0px;">
            <tr>
                <td   align="right">
                    <asp:Label ID="Label3" runat="server" CssClass="label" Text="Project Name"></asp:Label></td>
                <td class="style10">
                        

                    <select  id= "ddlProjectNameSearch" class="ddl" tabindex="1" ></select></td>
            </tr>
            <tr>
            <td class="emptyrow" align="right" colspan="2">
                <span id="Span1" style="color:red"></span> </td>
            </tr>
            <tr>
                <td   align="right">
                    <asp:Label ID="Label2" runat="server" CssClass="label" Text="Resource Category"></asp:Label>
                    </td>
                <td class="style10">
                        

               <select  id= "ddlResourceCategorySearch" class="ddl" tabindex="1" ></select></td>
            </tr>
            <tr>
            <td class="emptyrow" align="right" colspan="2">
                <span id="Span5" style="color:red"></span>  </td>
            </tr>
            <tr>
                <td   align="right">
                    <asp:Label ID="Label8" runat="server" CssClass="label" Text="Resource Item"></asp:Label> </td>
                <td class="style10">
                        
                    <select  id= "ddlresourceItemSearch" name ="ddlresourceItem" tabindex="2" ></select></td>
            </tr>
            <tr>
                <td   align="right" colspan="2">
                     </td>
            </tr>
            <tr>
                <td   align="right">
                     </td>
                <td  align="right">
                        
                    <input id="btnSearch" class="button" type="button" value="Search"  /></td>
            </tr>
        </table>
        </div>
        
    </fieldset>
    <br />
    <br />
    <span id="gridinstruction">
    <strong><em style="padding-left:120px;">Select any row for updating the record.</em></strong>
    </span>
    <br/>
    <br/>
    <div id="tblDetailsdiv" style="font-size: 8pt;" align="center">
    <table id="tblDetails"  cellpadding="0" cellspacing="0" style="font-size: 8pt;
      top: 50px;">
    </table>
    <div id="pager" style="TEXT-ALIGN: center"></div>
  </div>
    <br />
    <br />
    <br />
     
    <br />
       
</asp:Content>
