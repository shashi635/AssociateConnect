$(document).ready(function () {

    $('#spnFogtoPwd').click(function () {
        if (($.trim($('#txtUID').val()) !== "") && ($.trim($('#txtUID').val()).length >= 6)) {
            setError("");
            ShowPopupForgotPWD("popUpDiv")
            //alert('Forogot password clicked');
        }
        else {
            setError("Please enter Login Name !");
        }
    });
    $('#btnSubmit').click(function () {

        if (validteAuthenticate() == true) {
            setError("");
            onAuthenticate($.trim($('#txtUID').val()), $.trim($('#txtPwd').val()));
        }

    });
    function validteAuthenticate() {

        var len = 6; //represent length of char for userid/password
        var u = $.trim($('#txtUID').val());
        var p = $.trim($('#txtPwd').val());
        var r = (p !== "") && (u !== "") ? true : false;
        var l = ((p.length >= len) && (u.length >= len) ? true : false);
        var res = false;
        if (r == true) {
            if (l == true) {
                res = true;
            }
            else {
                setError("User ID & password of length " + len + " are not allowed !");
            }
        }
        else {
            setError("Blank value not allowed !");
        }
        return res;
    };

    function setError(str) {
        if (str.length > 0) {
            $('#trError').show();
            $('#lblError').text(str);
        }
        else {
            $('#trError').hide();
            $('#lblError').text("");
        }
    };

    function onAuthenticate(uid, pwd) {
        //debugger;

        $.ajax({

            type: "GET",
            url: '../Service/AssociateMobile.svc/associate/' + uid + '/' + pwd + '/login',
            contentType: 'application/json; charset=utf-8',
            // dataType: 'json',
            success: function (result) {
                if (result !== undefined) {
                    if (result == "") {
                        //redirectPage("default.htm?page=login reqid=f");

                        setError("Login failed ! Please try again !");
                    }
                    else {

                        var auth = new Object();
                        var IsflowCorrect = true;
                        if ($("#hdnAuthenticate") !== undefined) {
                            auth.u = uid;
                            auth.p = pwd;
                            auth.surl = "";
                            auth.curl = "Menu.htm";
                            auth.status = true;
                            auth.AssociateID = result.AssociateID;
                            auth.Designation = result.Designation;
                            auth.DesignationID = result.DesignationID;
                            auth.DirectReportID = result.DirectReportID;
                            auth.DirectReporter = result.DirectReporter;
                            auth.DOB = result.DOB;
                            auth.DOJ = result.DOJ;
                            auth.Gender = result.Gender;
                            auth.email = result.email;
                            auth.Location = result.Location;
                            auth.LocationID = result.LocationID;
                            auth.Mobile = result.Mobile;
                            auth.Name = result.Name;
                            auth.ProjectID = result.ProjectID.Value;
                            auth.ProjectName = result.ProjectName;
                            auth.IsApproved = result.IsApproved;
                            //alert('Success' + result.groupList);
                            if (result.groupList !== undefined) {
                                auth.groupList = result.groupList;
                                auth.Role = result.Role;
                                auth.defaultgroupid = result.groupList[0].GroupID;
                                auth.defaultgroupname = result.groupList[0].GroupName;
                                auth.defaultgroupdesc = result.groupList[0].GroupDesc;
                            }
                            else {
                                auth.groupList = "";
                                auth.Role = "";
                                auth.defaultgroupid = "";
                                auth.defaultgroupname = "";
                                auth.defaultgroupdesc = "";
                            }
                            setSessionObject(auth);
                            if ($('#lbllogedinuser') !== undefined) {
                                $('#lbllogedinuser').text(auth.Name + "!!");
                            }
                            loadChildPage(auth.curl, false);
                        }
                        else {
                            IsflowCorrect = false;
                        }
                    }
                }
                else {

                }
            },
            error: function (e, xhr) {

                setError("Login failed ! Please try again !");
                //setError(e.toString());
                //errorcallback(e, xhr);
            }
        });
    };
});

