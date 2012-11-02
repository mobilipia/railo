<silent>
<!--- Plus/minus Image --->
<set doItTheClassicWay=structKeyExists(cgi,'http_user_agent') and findNocase('MSIE',cgi.http_user_agent)>

	<set plus="#cgi.context_path#/railo-context/admin/resources/img/debug_plus.gif.cfm">
	<set minus="#cgi.context_path#/railo-context/admin/resources/img/debug_minus.gif.cfm">

</silent><output>
<script>
var plus='#plus#';
var minus='#minus#';
function oc(id) {
	var code=document.getElementById('__cp'+id);
	var button=document.images['__btn'+id];
	if(code.style) {
		if(code.style.position=='absolute') {
			code.style.position='relative';
			code.style.visibility='visible';
		}
		else {
			code.style.position='absolute';
			code.style.visibility='hidden';
		}
		if((button.src+"").indexOf(plus)!=-1)button.src=minus;
		else button.src=plus;
	}
}
</script>
<scriptX>
function convertST(st){
	arguments.st=replace(HTMLEditFormat(arguments.st),"
","<br>","all");

	arguments.st=replace(arguments.st,"  ","&nbsp; ","all");
	arguments.st=replace(arguments.st,"  ","&nbsp; ","all");
	arguments.st=replace(arguments.st,"  ","&nbsp; ","all");
	arguments.st=replace(arguments.st,"  ","&nbsp; ","all");
	arguments.st=replace(arguments.st,"  ","&nbsp; ","all");
	arguments.st=replace(arguments.st,"	","&nbsp;&nbsp;&nbsp;","all");
	
return arguments.st;

}
</scriptX>
<table border="0" cellpadding="4" cellspacing="2" style="font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;font-size : 11px;background-color:red;border : 1px solid black;;">
<tr>
	<td colspan="2" style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Railo #server.railo.version# Error (#(catch.type)#)</td>
</tr>
<param name="catch.message" default="">
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Message</td>
	<td style="border : 1px solid ##350606;background-color :##FFCC00;">#replace(HTMLEditFormat(trim(catch.message)),'
','<br />','all')#</td>
</tr>
<param name="catch.message" default="">
<if len(catch.detail)>
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Detail</td>
    <td style="border : 1px solid ##350606;background-color :##FFCC00;">#replace(HTMLEditFormat(trim(catch.detail)),'
','<br />','all')#</td>
</tr>
</if>
<if structkeyexists(catch,'errorcode') and len(catch.errorcode) and catch.errorcode NEQ 0>
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Error Code</td>
	<td style="border : 1px solid ##350606;background-color :##FFCC00;">#catch.errorcode#</td>
</tr>
</if>
<if structKeyExists(catch,'extendedinfo') and len(catch.extendedinfo)>
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Extended Info</td>
	<td style="border : 1px solid ##350606;background-color :##FFCC00;">#HTMLEditFormat(catch.extendedinfo)#</td>
</tr>
</if>

<if structKeyExists(catch,'additional')>
<loop collection="#catch.additional#" item="key">
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">#key#</td>
	<td style="border : 1px solid ##350606;background-color :##FFCC00;">#replace(HTMLEditFormat(catch.additional[key]),'
','<br />','all')#</td>
</tr>
</loop>
</if>

<if structKeyExists(catch,'tagcontext')>
	<set len=arrayLen(catch.tagcontext)>
	<if len>
	<tr>
		<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;">Stacktrace</td>
		<td style="border : 1px solid ##350606;background-color :##FFCC00;">
		The Error Occurred in<br />
		<loop index="idx" from="1" to="#len#">
			<set tc=catch.tagcontext[idx]>
			<param name="tc.codeprinthtml" default="">
		<if len(tc.codeprinthtml)>
		<img src="#variables[idx EQ 1?'minus':'plus']#" 
			style="margin-top:2px;" 
			onclick="oc('#idx#');" 
			name="__btn#idx#"/>
		</if>
		<if idx EQ 1>
			<b> #tc.template#: line #tc.line#</b><br />
		<else>
			<b>called from</b>#tc.template#: line #tc.line#<br />
		</if>
		<if len(tc.codeprinthtml)><blockquote style="font-size : 10;<if idx GT 1>position:absolute;visibility:hidden;</if>" id="__cp#idx#">
		#tc.codeprinthtml#<br />
		</blockquote></if>
		</loop>
		</td>
	</tr>
	</if>
</if>
<tr>
	<td style="border : 1px solid ##350606;background-color :##FFB200;font-weight:bold;" nowrap="nowrap">Java Stacktrace</td>
	<td style="border : 1px solid ##350606;background-color :##FFCC00;" class="">#convertST(catch.stacktrace)#</td>
</tr>
</table><br />
</output>