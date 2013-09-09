// Trim functions...
function trim(stringToTrim) {
    if (stringToTrim != null)
        return stringToTrim.replace(/^\s+|\s+$/g, "");
    else
        return "";
}
////////////////////////////////////////
function bindNonDictionaryDdlList(cntrlToBind, options, defaultVal, addBlank, textSource, valueSource, showToolTip) {

    var cntrl = $("#" + cntrlToBind + "");
    cntrl[0].selectedIndex = 0;
    cntrl.selectmenu("refresh");

    if (cntrl.length > 0) {
        var ctr = cntrl[0].options.length;
        var cntrWidth = cntrl[0].style.width;
        var maxTextLen = Math.round(parseInt(cntrWidth.replace("px", "")) * .13);

        for (var i = 0; i < ctr; i++) {
            cntrl[0].remove(0);
        }

        if ((options != null) && (options != undefined)) {
            if (addBlank) {
                var option = document.createElement("option");
                option.text = "";
                option.value = "";
                cntrl[0].add(option);
            }
            for (var i = 0; i < options.length; i++) {
                var option = document.createElement("option");
                eval("option.text = options[" + i + "]." + textSource);
                eval("option.value = options[" + i + "]." + valueSource);

                if (option.value == defaultVal) {
                    option.selected = true;
                }

                if ((trim(option.text.toString()).length) > maxTextLen)
                    option.setAttribute('title', option.text);
                else if (showToolTip)
                    option.setAttribute('title', option.text);

                cntrl[0].add(option);
            }
            //cntrl[0].val(options[0].valueSource);
            cntrl[0].selectedIndex = 0;
            cntrl.selectmenu("refresh");
        }
    }
}
////////////////////////////
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null)
        return "";
    else
        return results[1].replace(/:/gi, "%7c");
}
/////////////////////////////////
(function ($) {
    $.fn.selected = function (fn) {
        return this.each(function () {
            var clicknum = 0;
            $(this).click(function () {
                clicknum++;
                if (clicknum == 2) {
                    clicknum = 0;
                    fn();
                }
            });
        });
    }
})(jQuery);
///////////////////////////////////
function ShowPopupReplyToPost(cntnrDivID, topicID, requestedPage) {     
    var cntnr = $("#" + cntnrDivID + "");
    cntnr.html("");    
    var popupElements = '';
    popupElements += '<div id="childPopUpDiv" class="jqpopup">';
    popupElements += '<table class="jqpopupTable"><tr class="header4"><td colspan="2" style="text-align:right;">';        
    popupElements += '<img src="./Images/Close.jpg" id="imgPopupClose" alt="Close" style="height:15px;" ';
    popupElements += 'onclick="closeReplyToPost(\'' + cntnrDivID + '\')"/></td></tr><tr><td  style="padding-left:25px; width:50%;">';
    popupElements += '<label id="lblStatus" class="headerText1">Post your Reply.....</label>';
    popupElements += '</td><td style="text-align:right;"><img src="./Images/indicator.gif" id="imgPopUpBusy"  style="height:12px; display:none;"';
    popupElements += '</td></tr><tr><td colspan="2" style="padding-left:15px; text-align:center;" >';
    popupElements += '<textarea cols="3" rows="10" id="txtReplyToPost" class="jqtextarea"></textarea>';
    popupElements += '</td></tr><tr><td style="text-align:right; padding-right:2px;">';
    popupElements += '<input type="button" value="Submit" class="btnDefault1" id="btnReplySubmit" style="width:40%;"';
    popupElements += '" onclick="saveReplyToPost(\'' + requestedPage + '\',\'' + topicID + '\')" name="btnsReplyToPostPopuUp"/></td><td style="text-align:left;">';
    popupElements += '<input type="button" style="width:40%;" value="Reset" class="btnDefault1" onclick="ResetReplyToPost();" name="btnsReplyToPostPopuUp"/>';
    popupElements += '</td></tr></table></div>';

    
    cntnr.append($(popupElements));
    cntnr.addClass("jqpopupBackGround");
    centerPopup('childPopUpDiv');
    
    //SetDivLocation('cntnrDivID', srcid);
    cntnr.show();
    $("#childPopUpDiv").addClass("jqpopup");

}

function ResetReplyToPost() {
    $("#txtReplyToPost").val("");
    $("#txtReplyToPost")[0].disabled = false;
    $("#imgPopUpBusy").hide();
    for (i = 0; i < $("input[name=btnsReplyToPostPopuUp]").length; i++) {
        $("input[name=btnsReplyToPostPopuUp]")[i].disabled = false;
    }
}

function saveReplyToPost(reqPage,topicID) {
    if (trim($("#txtReplyToPost").val()) != "") {
        $("#imgPopUpBusy").show();
        $("#txtReplyToPost")[0].disabled = true;
        for (i = 0; i < $("input[name=btnsReplyToPostPopuUp]").length; i++) {
            $("input[name=btnsReplyToPostPopuUp]")[i].disabled = true;
        }
        var list = new Array();
        list = topicID.split(":");
        var topicID = list[list.length - 1];
        updateReplyToPost(reqPage,topicID);
    }
}

