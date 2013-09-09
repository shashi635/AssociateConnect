<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AssociateConnect.Account.Register" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Styles/Site.css" />
    <link rel="stylesheet" type="text/css" href="../Styles/datePicker.css" />
    <link href="../Styles/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../Styles/jquery-ui-1.7.2.custom.css" />
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.autocomplete.js" type="text/javascript"></script>
    <script src="../Scripts/json2-min.js" type="text/javascript"></script>
    <%--<script src="../Scripts/datepicker.js" type="text/javascript"></script>--%>

     <script type="text/javascript">
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
         //-----------------------------------------------------------function populating Group-----------------------------------------------------
         function getGroup() {
             $.ajax({
                 type: "GET",
                 url: '../Service/Associate.svc/getGroups',
                 complete: function (result) {
                     if (result.responseText != null) {
                         var data = JSON.parse(result.responseText);
                         var targetCntrl = $("#ddlGroup");
                         var options = "<option value=''></option>";
                         for (k = 0; k < (data.length); k++) {
                             options += "<option value='" + data[k].GroupID + "'>" + data[k].GroupDesc + "</option>";
                         }
                         targetCntrl.empty().append(options);
                     }
                 }
             });
         }
         //-----------------------------------------------------------function populating location-----------------------------------------------------

         function populateLocation() {
             $.ajax({
                 url: "../Service/Associate.svc/Location/get",
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
         //-----------------------------------------------------------function populating AddressType-----------------------------------------------------

         function populateAddressType() {
             $.ajax({
                 url: "../Service/Associate.svc/AddressType/get",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDownAddressType('ddlAddressType', result);
             }

             function AjaxFailed(result) { }

             function bindDropDownAddressType(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].AddressTypeID + "'>" + data[k].AddressTypeDesc + "</option>";
                 }
                 targetCntrl.empty().append(options);
             }
         }
         //-----------------------------------------------------------function populating Projectname-----------------------------------------------------

         function populateProjectName() {
             $.ajax({
                 url: "../Service/Associate.svc/Project/get",
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
         //--------------------------------------------------------function populating account----------------------------------------------------

         function populateAccount(PracticeID) {
             var PID = PracticeID.toString();
             $.ajax({
                 url: "../Service/Associate.svc/Account/" + PID + "/get",
                 type: "GET",
                 contentType: "application/json; charset=utf-8",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDownAccount('ddlAccount', result);
             }

             function AjaxFailed(result) {
             }

             function bindDropDownAccount(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].AccountID + "'>" + data[k].AccountName + "</option>";
                 }
                 targetCntrl.empty().append(options);
             }
         }

         //----------------------------------------------------function populating practices-----------------------------------------------------
         function populatePractice() {
             $.ajax({
                 url: "../Service/Associate.svc/Practice/get",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDownPractice('ddlPractice', result);
             }

             function AjaxFailed(result) { }

             function bindDropDownPractice(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].PracticeID + "'>" + data[k].PracticeName + "</option>";
                 }
                 targetCntrl.empty().append(options);
             }
         }
         //------------------------------------------------- function populating designation ---------------------------------------------------------------

         function populatedesignation() {
             $.ajax({
                 url: "../Service/Associate.svc/designation/get",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDowndesignation('ddlDesignation', result);
             }

             function AjaxFailed(result) { }

             function bindDropDowndesignation(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].DesignationID + "'>" + data[k].DesignationName + "</option>";
                 }
                 targetCntrl.empty().append(options);
             }
         }
         //-----------------------------------------------------function populating phonetype------------------------------------------------------
         function populatePhoneType() {
             $.ajax({
                 url: "../Service/Associate.svc/PhoneType/get",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDownPhoneType('ddlPhoneType', result);
             }

             function AjaxFailed(result) { }

             function bindDropDownPhoneType(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].PhoneTypeID + "'>" + data[k].PhoneTypeDesc + "</option>";
                 }
                 targetCntrl.empty().append(options);
             }
         }
         //-----------------------------------------------------function populating addresstype------------------------------------------------------
         function populateAddressType() {
             $.ajax({
                 url: "../Service/Associate.svc/AddressType/get",
                 success: AjaxSucceeded,
                 error: AjaxFailed
             });

             function AjaxSucceeded(result) {
                 bindDropDownAddressType('ddlAddressType', result);
             }

             function AjaxFailed(result) { }

             function bindDropDownAddressType(cntrl, data) {
                 var targetCntrl = $("#" + cntrl + "");
                 eval('var data1 = data;'); // you can use a parsing function here instead of eval. 
                 var options = "<option value=0></option>";
                 for (k = 0; k < (data.length); k++) {
                     options += "<option value='" + data[k].AddressTypeID + "'>" + data[k].AddressTypeDesc + "</option>";
                 }
                 targetCntrl.empty().append(options);

             }
         }


         $(document).ready(function () {
             var ptype;
             var flag = false;
             ptype = $(":selected", $('#ddlPhoneType')).text()
             $('#trPractice').hide();
             $('#trPractice1').hide();
             $('.trigger').hide();
             $('#warning').hide();
             $('#phn').hide();
             $('#successfull_addition').hide();
             $('#Addition_failed').hide();

             //             $('#txtDOJ').Datepicker();
             //---------------------------------------------------------------------------------------------------------------------
             $('.details').focus(function () {
                 $(this).css('opacity', 0);
             });
             //----------------------------------------------------- Live textbox ------------------------------------------------------

             $('.textboxmember').focus(function () {
                 $(this).removeClass("textboxmember");
                 $(this).addClass("textboxhovermember");
             });

             $(".textboxmember").blur(function () {
                 $(this).removeClass("textboxhovermember");
                 $(this).addClass("textboxmember");
             });

             //-------------------------------------------------------------------------------Autocomplete State--------------------------------------

             var ret;

             $("#txtCountry").focusout(function () {
                 var obj = new Object();
                 obj.Country = $("#txtCountry").val();

                 $.ajax({
                     url: '../Web/Member/SearchState.ashx',
                     data: obj,
                     type: "GET",
                     contentType: "application/json; charset=utf-8",
                     success: function (data) {
                         var datafromServer = data.split('|');
                         $("#txtState").autocomplete(datafromServer);
                     },
                     error: function () { }
                 });
             });
             //--------------------------------------------autocomplete City---------------------------------------------------------------
             var ret;

             $("#txtState").focusout(function () {
                 var obj = new Object();
                 obj.State = $("#txtState").val();

                 $.ajax({
                     url: '../Web/Member/SearchCity.ashx',
                     data: obj,
                     type: "GET",
                     contentType: "application/json; charset=utf-8",
                     success: function (data) {
                         var datafromServer = data.split('|');
                         $("#txtCity").autocomplete(datafromServer);
                     },
                     error: function () { }
                 });
             });
             //-------------------------------------------------------------Autocomplete Country------------------------------------------------------------
             $("#txtCountry").autocomplete('../Web/Member/SearchCountry.ashx');

             //------------------------------------------------------ Populate Group ------------------------------------
             getGroup();
             //------------------------------------------------------ Populate designation ------------------------------------
             populatedesignation();
             //-----------------------------------------------------------Populate Phone Type-------------------------
             populatePhoneType();
             //-----------------------------------------------------------Populate Practices-----------------------------------
             populatePractice();
             //----------------------------------------------------PopulateAddressType-----------------------------------------
             populateAddressType();
             //----------------------------------------------------------Populate Location---------------------------------------
             populateLocation();
             //----------------------------------------------------------Populate Projectname---------------------------------------
             populateProjectName();
             //----------------------------------------------------------Populate AddressType---------------------------------------
             populateAddressType();

             $('#ddlPractice').change(function () {
                 var practice = $(":selected", $('#ddlPractice')).val();
                 populateAccount(practice);
             });

             $('#ddlPhoneType').change(function () {
                 var phonetype = $(":selected", $('#ddlPhoneType')).val();
                 if (phonetype = "") {
                     $('#phn').hide()
                 }
                 else {
                     $('#phn').show()
                 }
             });

             $('#btnCreateUser').click(function () {
                 flag = true;
                 $('#successfull_addition').hide();
                 $('#Addition_failed').hide();

                 validate();

                 $("#lblWarning").empty();
                 if (ret) {
                     $('#warning').hide();
                     var obj = new Object();
                     obj.UserID = $("#txtUserName").val();
                     obj.email = $("#txtEmail").val();
                     obj.Password = $("#txtPassword").val();
                     obj.AssociateID = parseInt($("#txtAssociateID").val());
                     obj.DesignationID = parseInt($(":selected", $('#ddlDesignation')).val());
                     obj.FirstName = $("#txtFirstName").val();
                     obj.LastName = $("#txtLastName").val();
                     //                     obj.PracticeID = $(":selected", $('#ddlPractice')).val();
                     //                     obj.AccountID = $(":selected", $('#ddlAccount')).text();
                     obj.LocationID = parseInt($(":selected", $('#ddlLocation')).val());
                     obj.DOJ = ($("#txtDOJ").val());
                     obj.Mobile = $("#txtMobile").val();
                     obj.DOB = ($("#txtDOB").val());
                     obj.ProjectID = parseInt($(":selected", $('#ddlProjectName')).val());
                     obj.DirectReportID = ($("#txtDirectReportID").val() == "") ? 0 : parseInt($("#txtDirectReportID").val());
                     obj.GroupID = parseInt($(":selected", $('#ddlGroup')).val());

                     $.ajax({
                         url: "../Service/Associate.svc/associate/add",
                         data: JSON.stringify(obj),
                         type: "PUT",
                         contentType: "application/json; charset=utf-8",
                         success: fun_success,
                         error: fun_err
                     });
                     function fun_success(result) {
                         if (result == "success") {
                             var retphn = AddPhone();
                             var retadd = AddAddress();
                             reset();
                             $('#successfull_addition').show();
                         }
                     }
                     function fun_err(result) {
                         $('#Addition_failed').show();
                     }
                 }
                 else {
                     $('#warning').show();
                     $('#warning').focus();
                 }
             });

             function AddPhone() {
                 var AssociateID = $("#txtAssociateID").val();
                 var phone = new Object();
                 phone.PhoneTypeID = parseInt($(":selected", $('#ddlPhoneType')).val());
                 phone.PhoneNo = $("#txtphn").val();

                 $.ajax({
                     url: '../Service/Associate.svc/associate/phone/' + AssociateID + '/add',
                     data: JSON.stringify(phone),
                     type: "PUT",
                     contentType: "application/json; charset=utf-8",
                     success: fun_success,
                     error: fun_err
                 });
                 function fun_success(result) {
                     //reset();
                     $('#successfull_addition').show();
                     return 1;
                 }
                 function fun_err(result) {
                     $('#Addition_failed').show();
                     return 0;
                 }
             }

             function AddAddress() {
                 var AssociateID = $("#txtAssociateID").val();
                 var address = new Object();
                 address.AddressTypeID = parseInt($(":selected", $('#ddlAddressType')).val());
                 address.Address1 = $("#txtAddress1").val();
                 address.Address2 = $("#txtAddress2").val();
                 address.Address3 = $("#txtAddress3").val();
                 address.Country = $("#txtCountry").val();
                 address.State = $("#txtState").val();
                 address.Zip = $("#txtzipcode").val();
                 address.City = $("#txtCity").val();

                 $.ajax({
                     url: '../Service/Associate.svc/associate/address/' + AssociateID + '/add',
                     data: JSON.stringify(address),
                     type: "PUT",
                     contentType: "application/json; charset=utf-8",
                     success: fun_success,
                     error: fun_err
                 });
                 function fun_success(result) {
                     //reset();
                     $('#successfull_addition').show();
                     return 1;
                 }
                 function fun_err(result) {
                     $('#Addition_failed').show();
                     return 0;
                 }
             }

             $("#txtUserName").blur(function () {
                 if (flag)
                     UserName();
             });
             $("#txtEmail").blur(function () {
                 if (flag)
                     Email();
             });
             $("#txtPassword").blur(function () {
                 if (flag)
                     Password();
             });
             $("#txtConfirmPassword").blur(function () {
                 if (flag)
                     ConfirmPassword();
             });
             $("#txtAssociateID").blur(function () {
                 if (flag)
                     Associateid();
             });
             $("#ddlDesignation").blur(function () {
                 if (flag)
                     Designation();
             });
             $("#ddlPractice").blur(function () {
                 if (flag)
                     Practice();
             });
             $("#ddlAccount").blur(function () {
                 if (flag)
                     Account();
             });
             $("#ddlLocation").blur(function () {
                 if (flag)
                     Location();
             });
             $("#txtzipcode").blur(function () {
                 if (flag)
                     ZipCode();
             });
             $("#ddlPhoneType").blur(function () {
                 if (flag)
                     PhoneType();
             });
             $("#txtMobile").blur(function () {
                 if (flag)
                     Mobile();
             });
             $("#ddlProjectName").blur(function () {
                 if (flag)
                     ProjectName();
             });
             $("#ddlGroup").blur(function () {
                 if (flag)
                     Group();
             });
             $("#ddlAddressType").blur(function () {
                 if (flag)
                     AddressType();
             });

             $("#txtAddress1").blur(function () {
                 if (flag)
                     Address1();
             });


             function validate() {
                 ret = true;
                 $(".Warning").empty();
                 Associateid();
                 ZipCode();
                 Email();
                 Designation();
                 PhoneType();
                 UserName();
                 Password();
                 Location();
                 ConfirmPassword();
                 Location();
                 Mobile();
                 ProjectName();
                 Group();
                 Landline();
                 AddressType();
                 Address1();
             }

             function Associateid() {
                 var username_length;
                 username_length = $("#txtAssociateID").val().length;
                 var reid = /^\d+$/
                 var check = false;
                 var obj = new Object();
                 obj.AssociateID = $("#txtAssociateID").val();

                 $.ajax({
                     url: '../Web/Member/CheckID.ashx',
                     data: obj,
                     type: "GET",
                     contentType: "application/json; charset=utf-8",
                     success: fun_success,
                     error: fun_err
                 });
                 function fun_success(result) {
                     if (result == "failure") {
                         check = true;
                     }
                 }
                 function fun_err(result) {
                 }

                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_id').show();
                     popup();
                     $('#<%=Label16.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtAssociateID').value.search(reid) == -1) {
                     $('#warning').show();
                     $('#warning_id').show();
                     popup();
                     $('#<%=Label16.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (check == true) {
                     $('#warning').show();
                     $('#warning_id').hide();
                     $('#warning_duplicateid').show();
                     popup();
                     $('#<%=Label16.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_id').hide();
                     $('#warning_duplicateid').hide();
                     $('#<%=Label16.ClientID%>').removeClass("labelerror");
                 }
             }

             function UserName() {
                 var username_length;
                 var check = false;
                 var obj = new Object();
                 obj.UserID = $("#txtUserName").val();
                 username_length = $("#txtUserName").val().length;

                 $.ajax({
                     url: '../Web/Member/CheckUsername.ashx',
                     data: obj,
                     type: "GET",
                     contentType: "application/json; charset=utf-8",
                     success: fun_success,
                     error: fun_err
                 });
                 function fun_success(result) {
                     if (result == "failure") {
                         check = true;
                     }
                 }
                 function fun_err(result) {
                 }

                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_username').show();
                     popup();
                     $('#<%=Label1.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (check == true) {
                     $('#warning').show();
                     $('#warning_username').hide();
                     $('#warning_duplicateusername').show();
                     popup();
                     $('#<%=Label1.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_username').hide();
                     $('#<%=Label1.ClientID%>').removeClass("labelerror");
                 }
             }

             function Address1() {
                 var username_length;
                 username_length = $("#txtAddress1").val().length;
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_address1').show();
                     popup();
                     $('#<%=Label20.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_address1').hide();
                     $('#<%=Label20.ClientID%>').removeClass("labelerror");
                 }
             }

             function Group() {
                 var Val = new Object();
                 Val.Group = $(":selected", $('#ddlGroup')).text();
                 if (Val.Group == "") {
                     $('#warning').show();
                     $('#warning_Group').show();
                     popup();
                     $('#lblGroup').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_Group').hide();
                     $('#lblGroup').removeClass("labelerror");
                 }
             }


             function ProjectName() {
                 var Val = new Object();
                 Val.ProjectName = $(":selected", $('#ddlProjectName')).text();
                 if (Val.ProjectName == "") {
                     $('#warning').show();
                     $('#warning_projectname').show();
                     popup();
                     $('#<%=Label12.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_projectname').hide();
                     $('#<%=Label12.ClientID%>').removeClass("labelerror");
                 }
             }

             function ConfirmPassword() {
                 var pwd = $("#txtPassword").val();
                 var cpwd = $("#txtConfirmPassword").val();
                 var cpwd_length;
                 cpwd_length = $("#txtConfirmPassword").val().length;
                 if (cpwd_length == 0) {
                     $("#warning_confirmpassword").show();
                     popup();
                     $('#<%=Label4.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (cpwd != pwd) {
                     $("#warning_confirmpassword").show();
                     popup();
                     $('#<%=Label4.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_confirmpassword').hide();
                     $('#<%=Label4.ClientID%>').removeClass("labelerror");
                 }
             }

             function ZipCode() {
                 var username_length;
                 username_length = $("#txtzipcode").val().length;
                 var rezipcode = /^[0-9]{6}$/
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_zipcode').show();
                     popup();
                     $('#<%=Label14.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtzipcode').value.search(rezipcode) == -1) {
                     $('#warning').show();
                     $('#warning_zipcode').show();
                     popup();
                     $('#<%=Label14.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_zipcode').hide();
                     $('#<%=Label14.ClientID%>').removeClass("labelerror");
                 }
             }
             function PhoneType() {
                 var Val = new Object();
                 Val.Phone = $(":selected", $('#ddlPhoneType')).text();
                 if (Val.Phone == "" || Val.Phone == "select") {
                     $('#warning').show();
                     $('#warning_phoneType').show();
                     popup();
                     $('#<%=Label27.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_phoneType').hide();
                     $('#<%=Label27.ClientID%>').removeClass("labelerror");
                 }
             }

             function Account() {
                 var account_length = new Object();
                 account_length.Account = $(":selected", $('#ddlAccount')).text();
                 if (account_length.Account == "" || account_length.Account == "select") {
                     $('#warning').show();
                     $('#warning_account').show();
                     popup();
                     $('#<%=Label29.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_account').hide();
                     $('#<%=Label29.ClientID%>').removeClass("labelerror");
                 }
             }

             function Practice() {
                 var practice_length = new Object();
                 practice_length.Practice = $(":selected", $('#ddlPractice')).text();
                 if (practice_length.Practice == "" || practice_length.Practice == "select") {
                     $('#warning').show();
                     $('#warning_practice').show();
                     popup();
                     $('#<%=Label23.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_practice').hide();
                     $('#<%=Label23.ClientID%>').removeClass("labelerror");
                 }
             }

             function Location() {
                 var location = $(":selected", $('#ddlLocation')).text();
                 if (location == "") {
                     $('#warning').show();
                     $('#warning_location').show();
                     popup();
                     $('#<%=Label9.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_location').hide();
                     $('#<%=Label9.ClientID%>').removeClass("labelerror");
                 }
             }


             function AddressType() {
                 var location = $(":selected", $('#ddlAddressType')).text();
                 if (location == "") {
                     $('#warning').show();
                     $('#warning_addresstype').show();
                     popup();
                     $('#<%=Label15.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_addresstype').hide();
                     $('#<%=Label15.ClientID%>').removeClass("labelerror");
                 }
             }

             function Password() {
                 var username_length;
                 username_length = $("#txtPassword").val().length;
                 var re = /^\w{6,}$/                     ///^[A-Za-z]\w{6,}[A-Za-z]$/             ///^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{4,8}$/   ///(?=.{6,})(?=.*[a-z])(?=.*[A-Z])/
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_password').show();
                     popup();
                     $('#<%=Label3.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtPassword').value.search(re) == -1) {    //(re.test(username_length)) {
                     $('#warning').show();
                     $('#warning_password').show();
                     popup();
                     $('#<%=Label3.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_password').hide();
                     $('#<%=Label3.ClientID%>').removeClass("labelerror");
                 }
             }

             function Email() {
                 var username_length;
                 username_length = $("#txtEmail").val().length;
                 var re5digit = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_email').show();
                     popup();
                     $('#<%=Label2.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtEmail').value.search(re5digit) == -1) {
                     $('#warning').show();
                     $('#warning_email').show();
                     popup();
                     $('#<%=Label2.ClientID%>').addClass("labelerror");
                     ret = false;

                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_email').hide();
                     $('#<%=Label2.ClientID%>').removeClass("labelerror");
                 }
             }


             function Designation() {
                 var Val = new Object();
                 Val.Designation = $(":selected", $('#ddlDesignation')).text();
                 if (Val.Designation == "" || Val.Designation == "select") {
                     $('#warning').show();
                     $('#warning_designation').show();
                     popup();
                     $('#<%=Label19.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_designation').hide();
                     $('#<%=Label19.ClientID%>').removeClass("labelerror");
                 }
             }

             function Mobile() {
                 var username_length;
                 username_length = $("#txtMobile").val().length;
                 var rephone = /^((\+){0,1}91(\s){0,1}(\-){0,1}(\s){0,1}){0,1}[0-9]{10}$/
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_mobile').show();
                     popup();
                     $('#<%=Label6.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtMobile').value.search(rephone) == -1) {
                     $('#warning').show();
                     $('#warning_mobile').show();
                     popup();
                     $('#<%=Label6.ClientID%>').addClass("labelerror");
                     ret = false;

                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_mobile').hide();
                     $('#<%=Label6.ClientID%>').removeClass("labelerror");
                 }
             }

             function Landline() {
                 var username_length;
                 username_length = $("#txtphn").val().length;
                 var rephone = /^[0-9]\d{2,4}-\d{6,8}$/
                 if (username_length == 0) {
                     $('#warning').show();
                     $('#warning_phn').show();
                     popup();
                     $('#<%=Label18.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else if (document.getElementById('txtphn').value.search(rephone) == -1) {
                     $('#warning').show();
                     $('#warning_phn').show();
                     popup();
                     $('#<%=Label18.ClientID%>').addClass("labelerror");
                     ret = false;
                 }
                 else {
                     if (ret == true)
                         $('#warning').hide();
                     $('#warning_phn').hide();
                     $('#<%=Label18.ClientID%>').removeClass("labelerror");
                 }
             }

             $('#btnClear').click(reset);

             function reset() {
                 flag = false;
                 document.getElementById("txtUserName").value = '';
                 document.getElementById("txtEmail").value = '';
                 document.getElementById("txtPassword").value = '';
                 document.getElementById("txtConfirmPassword").value = '';
                 document.getElementById("txtAssociateID").value = '';
                 document.getElementById("txtFirstName").value = '';
                 document.getElementById("txtLastName").value = '';
                 document.getElementById("txtDOJ").value = '';
                 document.getElementById("txtMobile").value = '';
                 document.getElementById("txtDOB").value = '';
                 document.getElementById("txtDirectReportID").value = '';
                 document.getElementById("txtAddress1").value = '';
                 document.getElementById("txtAddress2").value = '';
                 document.getElementById("txtAddress3").value = '';
                 document.getElementById("txtCountry").value = '';
                 document.getElementById("txtState").value = '';
                 document.getElementById("txtzipcode").value = '';
                 document.getElementById("txtCity").value = '';
                 document.getElementById("txtphn").value = '';
                 document.getElementById("ddlProjectName").selectedIndex = 0;
                 document.getElementById("ddlAccount").selectedIndex = 0;
                 document.getElementById("ddlAddressType").selectedIndex = 0;

                 getGroup();
                 populatedesignation();
                 populatePhoneType();
                 populatePractice();
                 populateLocation();
                 $("#populateAccount").empty();
                 $('#successfull_addition').hide();
                 $('#Addition_failed').hide();
                 $('#warning').hide();
                 $('.trigger').hide();
                 $('#belowlandline').hide();
                 $('#<%=Label1.ClientID%>').removeClass("labelerror");
                 $('#<%=Label2.ClientID%>').removeClass("labelerror");
                 $('#<%=Label3.ClientID%>').removeClass("labelerror");
                 $('#<%=Label4.ClientID%>').removeClass("labelerror");
                 $('#<%=Label9.ClientID%>').removeClass("labelerror");
                 $('#<%=Label16.ClientID%>').removeClass("labelerror");
                 $('#<%=Label19.ClientID%>').removeClass("labelerror");
                 $('#<%=Label23.ClientID%>').removeClass("labelerror");
                 $('#<%=Label29.ClientID%>').removeClass("labelerror");
                 $('#<%=Label12.ClientID%>').removeClass("labelerror");
                 $('#lblGroup').removeClass("labelerror");
                 $('#<%=Label6.ClientID%>').removeClass("labelerror");
                 $('#<%=Label27.ClientID%>').removeClass("labelerror");
                 $('#<%=Label14.ClientID%>').removeClass("labelerror");
                 $('#<%=Label18.ClientID%>').removeClass("labelerror");
                 $('#<%=Label20.ClientID%>').removeClass("labelerror");
                 $('#<%=Label15.ClientID%>').removeClass("labelerror");
             }



         });

     </script>

    <style type="text/css">
        #ddlDesignation
        {
            width: 220px;
        }
        #ddlAccount
        {
            width: 220px;
        }
        #ddlPractice
        {
            width: 220px;
        }
        #ddlLocation
        {
            width: 220px;
        }
        #ddlPhone
        {
            width: 220px;
        }
        .style4
        {
            font-weight: 700;
            color: #FF0000;
        }
        .style9
        {
            color: #FF0000;
            font-weight: 700;
        }
        .style10
        {
            width: 99px;
        }
        .style11
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 12px;
        }
        .style12
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 99px;
        }
        #txtAddress
        {
            width: 222px;
        }
        .style15
        {
            font-weight: 700;
            color: #FF0000;
            width: 6px;
        }
        .style16
        {
            color: #FF0000;
            font-weight: 700;
            width: 7px;
        }
        .style17
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            }
        .style18
        {
            width: 7px;
        }
        .style20
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            width: 6px;
        }
        .style21
        {
            width: 6px;
        }
        
        .style23
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
        }
        .style24
        {
            width: 74px;
        }
        .style25
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
            }
        #ddlPhoneType
        {
            width: 220px;
        }
        .style27
        {
            color: #FF0000;
            font-weight: 700;
            line-height: 0.5em;
        }
        #ddlAddressType
        {
            width: 220px;
        }
        .style28
        {
            color: #FF0000;
        }
        #ddlProjectName
        {
            width: 220px;
        }
    </style>

        
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table width="100%">
            <tr style="width:100%">
            <td style="width:10%">
            <div style="height:20%">
            <asp:image ID="Image1" runat="server" ImageUrl="/Web/Images/brand_small.jpg"></asp:image>
             </div>
           </td>
            <td align="left" class="style2">
                <asp:Image ID="Image2" runat="server" ImageUrl="../Web/Images/Heading/AssociateConnect1.bmp" /> </td>
            </tr>
            </table>
  
    <br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp        
    <img src="../Web/Images/Heading/Register.JPG" alt="Register" /><br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    <strong>
        <em>Fields marked with <span class="style9">*</span> is mandatory.</em></strong>    
                                    <br />
        
        <div id="warning" class="error">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span>Bring the mouse over </span>
            <img src="../Web/Images/attention-icon.JPG" alt="warning" />
            <span>icon to see the warning(s).</span>
        </div>
        <div id="successfull_addition">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <span class="style4">
        <strong><em style="color: #FF0000">User has been registered successfully.</em></strong>
        </span>
        </div>
        <div id="Addition_failed"">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <span class="style4" style="color: #FF0000">
        <strong><em>User registration failed.</em></strong>
        </span>
        <span class="style4">
            <a href="Login.aspx"></a>
        </span>
        </div>



   <div class="details">
       <fieldset class="fldset">
        <legend align="left">Account Information</legend>
         <br />
    
        <table style="margin-bottom: 0px; padding-left: 40px;" align="left">

            <tr>
                <td class="style24" nowrap="nowrap">
            <asp:Label ID="Label1" runat="server" class="label" Text="User Name"></asp:Label>
                </td>
                <td>
                    <input class="textboxmember" id="txtUserName" type="text"/></td>
                <td class="style15">
                    <strong style="color: #FF0000">*</strong></td>
                    <td width="100"><div class="bubbleInfo">
                        <img id="warning_username" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Please enter the User Name ! 
                        </div>
                    </div>
                    <div class="bubbleInfo">
                        <img id="warning_duplicateusername" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                           User Name already exist ! 
                        </div>
                        
                    </div></td>

                <td class="style18">
                 <asp:Label ID="Label2" runat="server" class="label" Text="Email"></asp:Label></td>
                 <td>
                    <input class="textboxmember" id="txtEmail" type="text"/></td>
                <td class="style4">
                    <strong style="color: #FF0000">*</strong></td>
                    <td width="100">
                    <div class="bubbleInfo">
                        <img id="warning_email" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter email in correct format ! 
                        </div>
                    </div></td>
                     </tr>
            <tr>
                <td class="style25" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style24">
                
    
            
                    <asp:Label ID="Label3" runat="server" class="label" Text="Password"></asp:Label>
                
    
            
    </td>
                <td >
                    <input id="txtPassword" type="password" class="textboxmember"   /></td>
                <td class="style15">
                    *</td>
                    
                <td width="100">
                    
                <div class="bubbleInfo">
                        <img id="warning_password" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter the valid Password ! 
                        </div>
                        </div>
                    
                        
                
                   </td>
                <td class="style18" nowrap="nowrap">
    <asp:Label ID="Label4" runat="server" class="label" Text=" Confirm Password"></asp:Label>
                </td>
                <td class="style16">
                    <input id="txtConfirmPassword"  type="password"  class="textboxmember" /></td>
                <td class="style9">
                    *</td>
               <td width="100">
                    <div class="bubbleInfo">
                        <img id="warning_confirmpassword" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Please re-enter the password correctly ! 
                        </div>
                    </div></td>
            </tr>
            </table>
    
    </fieldset>
    </div>
                    


     <div class="details">
    <fieldset class="fldset">
    <legend align="left">Personal Information</legend>
    <br />
        <table style="margin-bottom: 0px; padding-left: 40px;" align="left">

            <tr>
                <td nowrap="nowrap">
            <asp:Label ID="Label16" runat="server" class="label" Text="Associate ID"></asp:Label>
                </td>
                <td>
                    <input class="textboxmember" id="txtAssociateID" type="text"/></td>
                 <td class="style15">
                    <strong style="color: #FF0000">*</strong></td>
                <td width="100">
                    <div class="bubbleInfo">
                        <img id="warning_id" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter Associate ID as numeric ! 
                        </div>
                        
                    </div>
                    <div class="bubbleInfo">
                        <img id="warning_duplicateid" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Associate ID already exist ! 
                        </div>
                        
                    </div>
                    </td>
                <td width="81">
                
    
            
                    <asp:Label ID="Label6" runat="server" class="label" Text="Mobile"></asp:Label>
                
    
            
    </td>
                <td >
                    <input id="txtMobile" class="textboxmember" type="text" /></td>
                <td class="style15">
                    *</td>
                    
                <td width="100">
                    
                <div class="bubbleInfo">
                        <img id="warning_mobile" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter the Mobile no of 10 digit ! 
                        </div>
                    </div></td>
                                
            </tr>
            <tr>
                <td class="emptyrow">
                    &nbsp;</td>
                <td class="emptyrow" colspan="3">
        
                </td>
                <td class="style27">
                    &nbsp;</td>
                <td class="style17" colspan="3">
                    &nbsp;</td>
            </tr>
            <tr>
                <td width="81">
                
    
            
                    <asp:Label ID="Label17" runat="server" class="label" Text="First Name"></asp:Label>
                
    
            
    </td>
                <td >
                    <input id="txtFirstName" class="textboxmember" type="text" /></td>
                <td class="style15">
                </td>
                    
                <td width="100">
                    
                </td>
                <td nowrap="nowrap">
    <asp:Label ID="Label8" runat="server" class="label" Text=" Last Name"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td class="style16">
                    <input id="txtLastName" type="text" class="textboxmember" /></td>
                <td class="style9">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr id="trPractice1">
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr id="trPractice">
                <td>
    <asp:Label ID="Label23" runat="server" class="label"
        Text="Practice"></asp:Label>
                </td>
                <td >
                <select class="ddl" id="ddlPractice" name="D3">
                    </select>
                    </td>
                <td class="style15">
                    *</td>
                <td  width="100">
                    <div class="bubbleInfo">
                        <img id="warning_practice" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter ur Practice ! 
                        </div>
                    </div></td>
                <td>
        <asp:Label ID="Label29" runat="server" class="label" Text="Account"></asp:Label>
    
                </td>
                <td class="style16">
                    <select id="ddlAccount" class="ddl" name="D4" >
                    </select></td>
                <td class="style28">
                    <strong>*</strong></td>
                <td class="style8">
                    <div class="bubbleInfo">
                        <img id="warning_account" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter ur Account ! 
                        </div>
                    </div></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr id="trPractice">
                <td>
        <asp:Label ID="Label10" runat="server" class="label" Text="DOJ"></asp:Label>
    
                </td>
                <td class="style16">
                    <input id="txtDOJ" type="text" class="textboxmember" /></td>
                <td class="style15">
                    &nbsp;</td>
                <td  width="100">
                    &nbsp;</td>
                <td>
    <asp:Label ID="Label11" runat="server" class="label" Text=" DOB"></asp:Label>
                </td>
                <td class="style16">
                    <input id="txtDOB" type="text" class="textboxmember" /></td>
                <td class="style28">
                    &nbsp;</td>
                <td class="style8">
                    &nbsp;</td>
            </tr>
            

            </table>
    
    </fieldset>
    </div>
    <br />
    <br />
    <div class="details">
    <fieldset class="fldset">
    <legend>Business Information</legend>
    <br />
        <table style="margin-bottom: 0px; padding-left: 40px;" align="left">
            <tr>
                <td class="style18">
                <asp:Label ID="Label19" runat="server" Text="Designation"   class="label"></asp:Label>
                </td>
                <td class="style16">
                    <select class="ddl" id="ddlDesignation" name="D1">
                    </select>
                    </td>
                <td class="style4">
                    <strong>*</strong></td>
                    <td  width="100">
                    <div class="bubbleInfo">
                        <img id="warning_designation" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter ur designation ! 
                        </div>
                    </div>
                </td>
                                
                <td>
    <asp:Label ID="Label13" runat="server" class="label" Text=" DirectReportID"></asp:Label>
                
                </td>
                <td class="style16">
                    <input id="txtDirectReportID" type="text" class="textboxmember" /></td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style10">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="4">
                    &nbsp;</td>
                <td class="style23" style=" width: 105px;">
                    &nbsp;</td>
                <td class="emptyrow" colspan="3">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
    <asp:Label ID="Label9" runat="server" class="label"
        Text="Location"></asp:Label>
                </td>
                <td >
                <select class="ddl" id="ddlLocation" name="D5">
                    </select>
                    </td>
                <td class="style15">
                    *</td>
                <td class="style8">
                    <div class="bubbleInfo">
                        <img id="warning_location" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter ur Location !
                        </div>
                    </div>
                </td>
                <td width="81">
                
    
            
                    <asp:Label ID="Label12" runat="server" class="label" Text="ProjectName"></asp:Label>
                
    
            
    </td>
                <td >
                    <select class="ddl" id="ddlProjectName" name="D6">
                    </select></td>
                <td class="style15">
                    *</td>
                    
                <td width="100">
                    
                <div class="bubbleInfo">
                        <img id="warning_projectname" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Select ur Project Name ! 
                        </div>
                    </div></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr>
                <td width="81">
                    <label id="lblGroup" class="label">Group</label>
                </td>
                <td >
                    <select id="ddlGroup" style="width:220px;" name="D7"></select></td>
                <td class="style15">
                    *</td>
                    
                <td width="100">
                    <div class="bubbleInfo">
                        <img id="warning_Group" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Select a group! 
                        </div>
                    </div>
                </td>
                <td class="style22">
                    
                    &nbsp;</td>
                <td class="style16">
                    &nbsp;</td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style10">
                    
                    &nbsp;</td>
            </tr>
            </table>
    </fieldset>
    </div>
    
    
    <br />
    <br />
    <div class="details">
    <fieldset class="fldset">
    <legend>Contact Information</legend>
    <br />
        <table style="margin-bottom: 0px; padding-left: 40px;" align="left">
            <tr>
                <td>
                    <asp:Label ID="Label15" runat="server" class="label"
        Text="AddressType"></asp:Label>&nbsp;</td>
                <td class="style16">
    <select id="ddlAddressType" class="ddl" name="D2">
                    </select></td>
                <td class="style15">
                    *</td>
                <td class="style8" width="100">
                    <div class="bubbleInfo">
                        <img id="warning_addresstype" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Select ur Address Type ! 
                        </div>
                    </div></td>
                <td class="style22">
    <asp:Label ID="Label22" runat="server" class="label"
        Text="Country"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td class="style16">
                <input id="txtCountry" type="text" class="textboxmember" />
    </td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style10">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="4">
                    &nbsp;</td>
                <td class="style23" style=" width: 105px;">
                    &nbsp;</td>
                <td class="emptyrow" colspan="3">
                    &nbsp;</td>
            </tr>
            <tr>
                <td width="81">
    <asp:Label ID="Label20" runat="server" class="label"
        Text="Address1"></asp:Label>
                </td>
                <td class="style16" >
    <input id="txtAddress1" type="text" class="textboxmember" /></td>
                <td class="style15">
                    *</td>
                <td width="100">
                     <div class="bubbleInfo">
                        <img id="warning_address1" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter your Address ! 
                        </div>
                    </div></td>
                <td class="style22">
    <asp:Label ID="Label24" runat="server" class="label"
        Text="State"></asp:Label>
                </td>
                <td class="style16">
    <input id="txtState" type="text" class="textboxmember" /></td>
                <td class="style21">
                    &nbsp;</td>
                <td class="style10">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
    
                    <asp:Label ID="Label5" runat="server" class="label"
        Text="Address2"></asp:Label></td>
                <td class="style16">
    <input id="txtAddress2" type="text" class="textboxmember" /></td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style4" width="100">
                    
                </td>
                <td class="style22">
    <asp:Label ID="Label28" runat="server" class="label"
        Text="City"></asp:Label>
                </td>
                <td class="style16">
    <input id="txtCity" type="text" class="textboxmember" /></td>
                <td class="style21">
                    &nbsp;</td>
                <td class="style10">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
    
                <asp:Label ID="Label7" runat="server" class="label"
        Text="Address3"></asp:Label></td>
                <td class="style16">
        
    <input id="txtAddress3" type="text" class="textboxmember" /></td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style4" width="100">
                  
                </td>
                <td class="style22">
                    
                    <asp:Label ID="Label14" runat="server" class="label" Text="ZipCode"></asp:Label>
                    
                </td>
                <td class="style16">
                    <input id="txtzipcode" type="text" class="textboxmember" /></td>
                <td class="style15">
                    *</td>
                <td class="style10">
                    
                 <div class="bubbleInfo">
                        <img id="warning_zipcode" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter 6 digit ZipCode ! 
                        </div>
                    </div></td>
            </tr>
            <tr>
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
             <tr>
                <td>
    
                <asp:Label ID="Label27" runat="server" class="label" Text="PhoneType"></asp:Label></td>
                <td class="style16">
        
                    <select id="ddlPhoneType" class="ddl" name="D2">
                    </select></td>
                <td class="style15">
                    <strong>*</strong></td>
                <td  width="100">
                  
                 <div class="bubbleInfo">
                        <img id="warning_phoneType" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Select the Phone type ! 
                        </div>
                    </div></td>
                <td class="style22">
                    &nbsp;</td>
                <td class="style16">
                    &nbsp;</td>
                <td class="style15">
                    &nbsp;</td>
                <td class="style10">
                    
                  </td>
            </tr>
            <tr id="belowlandline">
                <td class="emptyrow" colspan="8">
                    &nbsp;</td>
            </tr>
            <tr id="phn">
                <td>
                
    
                <asp:Label ID="Label18" runat="server" class="label" Text="Phone"></asp:Label></td>
                <td class="style16">
        
                    <input id="txtphn" class="textboxmember" type="text" /></td>
                <td class="style15">
                     *</td>
                <td  width="100">
                    
                
                        
                   <div class="bubbleInfo">
                        <img id="warning_phn" alt="warning" class="trigger" 
                            src="../Web/Images/attention-icon.JPG" />
                        <div class="popup">
                            Enter in correct format 0xx-xxxxxxxx or 0xxx-xxxxxxx or 0xxxx-xxxxxx !  ! 
                        </div>
                    </div></td>
                <td class="style22">
    
                </td>
                <td class="style16">
    </td>
                <td class="style15">
                   </td>
                <td class="style10">
                    
                </td>
            </tr>
            </table>
    </fieldset>
    </div>
    <br />
    <br />
        
    <p align="center">
        <input id="btnCreateUser" type="button" class="button" value="Create User" size="10" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <input id="btnClear" type="button" class="button" value="Clear" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
           <%-- <input id="btnCancel" type="button" class="button" value="Cancel" />--%>
        <asp:Button ID="btnCancel" runat="server" CssClass="button" Text="Cancel" 
            onclick="btnCancel_Click" />
    </p>
    <br />

          
    </div>
    </form>
</body>
</html>
