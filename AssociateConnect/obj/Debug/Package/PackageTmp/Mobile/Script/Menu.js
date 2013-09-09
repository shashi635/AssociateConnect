
$(document).ready(function () {
    //$('#ingPageLoading').show();
    var catid = 0;
    var groupid = 1;
    var groupname = 'MLIAD';
    var uid = '';
    //isAuthenticated();
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') && (auth != null) && (auth != '')) {
        debugger;
        uid = auth.u;
    }
    else {
        window.location.href = "Login.htm";
    }

    $('#wlcmName').html('Welcome, ' + auth.Name);
    function isAuthenticated() {
        var auth = GetSessionStorage("ACProfile");
        //var auth = eval("(" + $("#hdnAuthenticate").val() + ')');
        if ((auth !== undefined) && (auth.status == true)) {
            $('#hlkPostIssue').click(function () {
                var auth = getSessionObject(); // eval("(" + $("#hdnAuthenticate").val() + ')');
                if (auth !== undefined) {
                    auth.curl = "NewPost.htm";
                    setSessionObject(auth); // $("#hdnAuthenticate").val(JSON.stringify(auth));
                    $("#childPageContainer").load(auth.curl);

                    //loadChildPage("NewPost.htm", true);
                }

            });
            $('#hlkSearchIssue').click(function () {
                var auth = getSessionObject(); //eval("(" + $("#hdnAuthenticate").val() + ')');
                if ((auth !== undefined) && (auth.status == true)) {
                    auth.curl = "MyForum.htm";
                    setSessionObject(auth); //$("#hdnAuthenticate").val(JSON.stringify(auth));
                    $("#childPageContainer").load(auth.curl);

                    //loadChildPage("MyForum.htm", true);
                }
            });
            $('#hlkPendingTask').click(function () {
                var auth = getSessionObject(); //eval("(" + $("#hdnAuthenticate").val() + ')');
                if ((auth !== undefined) && (auth.status == true)) {
                    auth.curl = "MyForum.htm";
                    setSessionObject(auth); //$("#hdnAuthenticate").val(JSON.stringify(auth));
                    $("#childPageContainer").load(auth.curl);

                    //loadChildPage("MyForum.htm", true);
                }
            });
            return true;
        }
        else {
            alert('data not found');
            document.location.href = "\default.htm?page=menu";
        }
    };
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') || (auth != null) || (auth != '')) {
        uid = auth.u;
        if (auth.currgroupid != undefined) {
            groupid = auth.currgroupid; //current group ID
            groupname = auth.currgroupname; //current group Name

        }
        else {
            groupid = auth.defaultgroupid; //defaultgroup ID
            groupname = auth.defaultgroupname; //defaultgroup Name
        }
    }
    PopulateGroupMenu();
    GetTopics(groupid, groupname);

});

 


