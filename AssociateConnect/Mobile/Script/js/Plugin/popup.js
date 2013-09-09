/***************************/
//0 means disabled; 1 means enabled;
var popupStatus = 0;
var page = null;
var pageSize = null;
var next = null;
var previous = null;
//loading popup with jQuery 
function loadPopup(e) {
  //loads popup only if it is disabled
  //debugger;
  if (popupStatus == 0) {
    $("#popupContact").bgiframe();
    $("#popupContact").fadeIn("slow");
    $("#popupContactClose").click(disablePopup);
    popupStatus = 1;
  }

  ($("#popupContact"))[0].setAttribute('targetTableId', e.currentTarget.targetTableId);
  ($("#popupContact"))[0].setAttribute('targetRowId', e.currentTarget.targetRowId);
  SetDivLocation(($("#popupContact"))[0], e.target);
}

//disabling popup with jQuery
function disablePopup() {
  //debugger;
  //disables popup only if it is enabled
  $("#popupContact").fadeOut("slow");
  popupStatus = 0;
}

//centering popup
function centerPopup() {
  //request data for centering
  var windowWidth = document.documentElement.clientWidth;
  var windowHeight = document.documentElement.clientHeight;
  var popupHeight = $("#popupContact").height();
  var popupWidth = $("#popupContact").width();
  //centering
  $("#popupContact").css({
    "position": "absolute",
    "top": windowHeight / 2 - popupHeight / 2,
    "left": windowWidth / 2 - popupWidth / 2
  });
  //only need force for IE6

  //    $("#backgroundPopup").css({
  //        "height": windowHeight
  //    });

}

//CONTROLLING EVENTS IN jQuery
$(document).ready(function() {

  //LOADING POPUP
  //Click the button event!
  $("#consearch").click(function() {
    //centering with css
    centerPopup();
    //load popup
    loadPopup();
  });

  //CLOSING POPUP
  //Click the x event!
  //    $("#popupContactClose").click(function() {
  //        disablePopup();
  //    });
  //Click out event!
  //    $("#backgroundPopup").click(function() {
  //        disablePopup();
  //    });
  //Press Escape event!
  $(document).keypress(function(e) {
    if (e.keyCode == 27 && popupStatus == 1) {
      disablePopup();
    }
  });
  //Click the search event!
  //    $("#btnSubmit").click(function() {
  ////        $("#txtPValue").val($("#txtValue").val());
  //    //        disablePopup();
  //    page = 0;
  //    $("#searching").innerHTML = 'Searching...';
  //    Search();
  //    });

});