function ShowPopupForgotPWD(cntnrDivID) {
    var cntnr = $("#" + cntnrDivID + "");
    cntnr.html("");
    var popupElements = '';
    popupElements += '<div id="childPopUpDiv" class="jqpopup">';
    popupElements += '<table class="jqpopupTable"><tr class="header4"><td colspan="2" style="text-align:right;">';
    popupElements += '<img src="./Images/Close.jpg" id="imgPopupClose" alt="Close" style="height:15px;" ';
    popupElements += 'onclick="closeReplyToPost(\'' + cntnrDivID + '\')"/></td></tr><tr><td  style="padding-left:25px; width:65%;">';
    popupElements += '<label id="lblStatus" class="headerText1">Forgot Password ?</label>';
    popupElements += '</td><td style="text-align:right;"><img src="./Images/indicator.gif" id="imgPopUpBusy"  style="height:12px; display:none;"';
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:left;" >';
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:left;" >';
    popupElements += '<label>Associate ID :</label>';
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:left;" >';
    popupElements += '<input id="txtFAssoID" type="text" style="width: 80%" />'
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:left;" >';
    popupElements += '<label>Associate Name :</label>';
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:left;" >';
    popupElements += '<input id="txtFAssoName" type="text" style="width: 80%" />'
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:center;" >';
    popupElements += '</td></tr><tr><td style="text-align:right; padding-right:2px;">';
    popupElements += '<input type="button" value="Submit" class="btnDefault1" id="btnSubmit" style="width:40%;"';
    popupElements += ' onclick="forgotPWD()" name="btnsReplyToPostPopuUp"/></td><td style="text-align:left;">';
    popupElements += '</td></tr></table></div>';


    cntnr.append($(popupElements));
    cntnr.addClass("jqpopupBackGround");
    centerPopup('childPopUpDiv');

    //SetDivLocation('cntnrDivID', srcid);
    cntnr.show();
    $("#childPopUpDiv").addClass("jqpopup");

}

function forgotPWD() {
    var uid = $.trim($('#txtUID').val());
    if (($.trim($('#txtFAssoName').val()) !== "") && ($.trim($('#txtFAssoID').val()) !== "")) {
        $('#imgPopUpBusy').show();
        getForgotPWD(uid, $.trim($('#txtFAssoID').val()), $.trim($('#txtFAssoName').val()));

    }
}

function getForgotPWD(uid, assID, name) {
    $.ajax({
        type: "GET",
        url: '../service/associatemobile.svc/associate/' + uid + '/' + assID + '/' + name + '/forgot',
        contentType: 'application/json; charset=utf-8',
        // dataType: 'json',{userid}/{associateid}/{name}/forgot
        success: function (result) {
            if (result == "") {
                alert('In-Valid Associate !');
                $('#imgPopUpBusy').hide();
            }
            else {
                SMSObject(result);
            }
        },
        error: function (e, xhr) {
            onServiceError(e, xhr);
        }
    });

}
function onServiceError(e, xhr) {
    alert('Getting error to fetch Data: ' + e.responseText);
}
////////////////////////////////////////////////////////////
function SMSObject(sms) {

    var smsObj = new Object();
    smsObj.loginid = '8961540630';
    smsObj.passwrd = 'cognizant';
    smsObj.msg = "AssociateConnect password is " + sms.Password;
    smsObj.tolist = '91' + sms.Mobile;
    sendForgotSMS(smsObj);

}
function sendForgotSMS(smsObj) {
    $.ajax({
        type: "GET",
        url: '../service/associatemobile.svc/SMS?loginid=' + smsObj.loginid + '&passwrd=' + smsObj.passwrd + '&tolist=' + smsObj.tolist + '&msg=' + smsObj.msg,
        contentType: 'application/json; charset=utf-8',
        success: function (result) {
            alert('Password send successfully...');
            closeReplyToPost('popUpDiv');
            //                        $("#btnSendGroupSMS")[0].disabled = false;
            //                        $("#imgBusyBM").hide();
            //                        $("#ddlPostGroupBM").val("");
            //                        $("#txtsmsbodyBM").val("");
        },
        error: function (e, xhr) {
            //debugger;
            alert('Password SMS failed...');
        }
    });
}