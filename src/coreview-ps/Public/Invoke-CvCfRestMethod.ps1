function Invoke-CvCfRestMethod {
	<#
	.SYNOPSIS
	Invokes a REST method using the specified CoreFlow endpoint.

	.DESCRIPTION
	The Invoke-CvCfRestMethod function is used to send HTTP requests to a
	specified CoreFlow endpoint. It supports various HTTP methods such as GET,
	POST, PUT, DELETE, etc. The function can return the response as a hashtable
	or as raw text when -AsText is specified.

	.PARAMETER Endpoint
	Specifies the API endpoint path to send the HTTP request to. The endpoint
	path should be relative to the API base URL and start with "/api". For
	example, "/api/workflows". If the request is not a CoreFlow request, the
	cmdlet Invoke-CvRestMethod should be used instead.

	.PARAMETER Method
	Specifies the HTTP method to use for the request. The default value is
	'Get'.

	.PARAMETER SearchParams
	Specifies the search parameters to include in the request URL. This
	optional parameter accepts a hashtable of key-value pairs.

	.PARAMETER Body
	Specifies the body content to include in the request. This optional
	parameter accepts a hashtable of key-value pairs.

	.PARAMETER AsText
	Indicates whether to return the response as raw text instead of a hashtable.
	If this switch is used, the function will return the raw response content as
	a string.

	.OUTPUTS
	If the -AsText switch is not used, the function returns the response as a
	hashtable. If the AsText switch is used, the function returns the raw
	response content as a string.

	.EXAMPLE
	Invoke-CvCfRestMethod -Endpoint 'api/workflows' -Method Get
	Invokes a GET request to the specified endpoint URL.

	.EXAMPLE
	Invoke-CvCfRestMethod -Endpoint 'api/workflows/<id>/publish' -Method Post
	Invokes a POST request to the specified endpoint URL.
	#>
	[OutputType([hashtable], ParameterSetName = 'AsHashtable')]
	[OutputType([string], ParameterSetName = 'AsText')]
	[CmdletBinding(ConfirmImpact = 'Low', DefaultParameterSetName = 'AsHashtable')]
	param (
		[Parameter(Mandatory, Position = 0)]
		[ValidateScript({ -not $_.IsAbsoluteUri }, ErrorMessage = "The endpoint should not be an absolute URL.")]
		[Uri]$Endpoint,

		[Parameter()]
		[Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,

		[Parameter()]
		[Hashtable]$SearchParams,

		[Parameter()]
		[Hashtable]$Body,

		[Parameter(ParameterSetName = 'AsText')]
		[switch]$AsText
	)

	$session = Get-CvSessionObject

	$params = @{
		Endpoint   = [Uri]::new($session.CoreFlowUrl, $Endpoint)
		HttpClient = $session.httpClient
		Method     = $Method
	}

	if ($SearchParams) { $params.SearchParams = $SearchParams }
	if ($Body) { $params.Body = $Body }
	if ($AsText) { $params.ReturnRawResponse = $true }

	$response = Invoke-CvRequest @params

	if ($AsText) {
		$response = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
	}

	# CoreFlow API responses are almost always wrapped in a 'data' object
	elseif ($response.ContainsKey('data')) {
		return $response.data
	}

	return $response
}
