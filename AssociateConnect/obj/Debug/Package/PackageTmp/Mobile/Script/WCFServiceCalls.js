
// All WCF related calles are made here.

function GetMoneyBookList(uid, sid, pageIndex, pageSize, callback) {
  var serviceResult = new Object();
  $.ajax({
    type: "GET",
    url: "../service/mobile.svc/mobile/uid/" + uid + "/sid/" + sid + "/moneybook?page=" + pageIndex + "&size=" + pageSize + "&sortcol=RequestedDate&sortdir=DESC",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (result) {
      serviceResult.Result = true;
      serviceResult.Data = result;
      callback(serviceResult);
    },
    error: function (e, xhr) {
      serviceResult.Result = false;
      serviceResult.Data = e;
      serviceResult.Handler = xhr;
      callback(serviceResult);
    }
  });
}

function GetAlertTypes(successCallback, errorCallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/alerts/names',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    success: function (result) {
      successCallback(result);
    },
    error: function (e, xhr) {
      errorCallback(e, xhr);
    }
  });
}

function GetAlerts(uid, page, size, messageID, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/uid/' + uid + '/alerts?messageid=' + messageID + '&page=' + page + '&size=' + size,
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

function RemoveAlert(uid, alertID, callback, errorcallback) {
  $.ajax({
    type: "DELETE",
    url: '../service/Mobile.svc/mobile/alerts/id/' + uid + '/aid/' + alertID,
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


function GetToDos(uid, page, size, datedesc, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/uid/' + uid + '/calendarentries?page=' + page + '&size=' + size + '&datedesc=' + datedesc,
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

function RemoveToDo(uid, todoID, callback, errorcallback) {
  $.ajax({
    type: "PUT",
    url: '../service/Mobile.svc/mobile/uid/' + uid + '/calendarentryremoval?cid=' + todoID,
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

//For SearchBroker screen.
function GetBrokerList(objBroker, callback, errorcallback) {
  $.ajax({
    type: "PUT",
    url: "../service/Mobile.svc/search",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: JSON.stringify(objBroker),
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}

//For BrokerProfile screen.
function GetBrokerProfile(systemID, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/salesgroupid/AN/systemid/' + systemID + '/brokerprofile',
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

//For BrokerProfile screen.
function GetBrokerPhone(systemID, callback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/systemid/' + systemID + '/phonetype/Business 1/brokerphonenumber',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) { }
  });
}

//For Policies screen.
function GetPolicies(loginUserId, systemID, page, pageSize, callback, errorcallback) {
  $.ajax({
    type: 'GET',
    url: '../service/Mobile.svc/mobile/lob/AN/uid/' + loginUserId + '/sid/' + systemID + '/policies?page=' + page + '&size=' + pageSize + '&sortcol=FirstIssueDate&sortdir=DESC',
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

//For ActivityLog screen.
function GetActivityLogCategory(loginUserId, callback, errorcallback) {
  $.ajax({
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    url: '../service/Mobile.svc/mobile/companyid/1/userid/' + loginUserId + '/activity/category',
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}

//For ActivityLog screen.
function GetActivityLogSubCategory(loginUserId, category, callback, errorcallback) {
  $.ajax({
    type: 'GET',
    url: '../service/Mobile.svc/mobile/companyid/1/userid/' + loginUserId + '/activity/category/categoryid/' + category + '/subcategory',
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

//For ActivityLog screen.
function ActivityLogSave(objActivity, callback, errorcallback) {
  $.ajax({
    type: 'PUT',
    url: '../service/Mobile.svc/mobile/activity',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: JSON.stringify(objActivity),
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}

//For BrokerAdditionalInfo screen.
function GetBrokerAdditionalInfo(systemID, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/salesgroupid/AN/systemid/' + systemID + '/brokerprofile',
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
function LoadBusinessProfile(uid, systemID, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/Mobile.svc/mobile/businessprofile/systemid/' + systemID,
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

function LoadMetrics(uid, sid, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/mobile.svc/metrics/sales/id/' + uid + '/period/1',
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

function ListActivities(loginUserId, systemID, pageNo, pageSize, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/mobile.svc/mobile/salesgroupid/AN/uid/' + loginUserId + '/sid/' + systemID + '/activities?page=' + pageNo + '&size=' + pageSize + '&sortcol=ActivityDate&sortdir=DESC',
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}


function ListFulfillment(uid, sid, lob, type, page, size, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/mobile.svc/mobile/lob/' + lob + '/uid/' + uid + '/sid/' + sid + '/FulfillmentItems?type=' + type + '&page=' + page + '&size=' + size,
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    success: function (result) {
      result._type = type;
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}


function ListFulfillmentByCategory(loginUserId, systemID, lob, keyWord, page, size, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/mobile.svc/mobile/lob/' + lob + '/uid/' + loginUserId + '/sid/' + systemID + '/fulfillmentitemsbycategorykeyword?keyword=' + keyWord + '&sortcol=Category&sortdir=ASC&page=' + page + '&size=' + size,
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}


function GetFulfillmentEmailItem(lob, userid, systemID, productid, callback, errorcallback) {
  $.ajax({
    type: "GET",
    url: '../service/mobile.svc/mobile/lob/' + lob + '/uid/' + userid + '/sid/' + systemID + '/fulfillment/product/' + productid,
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}

function SendFulfillmentEmailItem(lob, userid, systemID, productid, callback, errorcallback) {
  $.ajax({
    type: "POST",
    url: '../service/mobile.svc/mobile/lob/' + lob + '/uid/' + userid + '/sid/' + systemID + '/fulfillment/product/' + productid,
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: null,
    success: function (result) {
      callback(result);
    },
    error: function (e, xhr) {
      errorcallback(e, xhr);
    }
  });
}