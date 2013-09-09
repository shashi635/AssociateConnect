$(document).ready(function () {

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
    LoadDropDownValues();

    ////////////////////////////////////////////////////////////
    $("#btnReset").click(function () {
        reset();
    });
    ////////////////////////////////////////////////////////////
    $("#btnSubmit").click(function () {


        if ($("#ddlGroup").val() == "")
            $("#lblresult").text("Please Select a Group.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        else {
            if ($("#taMessage").val() == "")
                $("#lblresult").text("Please write a message to broadcast.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else {

                //$("#lblresult").text("Broadcast updates.....").attr("style", "color:blue;");
                GetGroupMembers($("#ddlGroup").val());
            }
        }

    });
    ////////////////////////////////////////////////////////////
    function GetGroupMembers(selGrp) {
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/associate/assocaitepergroup/' + selGrp,
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                var newArray = new Array();
                if (result != null)
                    if ($("#chkAll").is(':checked') == true) {
                        createSMSObject(result);
                    }
                    else {
                        for (var i = 0; i < result.length; i++) {
                            if ($('#' + result[i].AssociateID).is(':checked') == false) {
                                //alert(result[i].FirstName);
                                newArray.push(result[i].AssociateID);
                            }

                        }

                        for (var i = 0; i < newArray.length; i++) {
                            result = RemoveArrayItem(result, newArray[i]);
                        }
                        //                        for (var i = 0; i < result.length; i++) {
                        //                            alert(result[i].FirstName);
                        //                        }
                        createSMSObject(result);
                    }

            },
            error: function (e, xhr) {
                debugger;
            }
        });
    }
    function RemoveArrayItem(array, associateID) {
        for (var i = 0; i < array.length; i++) {
            if (array[i].AssociateID == associateID) {
                array.splice(i, 1);
                break;
            }

        }
        return array;
    }


    ////////////////////////////////////////////////////////////
    function OnError(e, xhr) {
        debugger;
    }
    ////////////////////////////////////////////////////////////
    function createSMSObject(list) {

        var smsObj = new Object();
        smsObj.smsBody = $("#taMessage").val();
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
                    $("#lblresult").text("Message Sending Failed.").attr("style", "color:red;").show(100).delay(3000).hide(400);
                reset();
            },
            error: function (e, xhr) {
                $("#lblresult").text("Message Sending Failed.").attr("style", "color:red;").show(100).delay(3000).hide(400);
                reset();
            }
        });
    }
    ////////////////////////////////////////////////////////////
    function reset() {
        LoadDropDownValues();
        $("#taMessage").val("");
        $('#dvMembers').hide('slow');
        $('#tblMemberList').find("tr:gt(0)").remove();
    }
    ////////////////////////////////////////////////////////////
    function LoadDropDownValues() {
        GetGroupValues();
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

    $('#ddlGroup').change(function () {
        $('#dvMembers').hide('slow');
        $('#ingPageLoading').show();
        $('#tblMemberList').find("tr:gt(0)").remove();
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/associate/assocaitepergroup/' + $(this).val(),
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                if (result != null)
                    for (var i = 0; i < result.length; i++) {
                        $('#tblMemberList').append('<tr><td style="width:30%"><div class="ui-checkbox"><input id="' + result[i].AssociateID + '" type="checkbox" /></div></td><td>' + result[i].FirstName + ' ' + result[i].LastName + '</td></tr>')
                    }
                $('#dvMembers').show('slow');
                $('#chkAll').prop('checked', true);
                $('#tblMemberList tr td input[type="checkbox"]').prop('checked', $('#chkAll').prop('checked'));
                $('#ingPageLoading').hide();
            },
            error: function (e, xhr) {
                $('#ingPageLoading').hide();
            }
        });
    });
    $('#chkAll').change(function () {
        $('#tblMemberList tr td input[type="checkbox"]').prop('checked', $(this).prop('checked'));
    });



});