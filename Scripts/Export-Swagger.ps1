[CmdletBinding()]
param(
	[Parameter(Mandatory=$true)]
	[string]$SwaggerUri,
	[Parameter(Mandatory=$true)]
	[string]$FunctionAppName,
	[Parameter(Mandatory=$true)]
	[string]$ResourceGroup,
	[Parameter(Mandatory=$true)]
	[string]$OutputFilePath
)

$Swagger = Invoke-RestMethod -Method GET -Uri "$SwaggerUri"
Write-Verbose -Message $($Swagger | ConvertTo-Json)

$FileName = "$($FunctionAppName)_swagger-def_$([DateTime]::Now.ToString("yyyyMMdd-hhmmss")).json"
Write-Verbose -Message "Filename: $FileName"

$OutputFile = New-Item -Path $OutputFilePath -Name $FileName
Set-Content -Path $OutputFile.FullName -Value ($Swagger | ConvertTo-Json)

# store the filename in a VSTS variable to be consumed by a later task
Write-Output "##vso[task.setvariable variable=SwaggerFile;]$FileName"
