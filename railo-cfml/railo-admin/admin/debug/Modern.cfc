<component extends="Debug" output="no">

	<scriptX>
		fields=array(
		group("Execution Time","Execution times for templates, includes, modules, custom tags, and component method calls. Template execution times over this minimum highlight time appear in red.",3)
		,field("Minimal Execution Time","minimal","0",true,{_appendix:"microseconds",_bottom:"Execution times for templates, includes, modules, custom tags, and component method calls. Outputs only templates taking longer than the time (in microseconds) defined above."},"text40")
		,field("Highlight","highlight","250000",true,{_appendix:"microseconds",_bottom:"Highlight templates taking longer than the following (in microseconds) in red."},"text50")
		,group("Custom Debugging Output","Define what is outputted",3)
		,field("Database Activity","database","Enabled",false,
			"Select this option to show the database activity for the SQL Query events and Stored Procedure events in the debugging output."
			,"checkbox","Enabled")
		,field("Exceptions","exception","Enabled",false,
			"Select this option to output all exceptions raised for the request. "
			,"checkbox","Enabled")
		,field("Tracing","tracing","Enabled",false,
			"Select this option to show trace event information. Tracing lets a developer track program flow and efficiency through the use of the CFTRACE tag."
			,"checkbox","Enabled")
		,field("Timer","timer","Enabled",false,
			"Select this option to show timer event information. Timers let a developer track the execution time of the code between the start and end tags of the CFTIMER tag. "
			,"checkbox","Enabled")
		,field("Implicit variable Access","implicitAccess","Enabled",false,
			"Select this option to show all accesses to scopes, queries and threads that happens implicit (cascaded). "
			,"checkbox","Enabled")
		,field("Scope Variables","scopes","Enabled",false,"Enable Scope reporting","checkbox","Enabled")
		,field("General Debug Information ","general","Enabled",false,
		"Select this option to show general information about this request. General items are Railo Version, Template, Time Stamp, User Locale, User Agent, User IP, and Host Name. ",
		"checkbox","Enabled")
		);
		
		string function getLabel(){
		return "Modern";
		}
		string function getDescription(){
		return "The new style debug template";
		}
		string function getid(){
		return "railo-modern";
		}
		
		void function onBeforeUpdate(struct custom){
		//throwWhenEmpty(custom,"color");
		//throwWhenEmpty(custom,"bgcolor");
		throwWhenNotNumeric(custom,"minimal");
		throwWhenNotNumeric(custom,"highlight");
		}
		
		private void function throwWhenEmpty(struct custom, string name){
		if(!structKeyExists(custom,name) or len(trim(custom[name])) EQ 0)
		throw "value for ["&name&"] is not defined";
		}
		private void function throwWhenNotNumeric(struct custom, string name){
		throwWhenEmpty(custom,name);
		if(!isNumeric(trim(custom[name])))
		throw "value for ["&name&"] must be numeric";
		}
		
		private function isColumnEmpty(query qry,string columnName){
		if(!isDefined(columnName)) return true;
		return !len(arrayToList(queryColumnData(qry,columnName),""));
		}
	</scriptX>
 
	<function name="output" returntype="void">
		<argument name="custom" type="struct" required="yes" />
		<argument name="debugging" required="true" type="struct" />
		<argument name="context" type="string" default="web" />
		<silent>
			<set var time=getTickCount() />
			<set var _cgi=structKeyExists(arguments.debugging,'cgi')?arguments.debugging.cgi:cgi />
			<set var pages=arguments.debugging.pages />
			<set var queries=arguments.debugging.queries />
			<if not isDefined('arguments.debugging.timers')>
				<set arguments.debugging.timers=queryNew('label,time,template') />
			</if>
			<if not isDefined('arguments.debugging.traces')>
				<set arguments.debugging.traces=queryNew('type,category,text,template,line,var,total,trace') />
			</if>
			<set var timers=arguments.debugging.timers />
			<set var traces=arguments.debugging.traces />
			<set querySort(pages,"avg","desc") />
			<set var implicitAccess=arguments.debugging.implicitAccess />
			<set querySort(implicitAccess,"template,line,count","asc,asc,desc") />
			<param name="arguments.custom.unit" default="millisecond">
			<param name="arguments.custom.color" default="black">
			<param name="arguments.custom.bgcolor" default="white">
			<param name="arguments.custom.font" default="Times New Roman">
			<param name="arguments.custom.size" default="medium">
			<set var unit={
				millisecond:"ms"
				,microsecond:"�s"
				,nanosecond:"ns"
				} />
			<!--- Plus/minus Image --->
			<output>
				<set var plus="#cgi.context_path#/railo-context/admin/resources/img/plus.png.cfm" />
				<set var minus="#cgi.context_path#/railo-context/admin/resources/img/minus.png.cfm" />
				<savecontent variable="local.sImgPlus">
					<img src="#plus#">
				</savecontent>
				<savecontent variable="local.sImgMinus">
					<img src="#minus#">
				</savecontent>
			</output>
		</silent>
		<if arguments.context EQ "web">
			</td></td></td></th></th></th></tr></tr></tr></table></table></table></a></abbrev></acronym></address></applet></au></b></banner></big></blink></blockquote></bq></caption></center></cite></code></comment></del></dfn></dir></div></div></dl></em></fig></fn></font></form></frame></frameset></h1></h2></h3></h4></h5></h6></head></i></ins></kbd></listing></map></marquee></menu></multicol></nobr></noframes></noscript></note></ol></p></person></plaintext></pre></q></s></samp></script></select></small></strike></strong></sub></sup></table></td></textarea></th></title></tr></tt></u></ul></var></wbr></xmp>
		</if>
		<output>
			<style type="text/css">
				.h1 {font-weight:normal;font-family:'Helvetica Neue', Arial, Helvetica, sans-serif;font-size : 20pt;color:##007bb7;} .h2 {height:6pt;font-size : 12pt;font-weight:normal;color:##007bb7;} .cfdebug {font-family:'Helvetica Neue', Arial, Helvetica, sans-serif;font-size : 9pt;color:##3c3e40;} .cfdebuglge {color:#arguments.custom.color#;background-color:#arguments.custom.bgcolor#;font-family:#arguments.custom.font#; font-size:
				<if arguments.custom.size EQ "small">
					small
				<elseif arguments.custom.size EQ "medium">
					medium
				<else>
					large
				</if>
				;} .template_overage { color: red; background-color: #arguments.custom.bgcolor#; font-family:#arguments.custom.font#; font-weight: bold; font-size:
				<if arguments.custom.size EQ "small">
					smaller
				<elseif arguments.custom.size EQ "medium">
					small
				<else>
					medium
				</if>
				; } .tbl{empty-cells:show;font-family:'Helvetica Neue', Arial, Helvetica, sans-serif;font-size : 9pt;color:##3c3e40;} .tblHead{padding-left:5px;padding-right:5px;border:1px solid ##e0e0e0;background-color:##f2f2f2;color:##3c3e40} .tblContent {padding-left:5px;padding-right:5px;border:1px solid ##e0e0e0;background-color:##ffffff;} .tblContentRed {padding-left:5px;padding-right:5px;border:1px solid ##cc0000;background-color:##f9e0e0;} .tblContentGreen {padding-left:5px;padding-right:5px;border:1px solid ##009933;background-color:##e0f3e6;} .tblContentYellow {padding-left:5px;padding-right:5px;border:1px solid ##ccad00;background-color:##fff9da;} 
			</style>
			<SCRIPT LANGUAGE="JavaScript"> plus='#plus#'; minus='#minus#'; <!--
			/*
			   name - name of the cookie
			   value - value of the cookie
			   [expires] - expiration date of the cookie
			     (defaults to end of current session)
			   [path] - path for which the cookie is valid
			     (defaults to path of calling document)
			   [domain] - domain for which the cookie is valid
			     (defaults to domain of calling document)
			   [secure] - Boolean value indicating if the cookie transmission requires
			     a secure transmission
			   * an argument defaults when it is assigned null as a placeholder
			   * a null placeholder is not required for trailing omitted arguments
			*/
			
			function railoDebugModernSetCookie(name, value, domain, expires, path, secure) {
			  var curCookie = name + "=" + escape(value) +
			      ((expires) ? "; expires=" + expires.toGMTString() : "") +
			/*		      ((path) ? "; path=/" + path : "") + */
			      ("; path=/");
			/*		      ((domain) ? "; domain=" + domain : "") +
			      ((secure) ? "; secure" : "");*/
			  document.cookie = curCookie;
			}
			
			/*
			  name - name of the desired cookie
			  return string containing value of specified cookie or null
			  if cookie does not exist
			* /
			
			function getCookie(name) {
			  var dc = document.cookie;
			  var prefix = name + "=";
			  var begin = dc.indexOf("; " + prefix);
			  if (begin == -1) {
			    begin = dc.indexOf(prefix);
			    if (begin != 0) return null;
			  } else
			    begin += 2;
			  var end = document.cookie.indexOf(";", begin);
			  if (end == -1)
			    end = dc.length;
			  return unescape(dc.substring(begin + prefix.length, end));
			}*/
			
			function railoDebugModernToggle(id) {
				var data=document.getElementById(id+'_body');
				//var dots=document.getElementById(id+'_body_close');
				var img=document.getElementById(id+'_img');
				if (data.style.display == 'none') {
					railoDebugModernSetCookie('railo_debug_modern_'+id,'true');
					data.style.display = '';
					//dots.style.display = 'none';
					img.src=minus;
				} else {
					railoDebugModernSetCookie('railo_debug_modern_'+id,'false');
					data.style.display = 'none';
					//dots.style.display = '';
					img.src=plus;
				}
			}
			-->
			</script>
			
			<table class="tbl">
			<tr>
			<td class="tblContent" style="padding:10px">
			<!--- General --->
			<set local.display=structKeyExists(cookie,'railo_debug_modern_info') and cookie.railo_debug_modern_info />
			
		
			<if isEnabled(arguments.custom,'general')>
				<span class="h2">Debugging Information</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('info')"><img vspace="4" src="#display?minus:plus#" id="info_img"></a>
						</td>
						<td>
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="cfdebug" nowrap>Template</td>
									<td class="cfdebug">#_cgi.SCRIPT_NAME# (#expandPath(_cgi.SCRIPT_NAME)#)</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>User Agent</td>
									<td class="cfdebug">#_cgi.http_user_agent#</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="info_body" style="display:#display?"":"none"#;"> 
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="cfdebug" colspan="2" nowrap>
										#server.coldfusion.productname# 
										<if StructKeyExists(server.railo,'versionName')>
											(
											<a href="#server.railo.versionNameExplanation#" target="_blank">#server.railo.versionName#</a>
											)
										</if>
										#ucFirst(server.coldfusion.productlevel)# #uCase(server.railo.state)# #server.railo.version# (CFML Version #server.ColdFusion.ProductVersion#) 
									</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>Time Stamp</td>
									<td class="cfdebug">#LSDateFormat(now())# #LSTimeFormat(now())#</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>Time Zone</td>
									<td class="cfdebug">#getTimeZone()#</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>Locale</td>
									<td class="cfdebug">#ucFirst(GetLocale())#</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>Remote IP</td>
									<td class="cfdebug">#_cgi.remote_addr#</td>
								</tr>
								<tr>
									<td class="cfdebug" nowrap>Host Name</td>
									<td class="cfdebug">#_cgi.server_name#</td>
								</tr>
								<if StructKeyExists(server.os,"archModel") and StructKeyExists(server.java,"archModel")>
									<tr>
										<td class="cfdebug" nowrap>Architecture</td>
										<td class="cfdebug">
											<if server.os.archModel NEQ server.os.archModel>
												OS #server.os.archModel#bit/JRE #server.java.archModel#bit
											<else>
												#server.os.archModel#bit
											</if>
										</td>
									</tr>
								</if>
							</table>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			
			
			
		<!--- Execution Time --->
			<set display=structKeyExists(cookie,'railo_debug_modern_exe') and cookie.railo_debug_modern_exe />
			<span class="h2"><a name="cfdebug_execution">
					Execution Time
				</a></span>
			<set local.loa=0 />
			<set local.tot=0 />
			<set local.q=0 />
			<loop query="pages">
				<set tot=tot+pages.total />
				<set q=q+pages.query />
				<if pages.avg LT arguments.custom.minimal*1000>
					<continue>
				</if>
				<set local.bad=pages.avg GTE arguments.custom.highlight*1000 />
				<set loa=loa+pages.load />
			</loop>
			<table class="tbl" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
						<a href="javascript:railoDebugModernToggle('exe')"><img vspace="4" src="#display?minus:plus#" id="exe_img" onclick=""></a>
					</td>
					<td>
						<table class="tbl"  cellpadding="2" cellspacing="0">
							<tr>
								<td align="right" nowrap>#formatUnit(arguments.custom.unit, loa)#</td>
								<td width="800">&nbsp;Startup/Compiling</td>
							</tr>
							<tr>
								<td align="right" nowrap>#formatUnit(arguments.custom.unit, tot-q-loa)#</td>
								<td>&nbsp;Application</td>
							</tr>
							<tr>
								<td align="right" nowrap>#formatUnit(arguments.custom.unit, q)#</td>
								<td>&nbsp;Query</td>
							</tr>
							<tr>
								<td align="right" nowrap><b>
										#formatUnit(arguments.custom.unit, tot)#
									</b></td>
								<td>&nbsp;
									<b>
										Total
									</b></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						<div id="exe_body" style="display:#display?"":"none"#;"> 
						<table class="tbl" cellpadding="2" cellspacing="0">
							<tr>
								<td class="tblHead" align="center">Total Time</td>
								<td class="tblHead" align="center">Avg Time</td>
								<td class="tblHead" align="center">Count</td>
								<td class="tblHead">Template</td>
							</tr>
							<set loa=0 />
							<set tot=0 />
							<set q=0 />
							<loop query="pages">
								<set tot=tot+pages.total />
								<set q=q+pages.query />
								<if pages.avg LT arguments.custom.minimal*1000>
									<continue>
								</if>
								<set bad=pages.avg GTE arguments.custom.highlight*1000 />
								<set loa=loa+pages.load />
								<tr>
									<td align="right" class="tblContent" nowrap>
										<if bad>
											<font color="red">
										</if>
										#formatUnit(arguments.custom.unit, pages.total-pages.load)#<if bad></font></if>
									</td>
									<td align="right" class="tblContent" nowrap>
										<if bad>
											<font color="red"></if>
										#formatUnit(arguments.custom.unit, pages.avg)#<if bad></font></if>
									</td>
									<td align="center" class="tblContent" nowrap>#pages.count#</td>
									<td align="left" class="tblContent" nowrap>
										<if bad>
											<font color="red"></if>
										#pages.src#<if bad></font></if>
									</td>
								</tr>
							</loop>
						</table>
						<font color="red">
							red = over #formatUnit(arguments.custom.unit,arguments.custom.highlight*1000)# average execution time
						</font>
						<br>
						<br>
						</div> 
					</td>
				</tr>
			</table>
			<!--- Exceptions --->
			<if isEnabled(arguments.custom,"exception") and structKeyExists(arguments.debugging,"exceptions")  and arrayLen(arguments.debugging.exceptions)>
				<set display=structKeyExists(cookie,'railo_debug_modern_exp') and cookie.railo_debug_modern_exp />
				<set exceptions=debugging.exceptions />
				<span class="h2">Caught Exceptions</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('exp')"><img vspace="4" src="#display?minus:plus#" id="exp_img"></a>
						</td>
						<td>
							<table class="tbl"  cellpadding="2" cellspacing="0">
								<tr>
									<td align="right" nowrap>#arrayLen(debugging.exceptions)#</td>
									<td width="800">
										&nbsp;Exception#arrayLen(debugging.exceptions) GT 1?'s':''# catched
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="exp_body" style="display:#display?"":"none"#;"> 
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="tblHead">Type</td>
									<td class="tblHead">Message</td>
									<td class="tblHead">Detail</td>
									<td class="tblHead">Template</td>
								</tr>
								<loop array="#exceptions#" index="exp">
									<tr>
										<td class="tblContent" nowrap>#exp.type#</td>
										<td class="tblContent" nowrap>#exp.message#</td>
										<td class="tblContent" nowrap>#exp.detail#</td>
										<td class="tblContent" nowrap>#exp.TagContext[1].template#:#exp.TagContext[1].line#</td>
									</tr>
								</loop>
							</table>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			<!--- Implicit variable Access --->
			<if isEnabled(arguments.custom,"implicitAccess") and implicitAccess.recordcount>
				<set display=structKeyExists(cookie,'railo_debug_modern_acc') and cookie.railo_debug_modern_acc />
				<set hasAction=!isColumnEmpty(traces,'action') />
				<set hasCategory=!isColumnEmpty(traces,'category') />
				<span class="h2">Implicit variable Access</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('acc')"><img vspace="4" src="#display?minus:plus#" id="acc_img"></a>
						</td>
						<td>
							<table class="tbl"  cellpadding="2" cellspacing="0">
								<tr>
									<td align="right" nowrap>#implicitAccess.recordcount#</td>
									<td width="800">
										&nbsp;implicit variable access#implicitAccess.recordcount GT 1?'es':''#
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="acc_body" style="display:#display?"":"none"#;"> 
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="tblHead">Scope</td>
									<td class="tblHead">Template</td>
									<td class="tblHead">Line</td>
									<td class="tblHead">Var</td>
									<td class="tblHead">Count</td>
								</tr>
								<set total=0 />
								<loop query="implicitAccess">
									<tr>
										<td align="left" class="tblContent" nowrap>#implicitAccess.scope#</td>
										<td align="left" class="tblContent" nowrap>#implicitAccess.template#</td>
										<td align="left" class="tblContent" nowrap>#implicitAccess.line#</td>
										<td align="left" class="tblContent" nowrap>#implicitAccess.name#</td>
										<td align="left" class="tblContent" nowrap>#implicitAccess.count#</td>
									</tr>
								</loop>
							</table>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			<!--- Timers --->
			<if isEnabled(arguments.custom,"timer") and timers.recordcount>
				<set display=structKeyExists(cookie,'railo_debug_modern_time') and cookie.railo_debug_modern_time />
				<span class="h2">CFTimer Times</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('time')"><img vspace="4" src="#display?minus:plus#" id="time_img"></a>
						</td>
						<td>
							<table class="tbl"  cellpadding="2" cellspacing="0">
								<tr>
									<td align="right" nowrap>#timers.recordcount#</td>
									<td>&nbsp;Timer#timers.recordcount GT 1?'s':''# set</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="time_body" style="display:#display?"":"none"#;"> 
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="tblHead" align="center">Label</td>
									<td class="tblHead">Time</td>
									<td class="tblHead">Template</td>
								</tr>
								<loop query="timers">
									<tr>
										<td align="right" class="tblContent" nowrap>#timers.label#</td>
										<td align="right" class="tblContent" nowrap>#formatUnit(arguments.custom.unit, timers.time)#</td>
										<td align="right" class="tblContent" nowrap>#timers.template#</td>
									</tr>
								</loop>
							</table>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			<!--- Traces --->
			<if isEnabled(arguments.custom,"tracing") and traces.recordcount>
				<set display=structKeyExists(cookie,'railo_debug_modern_trace') and cookie.railo_debug_modern_trace />
				<set hasAction=!isColumnEmpty(traces,'action') />
				<set hasCategory=!isColumnEmpty(traces,'category') />
				<span class="h2">Trace Points</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('trace')"><img vspace="4" src="#display?minus:plus#" id="trace_img"></a>
						</td>
						<td>
							<table class="tbl"  cellpadding="2" cellspacing="0">
								<tr>
									<td align="right" nowrap>#traces.recordcount#</td>
									<td>&nbsp;Trace#traces.recordcount GT 1?'s':''# set</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="trace_body" style="display:#display?"":"none"#;"> 
							<table class="tbl" cellpadding="2" cellspacing="0">
								<tr>
									<td class="tblHead">Type</td>
									<if hasCategory>
										<td class="tblHead">Category</td>
									</if>
									<td class="tblHead">Text</td>
									<td class="tblHead">Template</td>
									<td class="tblHead">Line</td>
									<if hasAction>
										<td class="tblHead">Action</td>
									</if>
									<td class="tblHead">Var</td>
									<td class="tblHead">Total Time</td>
									<td class="tblHead">Trace Slot Time</td>
								</tr>
								<set total=0 />
								<loop query="traces">
									<set total=total+traces.time />
									<tr>
										<td align="left" class="tblContent" nowrap>#traces.type#</td>
										<if hasCategory>
											<td align="left" class="tblContent" nowrap>#traces.category#&nbsp;</td>
										</if>
										<td align="let" class="tblContent" nowrap>#traces.text#&nbsp;</td>
										<td align="left" class="tblContent" nowrap>#traces.template#</td>
										<td align="right" class="tblContent" nowrap>#traces.line#</td>
										<if hasAction>
											<td align="left" class="tblContent" nowrap>#traces.action#</td>
										</if>
										<td align="left" class="tblContent" nowrap>
											<if len(traces.varName)>
												#traces.varName#
												<if structKeyExists(traces,'varValue')>
													= #traces.varValue#
												</if>
											<else>
												&nbsp;
												<br />
											</if>
										</td>
										<td align="right" class="tblContent" nowrap>#formatUnit(arguments.custom.unit, total)#</td>
										<td align="right" class="tblContent" nowrap>#formatUnit(arguments.custom.unit, traces.time)#</td>
									</tr>
								</loop>
							</table>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			<!--- Queries --->
			<if isEnabled(arguments.custom,"database") and queries.recordcount>
				<set local.total=0 />
				<set local.records=0 />
				<loop query="queries"><set total+=queries.time />
					<set records+=queries.count /></loop>
				<set display=structKeyExists(cookie,'railo_debug_modern_qry') and cookie.railo_debug_modern_qry />
				<span class="h2">SQL Queries</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<a href="javascript:railoDebugModernToggle('qry')"><img vspace="4" src="#display?minus:plus#" id="qry_img"></a>
						</td>
						<td>
							<table class="tbl"  cellpadding="2" cellspacing="0">
								<tr>
									<td nowrap>#queries.recordcount#</td>
									<td>&nbsp;Quer#timers.recordcount GT 1?'ies':'y'# executed</td>
								</tr>
								<tr>
									<td nowrap>#formatUnit(total, queries.time)#</td>
									<td>&nbsp;Total execution time</td>
								</tr>
								<tr>
									<td nowrap>#records#</td>
									<td>&nbsp;Records</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<div id="qry_body" style="display:#display?"":"none"#;"> 
							<loop query="queries">
								<code>
									<b>#queries.name#</b>
									(Datasource=#queries.datasource#, Time=#formatUnit(arguments.custom.unit, queries.time)#, Records=#queries.count#) in #queries.src#
								</code>
								<br/>
								<if ListFindNoCase(queries.columnlist,'usage') and IsStruct(queries.usage)>
									<set local.usage=queries.usage />
									<set local.lstNeverRead="" />
									<set local.lstRead = "" />
									<loop collection="#usage#" index="local.item" item="local.value">
										<if not value>
											<set lstNeverRead=ListAppend(lstNeverRead,item,', ') />
										<else>
											<set lstRead=ListAppend(lstRead,item,', ') />
										</if>
									</loop>
									<b>Query usage within the request:</b>
									<br />
									<if len(lstRead)>
										<font color="green">
											used columns: <b>#lstRead#</b>
										</font>
										<br />
									</if>
									<if len(lstNeverRead)>
										<font color="red">
											unused columns: <b>#lstNeverRead#</b>
											<br />
											Usage: <b>#numberFormat(listLen(lstRead)/(listLen(lstRead)+listLen(lstNeverRead))*100, "999.9")# %</b>
										</font>
									</if>
								</if>
								<br /><b>SQL:</b>
								<pre>#queries.sql#</pre>
							</loop>
							<br>
							</div> 
						</td>
					</tr>
				</table>
			</if>
			
			
			
			<!--- Scopes --->
			<if isEnabled(arguments.custom,"scopes")>
				
				<set local.scopes = "application,CGI,cookie,form,request,server,URL">
			
			
				<span class="h2">Scope Information</span>
				<table class="tbl" cellpadding="0" cellspacing="0">
					
							<loop list="#local.scopes#" index="local.k">
								<set local.v=evaluate(k)>
								<set local.display=structKeyExists(cookie,'railo_debug_modern_scope_#k#') and cookie['railo_debug_modern_scope_#k#'] />
								
									<td valign="top" nowrap="true">
										<a href="javascript:railoDebugModernToggle('scope_#k#')"><img vspace="4" src="#display?minus:plus#" id="scope_#k#_img"></a> 
										&nbsp;&nbsp;
									</td>
									<td><b>#UCFirst(k)# Scope</b><br>
									<table class="tbl"  cellpadding="2" cellspacing="0">
										<!---<tr>
											<td align="right">Element Count</td>
											<td>&nbsp;#sizeOf.count#</td>
										</tr>--->
										<set local.sc=StructCount(v)>
										<tr>
											<td align="right">Estimate Size</td>
											<td>&nbsp;<try>#byteFormat(sc==0?0:sizeOf(v))#<catch>not available</catch></try></td>
										</tr>
									</table></td>
								</tr>
								<tr>
									<td></td>
									<td><div id="scope_#k#_body" style="display:#display?"":"none"#;">
										<if local.display>
										<try><dump var="#v#" keys="1000" label="#sc GT 1000?"First 1000 Records":""#"><catch>not available</catch></try>
										<else>
											the Scope will be displayed with the next request
										</if>
									</div></td>
								</tr>
							</loop>
							
				</table>
			</if>
			
			</td>
			</tr>
			</table>
		</output>

	</function>


	<function name="ReplaceSQLStatements" output="No" returntype="struct">
		<argument name="sSql" required="Yes" type="string" />
		<set var sSql = Replace(arguments.sSql, Chr(9), " ", "ALL") />
		<set var aWords = ['select','from','where','order by','group by','having'] />
		<loop from="1" to="3" index="local.i">
			<set sSql = Replace(sSql, "  ", " ", "ALL") />
			<set sSql = Replace(sSql, Chr(10), "", "ALL") />
			<set sSql = Replace(sSql, "#CHR(13)# #CHR(13)#", CHR(13), "ALL") />
		</loop>
		<set sSql = Replace(sSql, "#CHR(13)# #CHR(13)#", CHR(13), "ALL") />
		<loop collection="#aWords#" item="local.sWord">
			<set sSql = ReplaceNoCase(sSQL, aWords[sWord], "#UCase(aWords[sWord])##chr(9)#", "ALL") />
		</loop>
		<set local.stRet       = {} />
		<set stRet.sSql        = Trim(sSql) />
		<set stRet.Executeable = True />
		<set aWords = ["drop ,delete ,update ,insert ,alter database ,alter table "] />
		<loop collection="#aWords#" item="sWord">
			<if FindNoCase(aWords[sWord], sSql)>
				<set stRet.Executeable = False />
				<break>
			</if>
		</loop>
		<return stRet />
	</function>

	<scriptX>
		function RGBtoHex(r,g,b){
			Var hexColor="";
			Var hexPart = '';
			Var i=0;
			   
			/* Loop through the Arguments array, containing the RGB triplets */
			for (i=1; i lte 3; i=i+1){
				/* Derive hex color part */
				hexPart = formatBaseN(Arguments[i],16);
				/* Pad with "0" if needed */
				if (len(hexPart) eq 1){ hexPart = '0' & hexPart; } 
				      
				/* Add hex color part to hexadecimal color string */
				hexColor = hexColor & hexPart;
			}
			return '##' & hexColor;
		}
		
		/**
		 * do first Letter Upper case
		 * @param str String to operate
		 * @return uppercase string
		 */
		function uCaseFirst(String str) {
			var size=len(str);
			if(     size EQ 0)return str;
			else if(size EQ 1) return uCase(str);
			else {
				return uCase(mid(str,1,1))&mid(str,2,size);
			}
		}
		private function isEnabled(custom,key){
			return structKeyExists(arguments.custom,key) and (arguments.custom[arguments.key] EQ "Enabled" or arguments.custom[arguments.key] EQ "true");
		}
		
	</scriptX>
 
	<function name="formatUnit" output="no" returntype="string">
		<argument name="unit" type="string" required="yes" />
		<argument name="time" type="numeric" required="yes" />
		<if arguments.time GTE 100000000>
			<!--- 1000ms --->
			<return int(arguments.time/1000000)&" ms" />
		<elseif arguments.time GTE 10000000>
			<!--- 100ms --->
			<return (int(arguments.time/100000)/10)&" ms" />
		<elseif arguments.time GTE 1000000>
			<!--- 10ms --->
			<return (int(arguments.time/10000)/100)&" ms" />
		<else>
			<!--- 0ms --->
			<return (int(arguments.time/1000)/1000)&" ms" />
		</if>
		<return (arguments.time/1000000)&" ms" />
	</function>
	
	<function name="byteFormat" output="no">
        <argument name="raw" type="numeric">
        <if raw EQ 0><return "0b"></if>
        <set var b=raw>
        <set var rtn="">
        <set var kb=b/1024>
        <set var mb=kb/1024>
        <set var gb=mb/1024>
        <set var tb=gb/1024>
        
        <if tb GTE 1><return numberFormat(tb,'0.0')&"tb"></if>
        <if gb GTE 1><return numberFormat(gb,'0.0')&"gb"></if>
        <if mb GTE 1><return numberFormat(mb,'0.0')&"mb"></if>
        <if  b GT 100><return numberFormat(kb,'0.0')&"kb"></if>
		<return b&"b">
    </function>

</component>
