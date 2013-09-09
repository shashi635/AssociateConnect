$(document).ready(function () {
    var auth = JSON.parse(GetSessionStorage("ACProfile"));
    if ((auth != 'undefined') && (auth != null) && (auth != '')) {
        uid = auth.u;
    }
    else {
        window.location.href = "Login.htm";
    }

    $('#wlcmName').html('Welcome, ' + auth.Name);
});

function Submit() {
    var obj = new Object();
    if ($("#txtPwd").val() == "") {
        $("#lblresult").text("Please enter current password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else if ($("#txtNewPwd").val() == "") {
        $("#lblresult").text("Please enter new password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else if ($("#txtcnfrmpwd").val() == "") {
        $("#lblresult").text("Please confirm your password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else if ($("#txtNewPwd").val().length < 6) {
        $("#lblresult").text("Password should contain at least 6 characters.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else if ($("#txtNewPwd").val() != $("#txtcnfrmpwd").val()) {
        $("#lblresult").text("New password and confirm password doesnot match.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else if ($("#txtPwd").val() == $("#txtcnfrmpwd").val()) {
        $("#lblresult").text("Current password and New password are identical.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        return false;
    }
    else {
        obj.NewPassword = $("#txtcnfrmpwd").val();
        obj.CurrentPassword = $("#txtPwd").val();
        obj.AssociateID = parseInt(uid);
        $.ajax({
            url: "../service/associatemobile.svc/associate/changepassword",
            data: JSON.stringify(obj),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: Success,
            error: Error
        });
    }
}
function Success(result) {
    if (result == "1") {
        $("#lblresult").text("Password Changed Successfully !").attr("style", "color:green;").show(100).delay(3000).hide(400);
        Reset(1);
    }
    else if (result == "2") {
        $("#lblresult").text("Current password is wrong !").attr("style", "color:red;").show(100).delay(3000).hide(400);
        $('#tstid').focus();
    }
    else if (result == "3") {
        $("#lblresult").text("We are having issues currently, please try again later !").attr("style", "color:red;").show(100).delay(3000).hide(400);
    }
}
function Error(result) {
    $("#lblresult").text("We are having issues currently, please try again later !").attr("style", "color:red;").show(100).delay(3000).hide(400);
}

function Reset(val) {
    if (val==1) {
        $("#txtNewPwd").val("");
        $("#txtcnfrmpwd").val("");
        $("#txtPwd").val("");
    }
    else {
        $("#lblresult").text("");
        $("#txtNewPwd").val("");
        $("#txtcnfrmpwd").val("");
        $("#txtPwd").val("");
    }
    
}