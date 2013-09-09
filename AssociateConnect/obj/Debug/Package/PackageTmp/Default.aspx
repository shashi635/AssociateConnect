<%@ Page Title="" Language="C#" MasterPageFile="~/Associate.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AssociateConnect.Default" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    
    <link href="App_Themes/Default/jquery.ui.all.css" rel="stylesheet" type="text/css" />

    <script src="Scripts/ui/ui.core.js" type="text/javascript"></script>
    <script src="Scripts/ui/ui.widget.js" type="text/javascript"></script>
    <script src="Scripts/ui/ui.mouse.js" type="text/javascript"></script>
    <script src="Scripts/ui/ui.sortable.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        $(function () {
            $(".column").sortable({
                connectWith: ".column"
            });

            $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			.find(".portlet-header")
				.addClass("ui-widget-header ui-corner-all")
				.prepend("<span class='ui-icon ui-icon-minusthick'></span>")
				.end()
			.find(".portlet-content");

            $(".portlet-header .ui-icon").click(function () {
                $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
                $(this).parents(".portlet:first").find(".portlet-content").toggle();
            });

            $(".column").disableSelection();
        });
	</script>

    <style type="text/css" >
	.column { width: 24%; float: left; padding-bottom: 100px; }
	.portlet { margin: 0 1em 1em 0; }
	.portlet-header { margin: 0.3em; padding-bottom: 4px; padding-left: 0.2em; }
	.portlet-header .ui-icon { float: right; }
	.portlet-content { padding: 0.4em; font-family:Arial }
	.ui-sortable-placeholder { border: 1px dotted black; visibility: visible !important; height: 80px !important; }
	.ui-sortable-placeholder * { visibility: hidden; }
        .style2
        {
            width: 8px;
        }
        .style4
        {
            width: 150px;
        }
    </style>

</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br/>
<br/>

<div class="column">

	<div class="portlet">
		<div class="portlet-header">Member</div>
		<div class="portlet-content">Users can add personal and contact details of associates from Add Member section in Add Member page.The details can also be edited in Edit Member page.</div>
	</div>
	
	<div class="portlet">
		<div class="portlet-header">News</div>
		<div class="portlet-content">Lorem ipsum dolor sit amet, consectetuer adipiscing elit</div>
	</div>

</div>

<div class="column">

	<div class="portlet">
		<div class="portlet-header">Software</div>
		<div class="portlet-content">Users can Add required softwares that are used in their project from Software Details Section in Software Details page.The details of software can also be searched and deleted.</div>
	</div>

</div>

<div class="column">

	<div class="portlet">
		<div class="portlet-header">Firewall</div>
		<div class="portlet-content">Users can Add required firewalls that are used in their project from Firewall Details Section in Firewall Details page.The details of firewall can also be searched and deleted.</div>
	</div>
	
	<div class="portlet">
		<div class="portlet-header">Images</div>
		<div class="portlet-content">Lorem ipsum dolor sit amet, consectetuer adipiscing elit</div>
	</div>

</div>

<div class="column">

	<div class="portlet">
		<div class="portlet-header">Links</div>
		<div class="portlet-content">Lorem ipsum dolor sit amet, consectetuer adipiscing elit</div>
	</div>
	
	<div class="portlet">
		<div class="portlet-header">Images</div>
		<div class="portlet-content">Lorem ipsum dolor sit amet, consectetuer adipiscing elit</div>
	</div>

</div>

       <%--<table  width="100%">
        <tr>
        <td class="style4">
        </td>
        <td style="width:25%" valign="top">
        <fieldset class="login">
        <legend>Member</legend>
        <div style="vertical-align:top">
        <a style="color:Blue">Users can add personal and contact details of associates from Add Member section in Add Member page.The details can also be edited in Edit Member page.      
            </a>
             </div>
        </fieldset>
        </td>
        <td class="style2">
        </td>
        <td style="width:25%" valign="top">
        <fieldset class="login">
        <legend>Software</legend>
         <div style="vertical-align:top">
          <a style="color:Blue">Users can Add required softwares that are used in their project from Software Details Section in Software Details page.The details of software can also be searched and deleted.</a>
         </div>
         </fieldset>
        </td>
        <td class="style2">
        </td>
         <td style="width:25%" valign="top">
         <fieldset class="login">
        <legend>Firewall</legend>
        <div style="vertical-align:top">
        <a style="color:Blue"> Users can Add required firewalls that are used in their project from Firewall Details Section in Firewall Details page.The details of firewall can also be searched and deleted.</a>
        </div>
         </fieldset>
        </td>
        <td class="style4">
        </td>
        
        </tr>
        </table>--%>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<%--<div align="center">
<img src="web/Images/Heading/home.JPG" alt="Welcome to Metlife Requirements" />
</div>--%>
<br/>
    </asp:Content>
