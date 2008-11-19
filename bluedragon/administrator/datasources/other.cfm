<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Administrator.

	The Open BlueDragon Administrator is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Administrator is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Administrator.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfsavecontent variable="request.content">
<cfoutput>
	<cfparam name="url.dsn" type="string" default="" />
	<cfparam name="url.action" type="string" default="create" />
	
	<cfif not structKeyExists(session, "datasource")>
		<cfset session.message = "An error occurred while processing the datasource action." />
		<cflocation url="index.cfm" addtoken="false" />
	</cfif>
	
	<cfset dsinfo = session.datasource[1] />
	
	<script type="text/javascript">
		function showHideAdvSettings() {
			var advSettings = document.getElementById('advancedSettings');
			var advSettingsButton = document.getElementById('advSettingsButton');
			
			if (advSettings.style.visibility == 'visible') {
				advSettingsButton.value = 'Show Advanced Settings';
				advSettings.style.display= 'none';
				advSettings.style.visibility = 'hidden';
			} else {
				advSettingsButton.value = 'Hide Advanced Settings';
				advSettings.style.display = 'inline';
				advSettings.style.visibility = 'visible';
			}
		}
		
		function validate(f) {
			var ok = true;
			
			if (f.name.value.length == 0) {
				alert("Please enter the datasource name");
				ok = false;
			} else if (f.hoststring.value.length == 0) {
				alert("Please enter the JDBC URL");
				ok = false;
			} else if (f.drivername.value.length == 0) {
				alert("Please enter the JDBC driver name");
				ok = false;
			}
			
			return ok;
		}
	</script>
	<h3>Configure Datasource - Other</h3>
	<br />
	<cfif structKeyExists(session, "message")>
	<p style="color:red;font-weight:bold;">#session.message#</p>
	</cfif>

	<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
		<p class="message">The following errors occurred:</p>
		<ul>
		<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
			<li>#session.errorFields[i][2]#</li>
		</cfloop>
		</ul>
	</cfif>
	
	<!--- TODO: need explanatory tooltips/mouseovers on all these settings, esp. 'per request connections' which 
			from my understanding is the opposite of Adobe CF's description 'maintain connections across client requests'--->
	<form name="datasourceForm" action="_controller.cfm?action=processDatasourceForm" method="post" 
			onsubmit="return validate(this);">
	<table border="0">
		<tr>
			<td><label for="name">OpenBD Datasource Name</label></td>
			<td>
				<input name="name" id="name" type="text" size="30" maxlength="50" value="#dsinfo.name#" tabindex="1" />
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="hoststring">JDBC URL</label></td>
			<td valign="top">
				<textarea name="hoststring" id="hoststring" cols="40" rows="4" tabindex="2">#dsinfo.hoststring#</textarea>
			</td>
		</tr>
		<tr>
			<td><label for="drivername">Driver Class</label></td>
			<td>
				<input name="drivername" id="drivername" type="text" size="30" maxlength="250" value="#dsinfo.drivername#" 
						tabindex="3" />
			</td>
		</tr>
		<tr>
			<td><label for="username">User Name</label></td>
			<td>
				<input name="username" id="username" type="text" size="30" maxlength="50" value="#dsinfo.username#" tabindex="4" />
			</td>
		</tr>
		<tr>
			<td><label for="password">Password</label></td>
			<td>
				<input name="password" id="password" type="password" size="30" maxlength="16" value="#dsinfo.password#" 
						tabindex="5" />
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="description">Description</label></td>
			<td valign="top">
				<textarea name="description" id="description" rows="4" cols="40" tabindex="6"><cfif structKeyExists(dsinfo, "description")>#dsinfo.description#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="verificationquery">Verification Query</label></td>
			<td valign="top">
				<textarea name="verificationquery" id="verificationquery" rows="4" cols="40" tabindex="7"><cfif structKeyExists(dsinfo, "verificationquery")>#dsinfo.verificationquery#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" id="advSettingsButton" name="showAdvSettings" value="Show Advanced Settings" 
						onclick="javascript:showHideAdvSettings();" tabindex="8" />
			</td>
			<td align="right">
				<input type="submit" name="submit" value="Submit" tabindex="9" />
				<input type="button" name="cancel" value="Cancel" onclick="javascript:location.replace('index.cfm');" 
						tabindex="10" />
			</td>
		</tr>
	</table>
	<div id="advancedSettings" style="display:none;visibility:hidden;">
	<br />
	<table border="0">
		<tr>
			<td valign="top"><label for="initstring">Initialization String</label></td>
			<td valign="top">
				<textarea name="initstring" id="initstring" rows="4" cols="40" tabindex="11">#dsinfo.initstring#</textarea>
			</td>
		</tr>
		<tr>
			<td valign="top">SQL Operations</td>
			<td valign="top">
				<table border="0">
					<tr>
						<td>
							<input type="checkbox" name="sqlselect" id="sqlselect" value="true"
									<cfif dsinfo.sqlselect> checked="true"</cfif> tabindex="12" />
							<label for="sqlselect">SELECT</label>
						</td>
						<td>
							<input type="checkbox" name="sqlinsert" id="sqlinsert" value="true"
									<cfif dsinfo.sqlinsert> checked="true"</cfif> tabindex="13" />
							<label for="sqlinsert">INSERT</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="sqlupdate" id="sqlupdate" value="true"
									<cfif dsinfo.sqlupdate> checked="true"</cfif> tabindex="14" />
							<label for="sqlupdate">UPDATE</label>
						</td>
						<td>
							<input type="checkbox" name="sqldelete" id="sqldelete" value="true"
									<cfif dsinfo.sqldelete> checked="true"</cfif> tabindex="15" />
							<label for="sqldelete">DELETE</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="sqlstoredprocedures" id="sqlstoredprocedures" value="true"
									<cfif dsinfo.sqlstoredprocedures> checked="true"</cfif> tabindex="16" />
							<label for="sqlstoredprocedures">Stored Procedures</label>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td><label for="perrequestconnections">Per-Request Connections</label></td>
			<td>
				<input type="checkbox" name="perrequestconnections" id="perrequestconnections" value="true"
						<cfif dsinfo.perrequestconnections> checked="true"</cfif> tabindex="17" />
			</td>
		</tr>
		<tr>
			<td><label for="maxconnections">Maximum Connections</label></td>
			<td>
				<input type="text" name="maxconnections" id="maxconnections" size="4" maxlength="4" 
						value="#dsinfo.maxconnections#" tabindex="18" />
			</td>
		</tr>
		<tr>
			<td><label for="connectiontimeout">Connection Timeout</label></td>
			<td>
				<input type="text" name="connectiontimeout" id="connectiontimeout" size="4" maxlength="10" 
						value="#dsinfo.connectiontimeout#" tabindex="19" />
			</td>
		</tr>
		<tr>
			<td><label for="logintimeout">Login Timeout</label></td>
			<td>
				<input type="text" name="logintimeout" id="logintimeout" size="4" maxlength="4" 
						value="#dsinfo.logintimeout#" tabindex="20" />
			</td>
		</tr>
		<tr>
			<td><label for="connectionretries">Connection Retries</label></td>
			<td>
				<input type="text" name="connectionretries" id="connectionretries" size="4" maxlength="4" 
						value="#dsinfo.connectionretries#" tabindex="21" />
			</td>
		</tr>
	</table>
	</div>
		<input type="hidden" name="drivername" value="#dsinfo.drivername#" />
		<input type="hidden" name="datasourceAction" value="#url.action#" />
		<input type="hidden" name="existingDatasourceName" value="#dsinfo.name#" />
		<input type="hidden" name="dbtype" value="other" />
	</form>
</cfoutput>
<cfset structDelete(session, "message", false) />
<cfset structDelete(session, "datasource", false) />
<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
