<%@ Page Language="C#" MasterPageFile="~/Associate.master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Category" EnableViewState="false" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link type="text/css" rel="stylesheet" href="../../App_Themes/default/jquery-ui-1.7.2.custom.css"   />
    <link href="../../App_Themes/Default/jquery.ui.all.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" src="../../Scripts/ui/ui.core.js"></script>
    <script src="../../Scripts/ui/ui.widget.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/ui.mouse.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/ui.draggable.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/ui.position.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/ui.resizable.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/ui.dialog.js" type="text/javascript"></script>
    <script src="../../Scripts/ui/effects.core.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/ui/effects.highlight.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {
            var searchkey = new Object();
            searchkey.CategoryID = 0;
            searchkey.CategoryDesc = "";
            searchkey.IsActive = 0;
            SearchCategory();
            //--------------------------------------------------------------------------------------------------------------------------------//
            function updateTips(t) {
                $("#validateTips").text(t).effect("highlight", {}, 1500);
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function checkLength(o, n, min, max) {

                if (o.val().length > max || o.val().length < min) {
                    //o.addClass('ui-state-error');
                    //o.attr("style", "color:red;");
                    updateTips("Length of " + n + " must be between " + min + " and " + max + ".");
                    return false;
                } else {
                    return true;
                }

            }

            //--------------------------------------------------------------------------------------------------------------------------------//
            $("#dialog").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 230,
                modal: true,
                buttons: {
                    'Create': function () {
                        var bValid = true;
                        bValid = bValid && checkLength($('#txtCategoryName'), "Category", 3, 16);
                        if (bValid) {
                            createCategory($('#txtCategoryName').val());
                            $(this).dialog('close');
                        }
                    },
                    Cancel: function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    $('#txtCategoryName').val("").removeClass('ui-state-error'); ;
                    $("#validateTips").val("");
                }
            });



            $('#btnCreate').click(function () {
                $('#dialog').dialog('open');
            });
            //--------------------------------------------------------------------------------------------------------------------------------//
            function createCategory(CategoryDesc) {
                var obj = new Object();
                obj.CategoryDesc = CategoryDesc;
                obj.IsActive = parseInt("1");

                $.ajax({
                    url: "../../Service/Associate.svc/category/add",
                    data: JSON.stringify(obj),
                    type: "PUT",
                    contentType: "application/json; charset=utf-8",
                    success: fun_success,
                    error: fun_err
                });
                function fun_success(result) {
                    if (result == "success") {
                        $("#tblCategory").trigger("reloadGrid");
                    }
                }
                function fun_err(result) {
                }
            }
            //--------------------------------------------------------------------------------------------------------------------------------//
            function SearchCategory() {
                jQuery("#tblCategory").jqGrid({
                    datatype: function (gdata) {
                        $.ajax({
                            url: '../../Service/Associate.svc/category/search?page=' + gdata.page + '&row=' + gdata.rows + '&count=0',
                            data: JSON.stringify(searchkey),
                            type: "PUT",
                            contentType: "application/json; charset=utf-8",
                            complete: function (jsondata) {
                                var g = jQuery("#tblCategory")[0];
                                var data = JSON.parse(jsondata.responseText);
                                var obj = new Object();
                                obj.CategoryDetails = data.Items;
                                obj.page = data.Page;
                                obj.total = data.PageTotal;
                                obj.records = data.ItemCount;
                                g.addJSONData(obj);
                            }
                        });
                    },
                    colNames: ['CategoryID', 'Category Name', 'IsActive'],
                    colModel: [{ name: 'CategoryID', index: 'CategoryID', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'CategoryDesc', index: 'CategoryDesc', formatoptions: { text: 'verdana', size: '8', width: 100 }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50} },
                               { name: 'IsActive', index: 'IsActive', formatoptions: { text: 'verdana', size: '8' }, editable: true, edittype: 'text', editoptions: { size: 30, maxlength: 50}}],
                    rowNum: 10,
                    pager: jQuery("#pager"),
                    height: 'auto',
                    width: 800,
                    imgpath: "~/App_Themes/Default/images",
                    scrollOffset: 0,
                    editurl: "../../Service/Associate.svc/category/edit",
                    deleteurl: "../../Service/Associate.svc/category/delete",
                    sortname: 'CategoryID',
                    sortorder: "asc",
                    viewrecords: true,
                    jsonReader: {
                        root: "CategoryDetails",
                        page: "page",
                        total: "total",
                        records: "records",
                        cell: "",
                        id: "CategoryID",
                        repeatitems: false
                    }

                });
                jQuery("#tblCategory").jqGrid('navGrid', '#pager', { view: true, add: false, search: false, edit: true, del: true, reload: true }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { jqModal: true, checkOnUpdate: true, savekey: [true, 13], navkeys: [true, 38, 40], checkOnSubmit: true, reloadAfterSubmit: false, closeOnEscape: true }, { reloadAfterSubmit: false, jqModal: false, closeOnEscape: true }, { closeOnEscape: true }, { navkeys: [true, 38, 40], height: 250, jqModal: false, closeOnEscape: true });
            }  // quickSearch() ends..
            //--------------------------------------------------------------------------------------------------------------------------------//
            $('#btnSearch').click(function () {
                searchkey.CategoryID = ($("#txtCategoryID").val() == '') ? 0 : parseInt($("#txtCategoryID").val());
                searchkey.CategoryDesc = $("#txtCategoryDesc").val();
                if ($("#chkIsActive")[0].checked == true)
                    searchkey.IsActive = 1;
                else
                    searchkey.IsActive = 0;
                $("#tblCategory").trigger("reloadGrid");
            });
        });
    </script>

    <style type="text/css">
    </style>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>
        <img src="../Images/Heading/Category.JPG" alt="Category" style="padding-left:35px;" />
        <br/>
        <div id="dvStatus" style="margin-left:120px;">
            <label id="lblStatus" ></label>
        </div>
        <br/>
        <label style="color:#9E9D81;padding:0px 0px 0px 120px"><strong>Please select group and write the message.</strong></label>
        <br/>
    <br />
        <fieldset id="fsSendMessage" class="fldset">
            <legend id="lgdSendMessage" class="legend">Manage Category..</legend>
            <div id="dvmem2">
                    
                            <table style="margin-bottom: 0px;" align="center">
                                <tr>
                                    <td colspan="6">
                                        <input id="btnCreate" class="button" style="width:180px" type="button" value="Create New Category" /></td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                       </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label id="Label1"  class="label" >CartegoryID</label>
                                    </td>
                                    <td>
                                        <input id="txtCategoryID" class="textboxmember" type="text" /></td>
                                    <td style="padding-left:30px">
                                        <label id="Label2"  class="label" >Category</label>
                                    </td>
                                    <td >
                                        <input id="txtCategoryDesc" class="textboxmember" type="text" /></td>
                                    <td style="padding-left:30px">
                                        <input id="chkIsActive" type="checkbox" title="title" /><label id="Label3" class="label">IsActive</label>
                                    </td>
                                    <td style="padding-left:30px">
                                        <input id="btnSearch" type="button" class="button" value="Search" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" align = "center" style="padding-top:50px">
                                        <table id="tblCategory" class="Scroll" cellpadding="0" cellspacing="0" style="width:1000px;font-size: 8pt; top: 50px;"></table>
                                        <div id="pager" style="TEXT-ALIGN: center"></div>
                                    </td>
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
<div id="dialog" title="Create new category">
	<p id="validateTips">All form fields are required.</p>

	<fieldset style="padding:0; border:0; margin-top:25px;">
		<label for="name">Category Name</label>
		<input type="text" name="name" id="txtCategoryName" class="text ui-widget-content ui-corner-all" style="margin-bottom:12px; width:95%; padding: .4em;"/>
	</fieldset>
</div>
</asp:Content>