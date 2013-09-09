var loginUserId = 0;
var serviceResult = new Object();
$(document).ready(function () {

    serviceResult = GetAssociate();
    Setdata(serviceResult);
   

});

function GetAssociate(uid, callback, errorcallback) {
    $.ajax({
        type: "GET",
        url: '../../service/AssociateMobile.svc/associate/' + uid  ,
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (result) {
            callback(result);
        },
        error: function (e, xhr) {
            errorcallback(e, xhr);
        }
    });
}

function GetAssociate(serviceResult) {
}