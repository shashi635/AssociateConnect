
(function($) {
  $.fn.firmfileupload = function(options) {
    var defaults = {
      'action': '/FirmAgreements/Service/Upload.ashx',
      'multi': true,
      'initlist': true,
      'autoremove': true,
      'readonly': false,
      'files': null,
      'maxfiles': null
    };
    var opts = $.extend(defaults, options);
    this.each(function() {
      var u = document.createElement('div');
      u.className = "upload";
      this.appendChild(u);
      u.parentDiv = this;
      if (this.multi == null)
        u.multi = opts["multi"];
      else
        u.multi = (this.multi.toLowerCase() == "false" ? false : true);

      if (this.readonly == null)
        u.readonly = opts["readonly"];
      else
        u.readonly = (this.readonly.toLowerCase() == "false" ? false : true);

      if (u.readonly)
        $(u).css("display", "none");

      this.autoremove = opts["autoremove"];
      var firmCode = (opts["firmcode"] == null ? this._button.parentDiv.firmcode : opts["firmcode"]);
      var salesGroupID = (opts["salesgroupid"] == null ? this._button.parentDiv.salesgroupid : opts["salesgroupid"]);
      var type = (opts["type"] == null ? this.type : opts["type"]);
      var initList = (this.initlist == null ? opts["initlist"] : (this.initlist.toLowerCase() == "false" ? false : true));
      u.type = type;
      if (initList) {
        var url = "/FirmAgreements/Service/Firm.svc/firm/" + firmCode + "/salesgroupid/" + salesGroupID + "/attachment/type/" + type;

        $.ajax({
          type: "GET",
          url: url,
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function(result) {
            $.each(result, function() {
              AddTableRow(u, false, this.FileName, this.FileID);
              if (!u.multi) {
                u.fileid = this.FileID;
              }
            });
          },
          error: function(e, xhr) {
            alert('An error occurred getting the attachments: ' + e.responseText)
          }
        });
      }
      else if (this.fileid != null) {
        AddTableRow(u, false, this.filename, this.fileid);
      }
      else if (this.files != null && this.files.length > 0) {
        for (var x = 0; x < this.files.length; x++) {
          AddTableRow(u, false, this.files[x].FileName, this.files[x].FileID);
        }
      }

      new AjaxUpload(u, {
        action: opts["action"],
        name: 'Filedata',
        onSubmit: function(file, ext) {
          this.setData({
            'FileID': (this._button.fileid == null ? "" : this._button.fileid),
            'FirmCode': firmCode,
            'SalesGroupID': salesGroupID,
            'Type': type,
            'AutoSaveFirmData': (initList || this._button.parentDiv.carrierid != null),
            'CarrierID': (this._button.parentDiv.carrierid == null ? "" : this._button.parentDiv.carrierid)
          });
          this.disable();
        },
        onComplete: function(file, response) {
          if (isNaN(response))
            alert("An error occurred uploading the file: " + response);
          else {
            var FileID = eval("(" + response + ")");

            if (FileID == null || FileID <= 0)
              alert("An error occurred uploading the file");
            else {
              AddTableRow(this._button, !this._button.multi, file, FileID);
              if (!this._button.multi) {
                this._button.fileid = FileID;
              }

              if (opts.onComplete != null)
                opts.onComplete(file, FileID, this._button);
            }
          }
          this.enable();
        }
      });
    });

    function AddTableRow(btn, deleteFirstRow, name, fileid) {
      parentDiv = btn.parentDiv;
      if (parentDiv.table == null) {
        var t = document.createElement('table');
        parentDiv.table = t;
        parentDiv.appendChild(parentDiv.table);
      }
      else if (deleteFirstRow && parentDiv.table.rows.length > 0) {
        parentDiv.table.deleteRow(0);
      }

      var row = parentDiv.table.insertRow(0);
      var filename = row.insertCell(0);
      var noaction = false;
      if (btn.parentDiv.carrierid != null) {
        if (fileid != null && fileid > 0) {
          btn.parentDiv.currentfileid = fileid;
        } else if (btn.parentDiv.currentfileid == null) {
          noaction = true;
        }
      }
      if (noaction && fileid != null && fileid > 0) {
        noaction = false;
      }
      name = (name == null ? "" : name);
      filename.innerText = (btn.parentDiv.linkname != null ? btn.parentDiv.linkname : name);
      filename.filename = name;
      filename.className = "filename";
      if (!noaction)
        filename.onclick = OnClickFileName;
      filename.fileid = ((fileid != null && fileid > 0) ? fileid : parentDiv.currentfileid);
      $(filename).css("font-size", "8pt");
      var deletebutton = row.insertCell(1);
      deletebutton.className = "delete";
      if (btn.readonly || noaction)
        $(deletebutton).css("display", "none");
      deletebutton.onclick = OnDeleteRow;
      deletebutton.fileid = filename.fileid;
      deletebutton.row = row;
      deletebutton.table = parentDiv.table;
      deletebutton.parentTableID = parentDiv.parentTableID;
      deletebutton.uploadElement = btn;
      deletebutton.autoremove = parentDiv.autoremove;
      deletebutton.type = btn.type;

      if (parentDiv.maxfiles != null && parentDiv.table.rows.length >= parentDiv.maxfiles)
        $(btn).css("display", "none");
    };

    function OnDeleteRow(e) {
      var deleteFile = true;
      if (opts.onDelete != null) {
        deleteFile = opts.onDelete(this.uploadElement, this.fileid, this.type);
        if (!deleteFile)
          return;
      }

      if (this.autoremove) {
        if (confirm("Are you sure you want to delete this record")) {
          var attachment = new Object();
          attachment.FileID = this.fileid;
          var btn = this;
          var url = "/FirmAgreements/Service/Firm.svc/firm/attachment";
          $.ajax({
            type: "DELETE",
            url: url,
            data: JSON.stringify(attachment),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(result) {
              if (result) {
                DeleteTableRow(btn);
                if (!btn.uploadElement.multi)
                  btn.uploadElement.fileid = null;
                btn = null;
                if (opts.onDeleteComplete != null)
                  opts.onDeleteComplete(result);
              }
            },
            error: function(e, xhr) {
              alert('An error occurred getting the attachments: ' + e.responseText)
            }
          });
        }
      }
      else
        DeleteTableRow(this);
    };

    function DeleteTableRow(btn) {
      btn.table.deleteRow(btn.row.rowIndex);
      if (btn.uploadElement.parentDiv.maxfiles != null && btn.table.rows.length < btn.uploadElement.parentDiv.maxfiles)
        $(btn.uploadElement).css("display", "block");
      btn.row = null;
      btn.table = null;
      if (btn.uploadElement.parentDiv.carrierid != null) {
        btn.uploadElement.parentDiv.currentfileid = null;
        AddTableRow(btn.uploadElement, false, null, 0);
      }
    };

    function OnClickFileName(ev) {
      if (this.fileid != null && $.trim(this.filename) != "")
        window.open("/FirmAgreements/service/firm.svc/firm/attachment/" + this.fileid + "?fn=" + this.filename, "Export");
    };

    return this;
  };

})(jQuery);
