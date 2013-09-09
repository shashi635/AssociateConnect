
$(document).ready(function () {
    $('#ingPageLoading').show();
    var catid = 0;
    var groupid = 0;
    var uid = '';
    var page = 0;
    var size = 5;
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') && (auth != null) && (auth != '')) {
        uid = auth.u;
    }
    else {
        window.location.href = "Login.htm";
    }
    $('#wlcmName').html('Welcome, ' + auth.Name);
    PupolateUIValues();
    $("#ddlGroup").change(function () {
        if ($("#ddlGroup").val() != "") {
            groupid = $("#ddlGroup").val();
        } else { groupid = 0; }
    });

    $("#ddlCategory").change(function () {
        if ($("#ddlCategory").val() != "") {
            catid = $("#ddlCategory").val();
        }
        else { catid = 0; }
    });

    $("#btnSubmit").click(function () {
        //$("#imgBusy").show();
        if (($("#ddlCategory").val() != "") || ($("#ddlGroup").val() != "")) {
            onGetTopics(page, size, uid, catid, groupid, callbackTopic, errorcallback);
        }
        else {
            $("#lblerror").text("Please Select search criteria...").attr("style", "color:red;").show(100).delay(3000).hide(400);
        }

        //$("#imgBusy").hide();
    });

    $('#btnReset').click(function () {
        reset();
    });

    function reset() {
        PupolateUIValues();
        $('#ulDiscussions').html("");
        $('#dvresult').hide();
    }
    function PupolateUIValues() {
        GetCategory();
        GetGroup();
    }

    function GetCategory() {
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/discussions/categories',
            contentType: 'application/json; charset=utf-8',
            success: function (result) {

                if (result != null)
                    bindNonDictionaryDdlList('ddlCategory', result, '', true, 'CategoryDesc', 'CategoryID', true);
            },
            error: function (e, xhr) {
                errorcallback(e, xhr);
            }
        });
    }

    function GetGroup() {
        var asid = 0;
        if ((auth != 'undefined') || (auth != null) || (auth != ''))
            asid = parseInt(auth.AssociateID);

        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/discussions/groups/uid/' + asid.toString(),
            contentType: 'application/json; charset=utf-8',
            success: function (result) {

                if (result != null)
                    bindNonDictionaryDdlList('ddlGroup', result, '', true, 'GroupDesc', 'GroupID', true);
                $('#ingPageLoading').hide();
            },
            error: function (e, xhr) {
                errorcallback(e, xhr);
                $('#ingPageLoading').hide();
            }
        });
    }


});
//-->


    function onGetTopics(page, size, uid, catid, groupid, callbackTopic, errorcallback) {

        $.ajax({
            type: "GET",
            url: '../Service/associatemobile.svc/discussions/' + catid + '/' + groupid,
            contentType: 'application/json; charset=utf-8',
            // dataType: 'json',
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
//Question Replies Last Comment Date 
function callbackTopic(result) {
    var topicData = null;
    topicData = result;
    var topic_text = '';
    var strtopics = "";
    $('#dvresult').hide();
    topic_text = topic_text + '<tr style="background-color: #4B582C; height:4px;"><td colspan="4"/></tr>';
    topic_text = topic_text + '<tr  style="background-color: #EAF3D6;"><td colspan="2"><img alt="Discussions.." src="Images/discussionList.bmp"> </td>';
    topic_text = topic_text + '<td colspan="2" style="text-align:right; vertical-align:bottom;" class="topicHeader"><font color="#66B035" size=5><b>' + result.length + ' </b></font> discussions </td></tr>';
    topic_text = topic_text + '<tr style="background-color: #4B582C; height:1px;"><td colspan="4"/></tr>';
    if (topicData != '') {
        topic_text = topic_text + '<tr style="width:90%; height:35% background-color:#F7F7F7">';
        topic_text = topic_text + '<td style="width:50%;" class="topicHeader3">Topic</td>';
        topic_text = topic_text + '<td style="width:10%;" class="topicHeader3">Replies </td>';
        topic_text = topic_text + '<td  colspan="2" style="width:40%; text-align:left; padding-left:4px;" class="topicHeader3">Owner/Date</td>';        
        topic_text = topic_text + '</tr>';
        topic_text = topic_text + '<tr style="background-color: #4B582C; height:1px;"><td colspan="4"/></tr>';
        topic_text = topic_text + '<tr><td colspan="4"><table id="tblSubTopicDetails" style="width:100%;"';
        for (i = 0; i < topicData.length; i++) {

            strtopics += '<li data-icon="false" ><a href="ForumDetail.htm?topicid=' + topicData[i].TopicID + '" rel="external" data-transition="pop" >';
            strtopics += '<h3 class="Topic">' + topicData[i].TopicHeader + '</h3>';
            strtopics += '<p ><strong>' + topicData[i].Category.CategoryDesc + '</strong></p>';
            strtopics += '<p >' + topicData[i].CreatedByname + ' - ' + topicData[i].PostDateTimeString + '</p>';
            strtopics += '</a> <span class="ui-li-count">' + topicData[i].CommentCount + '</span>';
            strtopics += '</li>';

            topic_text = topic_text + '<tr style="width:90%; height:25%;">';
            topic_text = topic_text + '<td align="left" style="width:50%"><div id="topicabbr" class="topicHeader" onclick="javascript:navTopic(' + topicData[i].TopicID + ');">' + topicData[i].TopicHeader.substr(0, 40) + '..' + '<br/><font color="#286673">' + topicData[i].Category.CategoryDesc + '</font></div></td>';
            if (topicData[i].CommentCount != 0)
            { topic_text = topic_text + '<td align="left" style="width:10%"><div id="comment" class="LinkNormal" onclick="javascript:navTopic(' + topicData[i].TopicID + ');"><font color="#66B035" size=4><b>' + topicData[i].CommentCount + '</b></font></div> </td>'; }
            else { topic_text = topic_text + '<td align="left" style="width:10%"><div id="comment" ><font color="#66B035" size=4><b>' + topicData[i].CommentCount + '</b></font></div> </td>'; }
            topic_text = topic_text + '<td ><label class="topicHeader2"><a  href="#" id="lnktopicid' + topicData[i].TopicID + '-' + topicData[i].CreatedBy + '" class="linkAssociateNameMenu" >' + topicData[i].CreatedByname + '</a><br/>' + topicData[i].PostDateTimeString + '</label></td>';
            topic_text = topic_text + '<td style="text-align:center;"><img alt="Reply" class="imgMenuBtn" src="Images/reply.bmp" onclick="ShowPopupReplyToPost(\'popupDivMyForum\',\'TopicId:' + topicData[i].TopicID + '\');" /></td>';
            topic_text = topic_text + '</tr>';
        }
        topic_text = topic_text + '</table></td></tr>';
    }
    if (topicData.length < 1) {
        $('#noResult').show(100).delay(3000).hide(400);
    }
    else {
        $('#dvresult').show();
    }
    $('#ulDiscussions').html("");
    $('#ulDiscussions').html(strtopics);
    $('#ulDiscussions').listview('refresh');

    $("#topic").html($(topic_text));
    //alert('tr even =>' + $("#tblSubTopicDetails tr:even").length + ' tr odd => ' + $("#tblSubTopicDetails tr:odd").length);
    $("#tblSubTopicDetails tr:even").addClass("topicDetailEvenRows");
    $("#tblSubTopicDetails tr:odd").addClass("topicDetailOddRows");

    $(".linkAssociateNameMenu").click(function (e) {
        showAssociatePopUpdiv(e);
    });
}

function navTopic(id) {
    $('#forumval').find('#htopic').val(id);
    var at = getSessionObject();
    at.topicid = id;
    setSessionObject(at);
    loadChildPage('ForumDetail.htm', true);
}
