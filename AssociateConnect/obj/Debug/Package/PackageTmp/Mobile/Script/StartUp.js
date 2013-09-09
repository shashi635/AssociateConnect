
$(document).ready(function () {

    window.location.href = "Login.htm";
//    loadPage();

//    function loadPage() {
//        var startPage = document.location.href;
//        if (isAuthenticated() == true) {
//            var auth = getSessionObject();
//                loadChildPage(auth.curl, true);
//        }
//        else {
//            setSessionObject(null);
//            $('#tblMenuHeader').hide();
//            $('#lblLogedinUserGroup').text('');
//        }
//    };

//    $("input[type=image]").click(function () {
//        var tpmenu = $(this)[0].id;
//        switch (tpmenu) {
//            case 'Search':
//                loadChildPage('MyForum.htm', true);
//                break;
//            case 'Post':
//                loadChildPage('NewPost.htm', true);
//                break;
//            case 'Home':
//                loadChildPage('Menu.htm', true);
//                break;
//            case 'Broadcast':
//                loadChildPage('BroadcastSMS.htm', true);
//                break;
//            default:
//                loadChildPage('Dafault.htm', true);
//        }

//    });

//    $('#spnFogtoPwd').click(function () {
//        if (($.trim($('#txtUID').val()) !== "") && ($.trim($('#txtUID').val()).length >= 6)) {
//            setError("");
//            ShowPopupForgotPWD("popUpDiv")
//            //alert('Forogot password clicked');
//        }
//        else {
//            setError("Please enter Login Name !");
//        }
//    });
//    $('#btnSubmit').click(function () {

//        var len = 6; //represent length of char for userid/password
//        var u = $.trim($('#txtUID').val());
//        var p = $.trim($('#txtPwd').val());
//        var r = (p !== "") && (u !== "") ? true : false;
//        var l = ((p.length >= len) && (u.length >= len) ? true : false);
//        var res = false;
//        if (r == true) {
//            if (l == true) {
//                res = true;
//            }
//            else {
//                setError("User ID & password of length " + len + " are not allowed !");
//            }
//        }
//        else {
//            setError("Blank value not allowed !");
//        }

//        if (res) {
//            setError("");
//            onAuthenticate($.trim($('#txtUID').val()), $.trim($('#txtPwd').val()));
//        }

//    });
});

function getSessionObject() {
    if (typeof (sessionStorage) == 'undefined') {
        if ($("#hdnAuthenticate").val() != '') {
            return eval("(" + $("#hdnAuthenticate").val() + ')');
        }
    } 
    else {
        if (sessionStorage.getItem("loggedInUser") != null) {
            return JSON.parse(sessionStorage.getItem("loggedInUser"));
        }
    }
}
function setSessionObject(sessionObject) {
    if (sessionObject == null) {
        var sessionObject = new Object();
        sessionObject.u = "";
        sessionObject.p = "";
        sessionObject.surl = document.location.href;//  this.startPage;
        sessionObject.purl = "default.htm";
        sessionObject.curl = "default.htm";
        sessionObject.status = false;
    }
    if (typeof (sessionStorage) == 'undefined') {
        $("#hdnAuthenticate").val(JSON.stringify(sessionObject));
//        alert('Your browser does not support HTML5 sessionStorage. Try upgrading.');
    } else {
        sessionStorage.setItem("loggedInUser", JSON.stringify(sessionObject));
    }
}

function loadChildPage(pagename, isUrlSaved) {
    //pagename with htm
    if (isAuthenticated() == true) {
        
        if (isUrlSaved == true) {
            var obj = getSessionObject();
            obj.curl = pagename;
            setSessionObject(obj);
            $("#childPageContainer").load(obj.curl);
        }
        else $("#childPageContainer").load(pagename);
        loadHeaderMenu(pagename);
        $('#tblChild').hide();
    }
    else {
        $('#tblMenuHeader').hide();
        $('#lblLogedinUserGroup').text('');
        }
}

