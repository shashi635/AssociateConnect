
$(document).ready(function () {
    debugger;
    var uid = null;
    var page = 0;
    var size = 5;
    var topicid = 0;
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') && (auth != null) && (auth != '')) {
        uid = auth.u;
        topicid = auth.topicid;
    }
    else {
        window.location.href = "Login.htm";
    }
    $('#wlcmName').html('Welcome, ' + auth.Name);
    topicid = (getParameterByName("topicid") == '' ? topicid : getParameterByName("topicid"));
    GetTopics(uid, page, size, topicid);
    GetDetails(topicid);
    $('#btnReply').click(function () {
        $('#dvPostReply').toggle();
    });
    $('#btnPostReply').click(function () {
        saveReply(topicid);
    });
    $('#btnCancelReply').click(function () {
        $('#dvPostReply').hide();
        $('#taPostReply').html("");
    });
    function saveReply(tpcid) {
        var replyObj = new Object();
        replyObj.TopicID = tpcid;
        replyObj.TopicDesc = trim($("#taPostReply").val());

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
                $("#dvPostReply").hide();
                $("#dvsuccess").show(100).delay(3000).hide(400);
                $('#dvReplies').hide();
                GetDetails(topicid);
                //loadChildPage(reqPage, true);
            },
            error: function (e, xhr) {
                $("#dvError").show(100).delay(3000).hide(400);
            }
        });

    }
    AssociateInfo();
});
function GetDetails(id) {
    $.ajax({
        type: "GET",
        url: '../Service/associatemobile.svc/discussions/details/' + id,
        contentType: 'application/json; charset=utf-8',
        //   dataType: 'json',
        success: function (result) {
            if (result != undefined) { callbackDetails(result); }
        },

        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}

function callbackDetails(result) {

    var rply = "";
    var count = 0;
    $(result).each(function () {
        rply += '<div class="ui-bar ui-bar-b" id="header' + count + '" onclick="$("#body' + count + '").toggle();">' + this.CreatedByname + ' - ' + this.PostDateTimeString + ':</div>            <div class="ui-body ui-body-d" id="body' + count + '"><small id="reply' + count + '">' + this.DetailDesc + '</small></div>            <br />';
        count++;
    });
    $('#lblReplies').html(count);
    $('#dvReplies').html("");
    $('#dvReplies').append(rply);
    $('#dvReplies').show();

    //             var detailData = result;
    //            
    //                var acc = $('#accordion').empty();
    //                
    //                $(detailData).each(function () {
    //                 if (this.CreatedByname == null){this.CreatedByname='Unknown';}
    //                    acc.append($("<h3>").append($("<a>").attr("href", "#").html(this.DetailDesc.substring(0, 25) + '.....' + '     ' + this.CreatedByname + '  Date: ' + this.PostDateTimeString )));                   
    //                    acc.append($("<div>").append($("<p>").html(this.DetailDesc)));

    //                });

    //                $("#accordion").accordion({
    //                    fillSpace: true,
    //                    collapsible: true,                    
    //                    header: "h3",
    //                    autoHeight: true,
    //                    active: false
    //                });


    //                $('.accordion .head').click(function () {
    //                    $(this).next().toggle('slow');
    //                    return false;
    //                }).next().hide();


    //                $('#accordion .head').toggle('down');


}


function GetTopics(uid, page, size, topicid) {

    $.ajax({
        type: "GET",
        url: '../Service/associatemobile.svc/discussion/' + topicid,
        contentType: 'application/json; charset=utf-8',
        //  dataType: 'json',
        success: function (result) {
            result.uid = uid;
            callbackTopic(result);
        },
        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}
function errorcallback(e, xhr) {
    alert('Getting error to fetch Data: ' + e.responseText);
}
function callbackTopic(result) {

    var topicData = result;
    if (topicData != null) {
//        var topic_text = '';
//        topic_text = topic_text + '<tr><td colspan="4" style="width:100%;">&nbsp;</td></tr>';
//        topic_text = topic_text + '<tr class="header1">';
//        topic_text = topic_text + '<td colspan="2" align="left" width="60%"><label class="topicHeader">' + topicData.TopicHeader.substr(0, 40) + '..</label></td>';
//        topic_text = topic_text + '<td  style=""width:20%; text-align:center;"><label class="topicHeader1">' + topicData.Category.CategoryDesc + '</label></td>';
//        topic_text = topic_text + '<td  style=""width:20%; text-align:center;"><label class="topicHeader2"><a  href="#" id="lnktopicid' + topicData.TopicID + '-' + topicData.CreatedBy + '" class="linkAssociateNameMenu" >' + topicData.CreatedByname + '</a></label></td>';
//        topic_text = topic_text + '</tr>';
//        topic_text = topic_text + '<tr>';
//        topic_text = topic_text + '<td colspan="4" style="width:100%; font:calibri;"><label class="topicHeader2">' + topicData.TopicDesc + '</label></td>';
//        topic_text = topic_text + '</tr>';
//        topic_text = topic_text + '<tr style="background-color:#EFEFEF; vertical-align:bottom;">';
//        topic_text = topic_text + '<td align="left" style="width:30%;"><label class="topicFooter1">Replies : ' + topicData.CommentCount + '</label></td>';
//        topic_text = topic_text + '<td align="center" colspan="2"><label class="topicFooter2">Date:' + topicData.PostDateTimeString + '</label></td>';
//        topic_text = topic_text + '<td align="right" style="width:20%; font:calibri;"><img alt="Reply" src="Images/reply.bmp" class="imgMenuBtn" onclick="replyToPostQueryDetails(\'forumDetailDivReplyToPost\',\'' + topicData.TopicID + '\');" /></td>';
//        topic_text = topic_text + '</tr>';
//        topic_text = topic_text + '<tr style="background-color:#F2F2F2;">';
//        topic_text = topic_text + '<td colspan="4" align="left" style="width:100%;"> <hr> </td>';
//        topic_text = topic_text + '</tr>';

//        $("#topic").html($(topic_text));
//        $(".linkAssociateNameMenu").click(function (e) {
//            showAssociatePopUpdiv(e);
//        });

        $('#topicHeader').html(topicData.TopicHeader);
        $('#lblcategory').html(topicData.Category.CategoryDesc);
        var linkName = '<a href="#popupLogin" data-rel="popup" data-position-to="window" data-role="button" data-inline="true" data-icon="check" data-theme="a" data-transition="flip" data-position-to="window" onclick="getAssociateInfo(' + topicData.CreatedBy + ');">' + topicData.CreatedByname + '</a>';
        $('#lblCreatedBy').html(linkName + " - " + topicData.PostDateTimeString);
        $('#lblTopic').html(topicData.TopicDesc);
        $('#lblReplies').html(topicData.CommentCount);

    }
}

function replyToPostQueryDetails(cntnrDiv, tpid) {
    ShowPopupReplyToPost(cntnrDiv, 'TopicID:' + tpid, 'ForumDetail.htm');

}

