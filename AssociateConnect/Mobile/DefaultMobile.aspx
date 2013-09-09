<%@ Page Language="C#"  AutoEventWireup="true"
    CodeFile="DefaultMobile.aspx.cs" Inherits="AssociateConnect.Mobile.DefaultMobile" %>

<!doctype html>
<html manifest="iContactMob.manifest">
<head>
    <title>MLIAD: Mobile POC</title>
   
  <%--<script src="Scripts/html5.js" type="text/javascript"></script>
  <script src="Scripts/IE8.js" type="text/javascript"></script>--%>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <link media="only screen and (min-width: 481px)" href="Script/Theme/css/medium.css" rel="stylesheet" />
    <link media="only screen and (max-width: 480px)" href="Script/Theme/css/small.css" rel="stylesheet" />
        <%--<style type="text/css" media="screen">
        @import "css/theme.min.css";
    </style>--%>
</head>
<body>
<form>
Enter your email: <input type="email" id="email" list="elist" /><br />
<datalist id="elist">
 <option value="gm" label="guru.sahoo@metlife.com">
 <option value="mm" label="moumita.banerjee@metlife.com">
 <option value="sm" label="subhendu.roy@metlife.com">
</datalist>
Select URL: <input type="url" name="location" list="urls">
<datalist id="urls">
 <option label="MIME: Format of Internet Message Bodies" value="http://tools.ietf.org/html/rfc2045">
 <option label="HTML 4.01 Specification" value="http://www.w3.org/TR/html4/">
 <option label="Form Controls" value="http://www.w3.org/TR/xforms/slice8.html#ui-commonelems-hint">
 <option label="Scalable Vector Graphics (SVG) 1.1 Specification" value="http://www.w3.org/TR/SVG/">
 <option label="Feature Sets - SVG 1.1 - 20030114" value="http://www.w3.org/TR/SVG/feature.html">
 <option label="The Single UNIX Specification, Version 3" value="http://www.unix-systems.org/version3/">
</datalist>



 <div>
        <label for="1">Select option 1</label>
        <input type="number" min="1" value="5" name="1" size="2" step="1" />
      </div>
      <div>
        <label for="2">Select option 2</label>
        <input type="number" min="6" value="10" name="2" size="2" step="1" />
      </div>
      <div>
        <input type="datetime" />
      </div>

      <fieldset>
 <legend>Destination</legend>
 <p><label>Airport: <input type=text name=to list=airports></label></p>
 <p><label>Departure time: <input type=datetime-local name=totime step=3600></label></p>
</fieldset>
<datalist id=airports>
 <option value=ATL label="Atlanta">
 <option value=MEM label="Memphis">
 <option value=LHR label="London Heathrow">
 <option value=LAX label="Los Angeles">
 <option value=FRA label="Frankfurt">
</datalist>
      <div>
        <input type="submit" value="Save" />
      </div>

</form>
</body>

<script type="text/javascript">
    function testLocalStorage() {
        alert("conn");
        localStorage.setItem('sitename1', 'MobilePOC1');
        var conn1 = localStorage.getItem('sitename1');
        alert(conn1);
        sessionStorage.setItem('sitename2', 'MobilePOC2');
        var conn2 = sessionStorage.getItem('sitename2');
        alert(conn2);
    }
    testLocalStorage();
 </script>