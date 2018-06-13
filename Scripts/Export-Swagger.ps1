[CmdletBinding()]
param(
	[Parameter(Mandatory=$true)]
	[string]$ModulePath,
	[Parameter(Mandatory=$true)]
	[string]$FunctionAppName,
	[Parameter(Mandatory=$true)]
	[string]$ApiResourceName,
	[Parameter(Mandatory=$true)]
	[string]$ResourceGroup,
	[Parameter(Mandatory=$true)]
	[string]$OutputFilePath
)

Import-Module $ModulePath

$Swagger = Get-Swagger -FunctionAppName $FunctionAppName -ApiResourceName $ApiResourceName -ResourceGroupName $ResourceGroup
Write-Verbose -Message $($Swagger | ConvertTo-Json -Depth 20)

$FileName = "$($FunctionAppName)_swagger-def_$([DateTime]::Now.ToString("yyyyMMdd-hhmmss")).json"
Write-Verbose -Message "Filename: $FileName"

$OutputFile = New-Item -Path $OutputFilePath -Name $FileName
Set-Content -Path $OutputFile.FullName -Value ($Swagger | ConvertTo-Json -Depth 20)

# store the filename in a VSTS variable to be consumed by a later task
Write-Output "##vso[task.setvariable variable=SwaggerFile;]$FileName"
