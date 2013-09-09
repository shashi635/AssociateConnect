$(document).ready(function () {
    var postDivCollapsed = true;
    var currentPostGroup = null;
    var currentTopicID = null;
    $('#ingPageLoading').show();
    var uid = null;
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') && (auth != null) && (auth != '')) {
        uid = parseInt(auth.AssociateID);
    }
    else {
        window.location.href = "Login.htm";
    }
    $('#wlcmName').html('Welcome, ' + auth.Name);
    //alert('chk..');
    $("#divPostQuery").slideUp("fast");
    LoadDropDownValues();

    ////////////////////////////////////////////////////////////
    $("#ddlPostGroup").change(function () {
        if (postDivCollapsed) {
            if ($("#ddlPostCategory").val() != "")
                ToggleView();
        }

    });
    ////////////////////////////////////////////////////////////
    $("#ddlPostCategory").change(function () {
        if (postDivCollapsed) {
            if ($("#ddlPostGroup").val() != "")
                ToggleView();
        }
    });
    ////////////////////////////////////////////////////////////
    function ToggleView() {
        if (postDivCollapsed) {
            postDivCollapsed = false;
            $("#imgcollapse")[0].setAttribute("src", "../Mobile/Images/dwn_arrow.jpg");
        }
        else {
            postDivCollapsed = true;
            $("#imgcollapse")[0].setAttribute("src", "../Mobile/Images/side_arrow.jpg");
        }
        $("#divPostQuery").slideToggle("slow");
    }
    ////////////////////////////////////////////////////////////
    $("#imgcollapse").click(function () {
        ToggleView();
    });
    ////////////////////////////////////////////////////////////
    $('#btnReset').click(function () {
        reset();
    });
    ////////////////////////////////////////////////////////////
    $("#btnSubmit").click(function () {

        if ($("#ddlCategory").val() == "") {
            $("#lblresult").text("Please Select a Category.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        }
        else {
            if ($("#ddlGroup").val() == "")
                $("#lblresult").text("Please Select a Group.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else {
                if ($("#txtSubject").val() == "")
                    $("#lblresult").text("Please Provide a Subject to your Query.").attr("style", "color:red;").show(100).delay(3000).hide(400);
                else {
                    if ($("#taQuestion").val() == "")
                        $("#lblresult").text("Please write a description for your Query.").attr("style", "color:red;").show(100).delay(3000).hide(400);
                    else {
                        $("#lblresult").hide();
                        //$("#lblStatus").text("Post your Query.....").attr("style", "color:blue;");
                        //$("#btnPostQuery")[0].disabled = true;
                        //$("#imgBusy").show();

                        var newPost = new Object();
                        newPost.TopicHeader = $("#txtSubject").val();
                        newPost.IsParent = 1;
                        newPost.CreatedBy = parseInt(uid);
                        newPost.GroupID = parseInt($("#ddlGroup").val());
                        currentPostGroup = newPost.GroupID;
                        newPost.TopicDesc = $("#taQuestion").val();

                        var Category = new Object();
                        Category.CategoryID = parseInt($("#ddlCategory").val());

                        newPost.Category = Category;

                        SaveQuery(newPost);
                    }
                }
            }
        }
    });
    ////////////////////////////////////////////////////////////
    function SaveQuery(newPost) {
        $.ajax({
            type: "PUT",
            url: "../service/associatemobile.svc/discussions/newPost",
            data: JSON.stringify(newPost),
            contentType: "application/json; charset=utf-8",
            success: OnSaveNewPost,
            error: OnError
        });
    }
    ////////////////////////////////////////////////////////////
    function OnSaveNewPost(result) {
        $("#lblresult").text("Post Successful.").attr("style", "color:green;").show(100).delay(3000).hide(400);
        reset();
        currentTopicID = result;
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/associate/assocaitepergroup/' + currentPostGroup,
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                if (result != null)
                    createSMSObject(result);
            },
            error: function (e, xhr) {
                debugger;
            }
        });
    }

    function reset() {
        LoadDropDownValues();
        $("#txtSubject").val("");
        $("#taQuestion").val("");
    }
    ////////////////////////////////////////////////////////////
    function OnError(e, xhr) {
        $("#lblresult").text("Post UnSuccessful.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        debugger;
    }
    ////////////////////////////////////////////////////////////
    function createSMSObject(list) {

        var smsObj = new Object();
        smsObj.smsBody = 'A new topic has been posted in AssociateConnect on ' + $("#ddlPostCategory option:selected").text() + '. Please logon to https://massocaiteconnect.cognizant.com/mobile.default.htm for more details.';
        var strtolist = '91';
        for (i = 0; i < list.length; i++) {
            if (i <= (list.length - 2))
                strtolist += list[i].Mobile + ';91';
            else
                strtolist += list[i].Mobile;
        }
        smsObj.toList = strtolist;
        sendSMS(smsObj);

    }
    ////////////////////////////////////////////////////////////
    function sendSMS(smsObj) {
        $.ajax({
            type: "PUT",
            url: "../service/associatemobile.svc/SMS/Broadcast",
            data: JSON.stringify(smsObj),
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                if (result != "Sent Successfully..")
                    alert('Failed sending sms...');
                $("#btnPostQuery")[0].disabled = false;
                $("#imgBusy").hide();
                $("#ddlPostGroup").val("");
                $("#ddlPostCategory").val("");
                $("#txtQueryHeader").val("");
                $("#txtPostQuery").val("");

            },
            error: function (e, xhr) {
                alert('Failed sending sms...');
            }
        });
    }
    ////////////////////////////////////////////////////////////
    function LoadDropDownValues() {
        GetCategoryValues();
        GetGroupValues();
        
    }
    ////////////////////////////////////////////////////////////
    function GetCategoryValues() {
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/discussions/categories',
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                if (result != null)
                    bindNonDictionaryDdlList('ddlCategory', result, '', true, 'CategoryDesc', 'CategoryID', true);
            },
            error: function (e, xhr) {
                debugger;
            }
        });
    }
    ////////////////////////////////////////////////////////////
    function GetGroupValues() {
        if (uid == null)
            uid = 0;
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/discussions/groups/uid/' + uid.toString(),
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                if (result != null)
                    bindNonDictionaryDdlList('ddlGroup', result, '', true, 'GroupDesc', 'GroupID', true);
                $('#ingPageLoading').hide();
            },
            error: function (e, xhr) {
                $('#ingPageLoading').hide();
            }
        });
    }
    
    ////////////////////////////////////////////////////////////
    // Trim functions...
    function trim(stringToTrim) {
        if (stringToTrim != null)
            return stringToTrim.replace(/^\s+|\s+$/g, "");
        else
            return "";
    }
});