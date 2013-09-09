$(document).ready(function () {
    //alert("ready");
    $('#ingPageLoading').show();
    GetGroupValues();
    function GetGroupValues() {
        $.ajax({
            type: "GET",
            url: '../service/associatemobile.svc/discussions/groups',
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
    $('#btnReset').click(reset);
    //RemoveAllStorageValues();
    $('#btnSubmit').click(function () {
        //addGroups();

        var re5digit = "/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/";
        var obj = new Object();
        if ($("#tstid").val() == "") {
            $("#lblresult").text("Please enter Associate ID.").attr("style", "color:red;").show(100).delay(3000).hide(400);
        }
        else {
            //                    if ($("#txtPwd").val() == "")
            //                        $("#lblresult").text("Please enter password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            //                    else {
            //                        if ($("#txtcnfrmpwd").val() == "")
            //                            $("#lblresult").text("Please enter confirm password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            //                        else {
            if ($("#txtemail").val() == "")
                $("#lblresult").text("Please enter email.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if ($("#txtfirstname").val() == "")
                $("#lblresult").text("Please enter First Name.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if ($("#txtlastname").val() == "")
                $("#lblresult").text("Please enter Last Name.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if ($("#txtmobile").val() == "")
                $("#lblresult").text("Please enter mobile Number.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if ($("#ddlGroup").val() == "")
                $("#lblresult").text("Please select group(s).").attr("style", "color:red;").show(100).delay(3000).hide(400);
            //                            else if ($("#txtPwd").val() != $("#txtcnfrmpwd").val())
            //                                $("#lblresult").text("Confirm Password is not same as password.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if (!(IsValidEmail($("#txtemail").val())))
                $("#lblresult").text("Please enter Valid email.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if (!((/^\d{6}$/).test($("#tstid").val())))
                $("#lblresult").text("Please enter Valid Associate ID.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else if (!((/^\d{10}$/).test($("#txtmobile").val())))
                $("#lblresult").text("Please enter Valid 10 digit mobile number.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            //                    else if ($("#txtPwd").val().length < 6)
            //                        $("#lblresult").text("Password should contain at least 6 characters.").attr("style", "color:red;").show(100).delay(3000).hide(400);
            else {

                obj.email = $("#txtemail").val();
                obj.Password = "password";
                obj.AssociateID = parseInt($("#tstid").val());
                obj.FirstName = $("#txtfirstname").val();
                obj.LastName = $("#txtlastname").val();
                obj.Mobile = $("#txtmobile").val();
                obj.Gender = $('#radio-choice-h-2a').is(':checked') ? "Male" : "Female";
                $('#imgLoading').show();
                $.ajax({
                    url: "../service/associatemobile.svc/associate/add",
                    data: JSON.stringify(obj),
                    type: "PUT",
                    contentType: "application/json; charset=utf-8",
                    success: fun_success,
                    error: fun_err
                });
                //                            }
                //                        }
            }
        }
    });
    function IsValidEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }


    function fun_success(result) {
        if (result == "success") {

            //reset();
            addGroups();
        }
    }
    function fun_err(result) {
        $("#lblresult").text("Registration Unsuccessful!").attr("style", "color:red;").show(100).delay(3000).hide(400);
        $('#imgLoading').hide();
    }
    function addGroups() {
        var groupIds = "";
        for (var i = 0; i < $("#ddlGroup").val().length; i++) {
            groupIds += $("#ddlGroup").val()[i] + ",";
        }
        $.ajax({
            url: "../service/associatemobile.svc/UpdateGroup/" + groupIds + "/10/" + $("#tstid").val(),
            type: "GET",
            contentType: "application/json; charset=utf-8",
            success: function (result) {

                $('#imgLoading').hide();
                $("#lblresult").text("Registration successful. Your username and password is sent to your mobile.").attr("style", "color:green;").show(100).delay(30000).hide(400);
                reset();

            },
            error: function (e, xhr) {
                $('#imgLoading').hide();
                $("#lblresult").text("User is registered, but not added to any group. Please contact Admin!").attr("style", "color:red;").show(100).delay(3000).hide(400);
                reset();
            }
        });
    }
    function reset() {
        $("#txtemail").val('');
        $("#tstid").val('');
        $("#txtfirstname").val('');
        $("#txtlastname").val('');
        $("#txtmobile").val('');
        GetGroupValues();
    }

});