function closeReplyToPost(divToClose) {
    var cntnr = $("#" + divToClose + "");
    $("#imgPopUpBusy").hide();   
    cntnr.hide();
}


function centerPopup(cntnrDivID) {
    var cntnr = $("#" + cntnrDivID + "");
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    var popupHeight = cntnr.height();
    var popupWidth = cntnr.width();
    
    cntnr.css({
        "position": "absolute",
        "top": windowHeight / 2 - popupHeight / 2,
        "left": windowWidth / 2 - popupWidth / 2
    });

}

function SetDivLocation(elementToDisplay, elementToReference) {
    elementToDisplay.style.position = 'absolute';
    var pos = getElementPosition(elementToReference);

    if (pos.width - elementToDisplay.offsetWidth > pos.left + elementToReference.offsetWidth) {
       if (elementToDisplay.offsetWidth != 0)
           elementToDisplay.style.left = elementToReference.offsetWidth + (elementToDisplay.offsetWidth / 2);
       else
           elementToDisplay.style.left = elementToReference.offsetWidth + 81;
    }
    else if (pos.width > (elementToDisplay.offsetWidth + 10))

        elementToDisplay.style.left = (pos.left - elementToDisplay.offsetWidth) + 5;
    else
        elementToDisplay.style.left = 0;

    if ((pos.height + pos.scrollTop - elementToDisplay.offsetHeight) > (pos.top + (elementToReference.offsetHeight / 2))) {
        if (elementToDisplay.offsetHeight != 0)
            elementToDisplay.style.top = pos.top - elementToDisplay.offsetHeight;
        else
            elementToDisplay.style.top = pos.top - 112;
    }
    else if (pos.height + pos.scrollTop - elementToDisplay.offsetHeight > 0) {
        if (elementToDisplay.offsetHeight != 0)
            elementToDisplay.style.top = pos.top - elementToDisplay.offsetHeight;
        else
            elementToDisplay.style.top = pos.top - 112;
    }
    else
        elementToDisplay.style.top = 0;

}

function getElementPosition(offsetTrail) {
    var offsetLeft = 0;
    var offsetTop = 0;
    while (offsetTrail) {
        offsetLeft += offsetTrail.offsetLeft;
        offsetTop += offsetTrail.offsetTop;
        offsetTrail = offsetTrail.offsetParent;
    }
    if (navigator.userAgent.indexOf('Mac') != -1 && typeof document.body.leftMargin != 'undefined') {
        offsetLeft += document.body.leftMargin;
        offsetTop += document.body.topMargin;
    }

    var ScrollTop = document.body.scrollTop;
    if (ScrollTop == 0) {
        if (window.pageYOffset)
            ScrollTop = window.pageYOffset;
        else
            ScrollTop = (document.body.parentElement) ? document.body.parentElement.scrollTop : 0;
    }

    return { left: offsetLeft, top: offsetTop, width: document.body.offsetWidth, height: document.documentElement.offsetHeight, scrollTop: ScrollTop };
}



function updateReplyToPost(reqPage,tpcid) {
    var replyObj = new Object();
    replyObj.TopicID = tpcid;
    replyObj.TopicDesc = trim($("#txtReplyToPost").val());
        
    var auth = getSessionObject();

    if ((auth != 'undefined') || (auth != null) || (auth != '')) {
        replyObj.CreatedBy = parseInt(auth.AssociateID);
    }
    else
        replyObj.CreatedBy = null;

    $.ajax({
        type: "PUT",
        url: "../service/associatemobile.svc/discussions/ReplyToPost",
        data: JSON.stringify(replyObj),
        contentType: "application/json; charset=utf-8",
        success: function (result) {
            $("#imgPopUpBusy").hide();
            $(".jqpopupBackGround").hide();
            loadChildPage(reqPage, true);
        },
        error: function (e, xhr) {            
        }
    });

}

function showAssociatePopUpdiv(sourceElement) {

    var list = new Array();
    var id = sourceElement.target.id;
    list = id.split("-");
    var assoID = list[list.length - 1];

    $.ajax({
        type: "GET",
        url: '../service/associatemobile.svc/associateDetails/assoID/' + assoID,
        contentType: 'application/json; charset=utf-8',
        success: function (result) {
            if (result != null)
                generateAssociateDetails(result, sourceElement);
        },
        error: function (e, xhr) {
        }
    });


}

