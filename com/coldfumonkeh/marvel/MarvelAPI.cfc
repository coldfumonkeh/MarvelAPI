<cfcomponent output="false">
	
	<cfproperty name="public_key" 	type="string" default="" />
	<cfproperty name="private_key" 	type="string" default="" />
	<cfproperty name="api_endpoint" type="string" default="" />
	
	
	<cffunction name="init" output="false" hint="The constructor method for the Marvel API CFC.">
		<cfargument name="public_key" 	required="true" 	type="string" 					hint="Your API public key." />
		<cfargument name="private_key" 	required="true" 	type="string" 					hint="Your API private key." />
		<cfargument name="parseResults"	required="false" 	type="boolean" default="false" 	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset setPublicKey(arguments.public_key) />
			<cfset setPrivateKey(arguments.private_key) />
			<cfset variables.parseResults = arguments.parseResults />
			<cfset variables.api_endpoint = "http://gateway.marvel.com/" />
			<cfset variables.jDate = createobject("java", "java.util.Date") />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPublicKey" output="false" access="private" hint="I set the public key value.">
		<cfargument name="public_key" required="true" type="string" hint="Your API public key." />
		<cfset variables.public_key = arguments.public_key />
	</cffunction>
	
	<cffunction name="setPrivateKey" output="false" access="private" hint="I set the private key value.">
		<cfargument name="private_key" required="true" type="string" hint="Your API private key." />
		<cfset variables.private_key = arguments.private_key />
	</cffunction>
	
	<cffunction name="getPublicKey" output="false" access="private" hint="I get the public key value.">
		<cfreturn variables.public_key />
	</cffunction>
	
	<cffunction name="getPrivateKey" output="false" access="private" hint="I get the private key value.">
		<cfreturn variables.private_key />
	</cffunction>
	
	<cffunction name="getAPIEndpoint" output="false" access="private" hint="I get the API endpoint value.">
		<cfreturn variables.api_endpoint />
	</cffunction>
	
	<cffunction name="getparseResults" output="false" access="private" returntype="string" hint="I return the parseResults value for use in the method calls.">
		<cfreturn variables.parseResults />
	</cffunction>
	
	<cffunction name="generateTimeStamp" output="false" access="private" hint="I create the timestamp for each request">
		<cfreturn variables.jDate.getTime() />
	</cffunction>
	
	<cffunction name="generateRequestURL" output="false" access="private" hint="I generate the hash value for each request.">
		<cfset var strAPIAuthParams = '' />
		<cfset var strPublicKey = getPublicKey() />
		<cfset var strTimeStamp = generatetimeStamp() />
			<cfset strAPIAuthParams = '?ts=' & strTimeStamp & '&apikey=' & strPublicKey & '&hash=' & lcase(hash(strTimeStamp & getPrivateKey() & strPublicKey, "MD5")) />
		<cfreturn strAPIAuthParams />
	</cffunction>
	
	<cffunction name="makeAPIRequest" output="false" access="private" hint="I make the request to the API.">
		<cfargument name="request_url" required="true" type="string" hint="The URL of the request." />
			<cfhttp url="#arguments.request_url#" method="GET" />
		<cfreturn cfhttp.fileContent />
	</cffunction>
	
	<!--- START API METHODS --->
	
	<!--- /v1/public/characters --->
	<cffunction name="getCharacters" output="false" access="public" hint="Fetches lists of characters.">
		<cfargument name="name" 			required="false" type="string" 	hint="Return only characters matching the specified full character name (e.g. Spider-Man)." />
		<cfargument name="modifiedSince" 	required="false" type="date" 	hint="Return only characters which have been modified since the specified date." />
		<cfargument name="comics" 			required="false" type="numeric" hint="Return only characters which appear in the specified comics (accepts comma-separated list of ids)." />
		<cfargument name="series" 			required="false" type="numeric" hint="Return only characters which appear in the specified series (accepts comma-separated list of ids)." />
		<cfargument name="events" 			required="false" type="numeric" hint="Return only characters which appear in the specified events (accepts comma-separated list of ids)." />
		<cfargument name="stories" 			required="false" type="numeric" hint="Return only characters which appear in the specified stories (accepts comma-separated list of ids)." />
		<cfargument name="orderBy" 			required="false" type="string" 	hint="Order the result set by a field or fields. Add a '-' to the value to sort in descending order. Multiple values are given priority in the order in which they are passed." />
		<cfargument name="limit" 			required="false" type="numeric" hint="Limit the result set to the specified number of resources." />
		<cfargument name="offset" 			required="false" type="numeric" hint="Skip the specified number of resources in the result set.." />
			<cfset var strAPIRequestURL = getAPIEndpoint() & 'v1/public/characters' & generateRequestURL() />		
			<cfset strReturn = makeAPIRequest(manageURLParams(strAPIRequestURL, arguments)) />
		<cfreturn handleReturnFormat(strReturn) />
	</cffunction>
	
	<!--- /v1/public/characters/{characterid} --->
	<cffunction name="getCharacterByID" output="false" access="public" hint="Fetches a single character by id.">
		<cfargument name="characterId" required="true" type="number" hint="A single character id." />
			<cfset var strAPIRequestURL = getAPIEndpoint() & 'v1/public/characters/' & arguments.characterId & generateRequestURL() />		
			<cfset var strReturn = makeAPIRequest(manageURLParams(strAPIRequestURL, arguments)) />
		<cfreturn handleReturnFormat(strReturn) />
	</cffunction>
	
	<!--- /v1/public/characters/{characterid}/comics --->
	<cffunction name="getCharacterComics" output="false" access="public" hint="Fetches a list of comics filtered by a character id.">
		<cfargument name="characterId" 			required="true" 	type="number" 	hint="A single character id." />
		<cfargument name="format" 				required="false" 	type="string" 	hint="Filter by the issue format (e.g. comic, digital comic, hardcover)." />
		<cfargument name="formatType" 			required="false" 	type="string" 	hint="Filter by the issue format type (comic or collection)." />
		<cfargument name="noVariants" 			required="false" 	type="boolean" 	hint="Exclude variant comics from the result set." />
		<cfargument name="dateDescriptor" 		required="false" 	type="string" 	hint="Return comics within a predefined date range." />
		<cfargument name="dateRange" 			required="false" 	type="number" 	hint="Return comics within a predefined date range. Dates must be specified as date1,date2 (e.g. 2013-01-01,2013-01-02). Dates are preferably formatted as YYYY-MM-DD but may be sent as any common date format." />
		<cfargument name="modifiedSince" 		required="false" 	type="date" 	hint="Return only comics which have been modified since the specified date." />
		<cfargument name="creators" 			required="false" 	type="numeric" hint="Return only comics which feature work by the specified creators (accepts comma-separated list of ids)." />
		<cfargument name="series" 				required="false" 	type="numeric" hint="Return only comics which are part of the specified series (accepts comma-separated list of ids)." />
		<cfargument name="events" 				required="false" 	type="numeric" hint="Return only comics which take place in the specified events (accepts comma-separated list of ids)." />
		<cfargument name="stories" 				required="false" 	type="numeric" hint="Return only comics which contain the specified stories (accepts comma-separated list of ids)." />
		<cfargument name="sharedAppearances" 	required="false" 	type="numeric" hint="Return only comics which the specified characters appear together (for example in which BOTH Spider-Man and Wolverine appear)." />
		<cfargument name="collaborators" 		required="false" 	type="numeric" hint="Return only comics in which the specified creators worked together (for example in which BOTH Stan Lee and Jack Kirby did work)." />
		<cfargument name="orderBy" 				required="false" 	type="string" 	hint="Order the result set by a field or fields. Add a '-' to the value to sort in descending order. Multiple values are given priority in the order in which they are passed." />
		<cfargument name="limit" 				required="false" 	type="numeric" hint="Limit the result set to the specified number of resources." />
		<cfargument name="offset" 				required="false" 	type="numeric" hint="Skip the specified number of resources in the result set.." />
			<cfset var strAPIRequestURL = getAPIEndpoint() & 'v1/public/characters/' & arguments.characterId & '/comics' &  generateRequestURL() />		
			<cfset var strReturn = makeAPIRequest(manageURLParams(strAPIRequestURL, arguments)) />
		<cfreturn handleReturnFormat(strReturn) />
	</cffunction>
	
	<!--- /v1/public/characters/{characterid}/events --->
	<cffunction name="getCharacterEvents" output="false" access="public" hint="Fetches a list of events filtered by a character id.">
		<cfargument name="characterId" 			required="true" 	type="number" 	hint="A single character id." />
		<cfargument name="name" 				required="false" 	type="string" 	hint="Filter the event list by name." />
		<cfargument name="modifiedSince" 		required="false" 	type="date" 	hint="Return only events which have been modified since the specified date." />
		<cfargument name="creators" 			required="false" 	type="numeric" 	hint="Return only events which feature work by the specified creators (accepts comma-separated list of ids)." />
		<cfargument name="series" 				required="false" 	type="numeric" 	hint="Return only events which are part of the specified series (accepts comma-separated list of ids)." />
		<cfargument name="comics" 				required="false" 	type="numeric" 	hint="Return only events which take place in the specified comics (accepts comma-separated list of ids)." />
		<cfargument name="stories" 				required="false" 	type="numeric" 	hint="Return only events which contain the specified stories (accepts comma-separated list of ids)." />
		<cfargument name="orderBy" 				required="false" 	type="string" 	hint="Order the result set by a field or fields. Add a '-' to the value to sort in descending order. Multiple values are given priority in the order in which they are passed." />
		<cfargument name="limit" 				required="false" 	type="numeric" 	hint="Limit the result set to the specified number of resources." />
		<cfargument name="offset" 				required="false" 	type="numeric" 	hint="Skip the specified number of resources in the result set.." />
			<cfset var strAPIRequestURL = getAPIEndpoint() & 'v1/public/characters/' & arguments.characterId & '/events' &  generateRequestURL() />		
			<cfset var strReturn = makeAPIRequest(manageURLParams(strAPIRequestURL, arguments)) />
		<cfreturn handleReturnFormat(strReturn) />
	</cffunction>
	
	<!--- /v1/public/characters/{characterid}/stories --->
	<cffunction name="getCharacterStories" output="false" access="public" hint="Fetches a list of stories filtered by a character id.">
		<cfargument name="characterId" 			required="true" 	type="number" 	hint="A single character id." />
		<cfargument name="modifiedSince" 		required="false" 	type="date" 	hint="Return only stories which have been modified since the specified date." />
		<cfargument name="comics" 				required="false" 	type="numeric" 	hint="Return only stories which take place in the specified comics (accepts comma-separated list of ids)." />
		<cfargument name="series" 				required="false" 	type="numeric" 	hint="Return only stories which are part of the specified series (accepts comma-separated list of ids)." />
		<cfargument name="events" 				required="false" 	type="numeric" 	hint="Return only stories which take place during the specified events (accepts comma-separated list of ids)." />
		<cfargument name="creators" 			required="false" 	type="numeric" 	hint="Return only stories which feature work by the specified creators (accepts comma-separated list of ids)." />
		<cfargument name="orderBy" 				required="false" 	type="string" 	hint="Order the result set by a field or fields. Add a '-' to the value to sort in descending order. Multiple values are given priority in the order in which they are passed." />
		<cfargument name="limit" 				required="false" 	type="numeric" 	hint="Limit the result set to the specified number of resources." />
		<cfargument name="offset" 				required="false" 	type="numeric" 	hint="Skip the specified number of resources in the result set.." />
			<cfset var strAPIRequestURL = getAPIEndpoint() & 'v1/public/characters/' & arguments.characterId & '/events' &  generateRequestURL() />		
			<cfset var strReturn = makeAPIRequest(manageURLParams(strAPIRequestURL, arguments)) />
		<cfreturn handleReturnFormat(strReturn) />
	</cffunction>
	
	
	<!--- UTILS --->
		
	<cffunction name="generateImage" access="public" output="false" returnType="string" hint="I generate a URL for an image.">
		<cfargument name="imageData" 		required="true" type="struct" hint="A struct containing both path and extension values." />
		<cfargument name="image_variant" 	required="true" type="string" hint="The image variant to obtain." />
			<cfset var strFullImagepath = '' />
				<cfif structKeyExists(arguments.imageData, 'path') AND structKeyExists(arguments.imageData, 'extension')>
					<cfset strFullImagepath = arguments.imageData['path'] />
					<cfif len(arguments.image_variant)>
						<cfset strFullImagepath = strFullImagepath & '/' & arguments.image_variant />
					</cfif>
					<cfset strFullImagepath = strFullImagepath & '.' & arguments.imageData['extension'] />
				</cfif>
		<cfreturn strFullImagepath />
	</cffunction>
	
	<!---
	Portrait aspect ratio:
	
	portrait_small 	50x75px
	portrait_medium 	100x150px
	portrait_xlarge 	150x225px
	portrait_fantastic 	168x252px
	portrait_uncanny 	300x450px
	portrait_incredible 	216x324px
	
	Standard aspect ratio:
	
	standard_small 	65x45px
	standard_medium 	100x100px
	standard_large 	140x140px
	standard_xlarge 	200x200px
	standard_fantastic 	250x250px
	standard_amazing 	180x180px
	
	Landscape aspect ratio:
	
	landscape_small 	120x90px
	landscape_medium 	175x30px
	landscape_large 	190x140px
	landscape_xlarge 	270x200px
	landscape_amazing 	250x156px
	landscape_incredible 	464x261px
	
	Full size images:
	
	detail 	full image, constrained to 500px wide
	full-size image 	no variant descriptor
	--->
		
	<cffunction name="manageURLParams" access="private" output="false" hint="I am used to manage the query params and append provided parameters if necessary.">
		<cfargument name="request_url" required="true" type="string" hint="The URL to request." />
		<cfargument name="parameters"  required="true" type="struct" hint="The arguments sent to each request." />
			<cfset var strAPIRequestURL = arguments.request_url />
			<cfset var strURLParams = buildParamString(arguments.parameters) />
				<cfif len(strURLParams)>
					<cfset strAPIRequestURL = strAPIRequestURL & '&' & strURLParams />
				</cfif>
		<cfreturn strAPIRequestURL />
	</cffunction>
		
	<cffunction name="handleReturnFormat" access="public" output="false" hint="I handle how the data is returned based upon the provided format">
		<cfargument name="data" required="true" type="string" hint="The data returned from the API." />
			<cfif getparseResults()>
				<cfreturn DeserializeJSON(arguments.data) />
			<cfelse>
				<cfreturn arguments.data.toString() />
			</cfif>
			<cfabort>
	</cffunction>
		
	<cffunction name="buildParamString" access="public" output="false" returntype="String" hint="I loop through a struct to convert to query params for the URL">
		<cfargument name="argScope" required="true" type="struct" hint="I am the struct containing the method params" />
			<cfset var strURLParam = '' />
				<cfloop collection="#arguments.argScope#" item="local.key">
					<cfif len(arguments.argScope[key])>
						<cfif listLen(strURLParam)>
							<cfset strURLParam = strURLParam & '&' />
						</cfif>
						<cfset strURLParam = strURLParam & lcase(key) & '=' & arguments.argScope[key] />
					</cfif>
				</cfloop>
		<cfreturn strURLParam />
	</cffunction>
	
</cfcomponent>