function loadHeaderMenu(pagename) {
    var auth = getSessionObject();
    loadGroups();
    switch (pagename) {
        case 'Menu.htm':
            $('#tblMenuHeader').show();
            $('#Home').hide();
            $('#Search').show();
            $('#Post').show();
            $('#Broadcast').show();
            break;

        case 'MyForum.htm':
            $('#tblMenuHeader').show();
            $('#Search').hide();
            $('#Home').show();
            $('#Post').show();
            $('#Broadcast').show();
            break;
        case 'NewPost.htm':
            $('#tblMenuHeader').show();
            $('#Post').hide();
            $('#Search').show();
            $('#Home').show();
            $('#Broadcast').show();
            break;
        case 'BroadcastSMS.htm':
            $('#tblMenuHeader').show();
            $('#Post').show();
            $('#Search').show();
            $('#Home').show();
            $('#Broadcast').hide();
            break;

        case 'ForumDetail.htm':
            $('#tblMenuHeader').show();
            $('#Home').show();
            $('#Search').show();
            $('#Post').show();
            $('#Broadcast').show();
            break;

        case 'ApproveMember.htm':
            $('#tblMenuHeader').show();
            break;
        case 'AssociateDetails.htm':
            $('#tblMenuHeader').show();
            break;
    }
}

function MasterAuthenticate(uid, pwd) {

    var len = 6; //represent length of char for userid/password        
    var r = (pwd !== "") && (uid !== "") ? true : false;
    var l = ((pwd.length >= len) && (uid.length >= len) ? true : false);
    var res = false;
    if (r == true) {
        if (l == true) res = true;
        else res = false;
    }
    else {
        //setError("Blank value not allowed !");
        res = false;
    }
    return res;
}

function isAuthenticated() {
    
    var auth = getSessionObject();

    if ((auth != undefined)) {       
        if ((auth.status == true) ) {
            if (MasterAuthenticate(auth.u, auth.p) == true) {
                return true;
            }
            else return false;
        }
        else return false;
    }
    else return false;
}

function redirectPage(strUrl) {
    //alert('Login test redirectPage' + strUrl);
    var page = getURLParamByName(strUrl, 'page') !== undefined ? "" : getURLParamByName(strUrl, 'page');
    //alert('Login test page '+ page);
    var reqid = ggetURLParamByName(strUrl, 'reqid') !== undefined ? "" : getURLParamByName(strUrl, 'reqid');
    var auth = getSessionObject();
    if ((page !== "") ||(page !== "login")){
        if (auth !== undefined) {
            if (auth.purl !== "") auth.purl = strUrl;
        }
        document.location.href = strUrl;
        setSessionObject(auth);
    }

    if ((reqid !== "") || (reqid !== "f")) {
    }
    else if (reqid !== "f") {
        alert('Login failed | Please try again ..');
    }
}

function getURLParamByName(strUrl,name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(strUrl);
    if (results == null)
        return "";
    else
        return results[1].replace(/:/gi, "%7c");
}
function setURLParamNameValue(strUrl, name) {
}

function loadGroups() {
    //alert('load groupList');
    var obj = getSessionObject();
    if (obj.groupList !== undefined) {

    }
}

    var u = $.trim($('#txtUID').val());
    var p = $.trim($('#txtPwd').val());
    var r = (p !== "") && (u !== "") ? true : false;
    function validteAuthenticate() {
        debugger;
    var len = 6; //represent length of char for userid/password
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
    $.ajax({
        type: "GET",
        url: '../Service/AssociateMobile.svc/associate/' + uid + '/' + pwd + '/login',
        contentType: 'application/json; charset=utf-8',
        success: function (result) {
            if (result !== undefined) {
                if (result == "") {
                    setError("Login failed ! Please try again !");
                }
                else {
                    var auth = new Object();
                    var IsflowCorrect = true;
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