function GetGroup() {
    $.ajax({
        type: "GET",
        url: '../service/associatemobile.svc/discussions/groups',
        contentType: 'application/json; charset=utf-8',
        success: function (result) {

            if (result != null)
                bindNonDictionaryDdlList('ddlGroup', result, '', true, 'GroupDesc', 'GroupID', true);
        },
        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}



//-->


function GetTopics(groupid, groupname) {
    var catid = 0;
    $('#ingPageLoading').show();
    $.ajax({
        type: "GET",
        url: '../Service/associatemobile.svc/discussions/' + catid + '/' + groupid,
        contentType: 'application/json; charset=utf-8',
        // dataType: 'json',
        success: function (result) {
            $('#ingPageLoading').show();
            result.groupname = groupname;
            callbackTopic(result);
        },
        error: function (e, xhr) {
            $('#ingPageLoading').show();
            errorcallback(e, xhr);
        }
    });

}
function errorcallback(e, xhr) {
    alert('Getting error to fetch Data: ' + e.responseText);
}
//Question Replies Last Comment Date 
function callbackTopic(result) {
    var intLength = 5;
    var topicData = null;
    var topic_text = '';
    $('#liTopic').hide();
    
    topicData = result;  
    if (topicData != '') {
        if (topicData.length < 5) { intLength = topicData.length; }
//        topic_text = topic_text + '<tr style="background-color: #4B582C; height:5px;"><td colspan="4"/></tr>';
//        topic_text = topic_text + '<tr style="background-color: #E8F4D0;"><td style="width:2%;text-align:left;"><img alt="Top5Topic" src="Images/Top5.bmp"></td>';
//        topic_text = topic_text + '<td colspan="3" style=" text-align:left; vertical-align:center; border-bottom:1px solid #17230C;">';

//        topic_text = topic_text + '<label class="topicHeader">discussions of group </label> ' + strSelect + '</td></tr>'; //<font color="#286673" size=5><b>' + topicData.groupname + '</b></font></label></td></tr>';
//        
//        topic_text = topic_text + '<tr style="height:1px;"><td colspan="4"/></tr>';
//        topic_text = topic_text + '<tr style="style="height:35%"><td colspan="4"><table style="width:100%;"><tr>';
//        topic_text = topic_text + '<td align="center" style="width:50%;" class="topicHeader3">Topic</td>';
//        topic_text = topic_text + '<td align="center" style="width:15%;" class="topicHeader3">Replies</td>';
//        topic_text = topic_text + '<td align="left" class="topicHeader3">Owner/Date</td>';
//        topic_text = topic_text + '<td align="center" class="topicHeader3"></td></tr></table></td></tr>';
//        topic_text = topic_text + '<tr style="background-color: #4B582C; height:1px;"><td colspan="4"/></tr>';
//        topic_text = topic_text + '<tr><td colspan="4"><table style="width:100%;" id="tblchildTopisMenuPage">';
        for (i = 1; i <= intLength; i++) {
//            topic_text = topic_text + '<tr style="width:99%; height:25%;">';
//            topic_text = topic_text + '<td align="left" style="width:50%" ><div id="topicabbr" class="topicHeader" onclick="javascript:navTopic(' + topicData[i].TopicID + ');">' + topicData[i].TopicHeader.substring(0, 15) + '..' + '<br/><font color="#286673">' + topicData[i].Category.CategoryDesc + '</font></div></td>';
//            if (topicData[i].CommentCount != 0)
//            { topic_text = topic_text + '<td style="width:10%; text-align:center;"><div id="comment" class="LinkNormal" onclick="javascript:navTopic(' + topicData[i].TopicID + ');"><font color="#66B035" size=4><b>' + topicData[i].CommentCount + '</b></font></div> </td>'; }
//            else { topic_text = topic_text + '<td style="width:10%; text-align:center;"><div id="comment" ><font color="#66B035" size=4><b>' + topicData[i].CommentCount + '</b></font></div> </td>'; }
//            topic_text = topic_text + '<td align="left" style="width:25%"><label class="topicHeader2"><a  href="#" id="lnktopicid' + topicData[i].TopicID + '-' + topicData[i].CreatedBy + '" class="linkAssociateNameMenu" >' + topicData[i].CreatedByname + '</a><br/>' + topicData[i].PostDateTimeString + '</label></td>';
//            topic_text = topic_text + '<td align="left" style="width:5%"><img alt="Reply" class="imgMenuBtn" src="Images/reply.bmp" onclick="ReplyToPostFromMenu(\'popUpContainerMenu\',\'' + topicData[i].TopicID + '\');" /></td>';
//            topic_text = topic_text + '</tr>';
            $("#hTopic" + i + "").html(topicData[i-1].TopicHeader);
            $("#category" + i + "").html(topicData[i-1].Category.CategoryDesc);
            $("#pOwner" + i + "").html(topicData[i - 1].CreatedByname + " - " + topicData[i - 1].PostDateTimeString);
            $("#spnCount" + i + "").html(topicData[i - 1].CommentCount);
            $('#liDiscussion' + i + '').show();
            //$('#liDiscussion' + i + ' a').attr('href', 'ForumDetail.htm');
            $("#liDiscussion" + i + " a").prop("href", "ForumDetail.htm?topicid=" + topicData[i - 1].TopicID + "");
        }
        //topic_text = topic_text + '</table></td></tr>';
    }
    //$("#top5topic").html($(topic_text));

//    $("#tblchildTopisMenuPage tr:even").addClass("topicDetailEvenRows");
//    $("#tblchildTopisMenuPage tr:odd").addClass("topicDetailOddRows");

//    $(".linkAssociateNameMenu").click(function (e) {
//        showAssociatePopUpdiv(e);        
//    });
    

//    var strtopics='<li data-icon="false" id="liDiscussion1"><a href="discussion.htm" rel="external" data-transition="pop" >';
//    strtopics += '<h3 id="hTopic1" class="Topic">In jQuery Mobile, you can use new HTML5 input types such as email, tel, number, and more</h3>';
//    strtopics += '<p ><strong id="category1"></strong></p>';
//    strtopics += '<p id="pOwner1" >Moumita Banarjee - 04/26/2012</p>';
//    strtopics += '</a> <span id="spnCount1" class="ui-li-count">14</span>';
//    strtopics += '</li>';

    //$('#ulDiscussions').append(strtopics);

}


function ReplyToPostFromMenu(cntnrDiv, tcid) {
    ShowPopupReplyToPost(cntnrDiv, 'TopicID:' + tcid, 'Menu.htm');
}


function navTopic(id) {
    $('#forumval').find('#htopic').val(id);
    $('#popupGroup').hide();
    var at = JSON.parse(GetSessionStorage("ACProfile"));
    at.topicid = id;
    SetSessionStorage("ACProfile", JSON.stringify(at));
    
    loadChildPage('ForumDetail.htm', true);
}

function PopulateGroupMenu() {

    var obj = JSON.parse(GetSessionStorage("ACProfile"));
    var grouplist = '';
    if (obj.groupList != undefined) { grouplist = obj.groupList; }
    var strSelect = "";// '<select name="select-choice-1" id="ddlGroup" data-native-menu="false" data-theme="e" >';
    var gname = (obj.currgroupname != undefined ? obj.currgroupname : obj.defaultgroupname);
    $(grouplist).each(function () {
        if (this.GroupDesc == gname) {
            strSelect += '<option value="' + this.GroupID + '" selected="selected">' + this.GroupDesc + '</option>';
        }
        else {
            strSelect += '<option value="' + this.GroupID + '">' + this.GroupDesc + '</option>';
        }
    });
    //strSelect += '</select>';
    $('#ddlGroup').append(strSelect);
    
    var cntrl = $("#ddlGroup");
    cntrl[0].selectedIndex = 0;
    cntrl.selectmenu("refresh");

    $('#ddlGroup').change(function () {
        top5Topic(this.value);
    });
//    
//    
//    
//    var obj = JSON.parse(GetSessionStorage("ACProfile"));
//    var grouplist = '';
//    var i = 0;
//    var strhtml = '<li data-role="divider" data-theme="e">Choose Group</li>';
//    if (obj.groupList != undefined) { grouplist = obj.groupList; }

//    $('#ulGroup').html('');

//        var acc = $('#accordionAssociateGrp').empty();
//        acc.append($("<h5>").append($('<a style="color:#278FD6;">').attr("href", "#").html(obj.defaultgroupname)));
//    $(grouplist).each(function () {
//        if (i > 0) {
//        strhtml = strhtml + '<li><a href="#" >' + this.GroupDesc + '</a></li>';
//        }
//        i++;
//    });

//    $('#ulGroup').append(strhtml);

//    $('#ulGroup').html('');
//    
//    var acc = $('#accordionAssociateGrp').empty();
//    acc.append($("<h5>").append($('<a style="color:#278FD6;">').attr("href", "#").html(obj.defaultgroupname)));
//    $(grouplist).each(function () {
//        if (i > 0) {
//            strhtml = strhtml + '<li><a href="#">' + this.GroupDesc + '</a></li>' + '<p class="defaultGroup"><a href=#  onclick="javascript:top5Topic(' + this.GroupID + ');">' + this.GroupDesc + '</a></p>';
//        }
//        i++;
//    });

//    acc.append($("<div>").append($(strhtml)));

//    $("#accordionAssociateGrp").accordion({
//        fillSpace: false,
//        collapsible: true,
//        header: "h5",
//        autoHeight: true,
//        active: false

//    });

//    $('#accordionAssociateGrp h5').click(function () {
//        top5Topic(obj.defaultgroupid);
//    });


//    $(function () {
//        $("#accordionResizer").resizable({
//            resize: function () {
//                $("#accordionAssociateGrp").accordion("resize");
//            }
//        });
//    });


}
    function top5Topic(id) {

        var obj = JSON.parse(GetSessionStorage("ACProfile"));
        obj.currgroupid = id;
        
         for (var i = 0; i < obj.groupList.length; i++) {
               if( id == obj.groupList[i].GroupID )
               {
                   obj.currgroupname = obj.groupList[i].GroupDesc;                   
                   break;
               }
          }

          SetSessionStorage("ACProfile", JSON.stringify(obj));
          GetTopics(obj.currgroupid, obj.currgroupname);
          //rePopulateGroupMenu();    
      }

      function rePopulateGroupMenu() {

          var obj = JSON.parse(GetSessionStorage("ACProfile"));
          var strhtml = '';
          $('#accordionAssociateGrp h5').attr("style", "color:#278FD6; text-decoration:underline;").html(obj.currgroupname);
          $('#accordionAssociateGrp div').empty();
          $(obj.groupList).each(function () {
              if (this.GroupDesc != obj.currgroupname) {
                  strhtml = strhtml + '<p class="defaultGroup"><a href=#  onclick="javascript:top5Topic(' + this.GroupID + ');">' + this.GroupDesc + '</a></p>';
              }
          });
          $('#accordionAssociateGrp div').append($(strhtml));
          $("#accordionAssociateGrp").accordion( "activate" , 0 );                           
      }