function generateAssociateDetails(assRec, sourceElement) {
    var imgPath = "";    
    if (assRec.Gender.substr(0, 1).toUpperCase() == "F")
        imgPath = "Images/femaleIcon.bmp";
    else
        imgPath = "Images/maleIcon.bmp";

    var strElement = '';
    strElement += '<table cellspacing="0" style="width:99%; background-color:#D7E9EE"><tr class="header6"><td colspan="2" style="width:90%;"></td>';
    strElement += '<td style="text-align:right;"><img alt="Reply"  src="Images/close.bmp" onclick="closeAssPopUpDiv();"/></td></tr>';
    strElement += '<tr><td colspan="3" style="text-align:left; padding-left:3px;"><img alt="UserIcon" class="imgMenustyle2" src=\'' + imgPath + '\'/>';
    strElement += '&nbsp;&nbsp;<label class="headerText2">' + assRec.FirstName + ' ' + assRec.LastName + '</label></td></tr>';
    strElement += '<tr style="height:3px;"><td colspan="3"/></tr><tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Associate ID:';
    strElement += '</label></td><td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.AssociateID + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Designation: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.Designation + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Location: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.Location + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">DOJ: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.DOJ + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Project: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.ProjectName + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Mobile: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.Mobile + '</label></td></tr>';
    strElement += '<tr><td style="text-align:right; padding-right:2px; width:45%;"><label class="headerText3">Email: </label></td>';
    strElement += '<td colspan="2" style="text-align:left; padding-left:3px;"><label class="bodyText1">' + assRec.email + '</label></td></tr>';
    strElement += '</table>';

    $("#divAssoDetails").html($(strElement));
    //---------------------------------------------------
    var x = $("#divAssoDetails")[0];
    var y = $("#" + sourceElement.target.id + "")[0];    
    SetDivLocation(x, y);
    $("#divAssoDetails").show("bounce");
}

function closeAssPopUpDiv() {
    $("#divAssoDetails").hide("clip");
}



// Sets the value for the given key in the defined storage.
function SetSessionStorage(key, value) {
    try {
        if (typeof (sessionStorage) != 'undefined') {
            sessionStorage.removeItem(key);
            if (value != '') {// Empty string means it just removes it from the storage.
                sessionStorage.setItem(key, value);
            }
        }
        else
            setCookie(key, value, 1);
    } catch (e) {
        alert("There was an error accessing session storage");
    }
}
// Gets the value for the given key from the defined storage.
function GetSessionStorage(key) {
    try {
        if (typeof (sessionStorage) != 'undefined')
            return sessionStorage.getItem(key);
        else
            return getCookie(key);
    } catch (e) {
        alert("There was an error accessing session storage");
    }
    return null;
}
function RemoveAllStorageValues() {
    if (typeof (sessionStorage) != 'undefined')
        sessionStorage.clear();
    else
        setCookie("ACProfile", "");
}

function getAssociateInfo(associateID) {
    $.ajax({
        type: "GET",
        url: '../service/AssociateMobile.svc/associateDetails/assoID/' + associateID,
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (result) {
            populateAssociateInfo(result);
        },
        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}

function populateAssociateInfo(result) {
    $('#dvAssociateInfo').html('');
    if (result) {
        var strdetails = '<h3>Associate Information:</h3>';
        strdetails += '<small><div class="ui-grid-a">';
        strdetails += '<div class="ui-block-a">Name</div>';
        strdetails += '<div class="ui-block-b">' + result.FirstName + ' ' + result.FirstName + '</div>';
        strdetails += '<div class="ui-block-a">Associate ID</div>';
        strdetails += '<div class="ui-block-b">' + result.AssociateID + '</div>';
        strdetails += '<div class="ui-block-a">Designation</div>';
        strdetails += '<div class="ui-block-b">' + result.Designation + '</div>';
        strdetails += '<div class="ui-block-a">Location</div>';
        strdetails += '<div class="ui-block-b">' + result.Location + '</div>';
        strdetails += '<div class="ui-block-a">Project</div>';
        strdetails += '<div class="ui-block-b">' + result.ProjectName + '</div>';
        strdetails += '<div class="ui-block-a">Mobile</div>';
        strdetails += '<div class="ui-block-b">' + result.Mobile + '</div>';
        strdetails += '<div class="ui-block-a">Email</div>';
        strdetails += '<div class="ui-block-b">' + result.email + '</div>';
        strdetails += '</div></small>';
        $('#dvAssociateInfo').html(strdetails);
    }
    else
        $('#dvAssociateInfo').html("No Details found");
//    $('#dvAssociateInfo').html("No Details found");
//    $('#dvAssociateInfo').collapsibleset();
}

function getAssociateInfo(associateID) {
    $.ajax({
        type: "GET",
        url: '../service/AssociateMobile.svc/associateDetails/assoID/' + associateID,
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (result) {
            populateAssociateInfo(result);
        },
        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}

function populateAssociateInfo(result) {
    if (result) {
        $('#dvimg').html('');
        if (result.Gender.trim().toLowerCase() == "female") {
            $('#dvimg').html('<img src="images/femaleIcon.bmp" width="50%" />');
        }
        else {
            $('#dvimg').html('<img src="images/maleIcon.bmp" width="50%" />');
        }
        $('#nm').text(result.FirstName + ' ' + result.LastName);
        $('#ai').text(result.AssociateID);
        $('#de').text(result.Designation);
        $('#lo').text(result.Location);
        $('#pr').text(result.ProjectName);
        $('#mo').text(result.Mobile);
        $('#em').text(result.email);

    }
}