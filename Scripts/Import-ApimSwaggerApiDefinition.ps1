<#
.SYNOPSIS
Update an APIM API with a swagger definition

.PARAMETER ResourceGroupName
The name of the resource group that contains the APIM instnace

.PARAMETER InstanceName
The name of the APIM instnace

.PARAMETER ApiName
The name of the API to update

.PARAMETER SwaggerSpecificationUrl
The full path to the swagger defintion

For example:
https://sit-manage-vacancy.apprenticeships.sfa.bis.gov.uk/swagger/docs/v1

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [String]$ApimResourceGroup,
    [Parameter(Mandatory=$true)]
    [String]$InstanceName,
    [Parameter(Mandatory=$true)]
    [String]$ApiName,
    [Parameter(Mandatory=$true, ParameterSetName="Url")]
    [String]$SwaggerSpecificationUrl,
    [Parameter(Mandatory=$true, ParameterSetName="File")]
    [Switch]$SwaggerSpecificationFile,
    [Parameter(Mandatory=$true, ParameterSetName="File")]
	[string]$ModulePath,
	[Parameter(Mandatory=$true, ParameterSetName="File")]
    [string]$FunctionAppName,
    [Parameter(Mandatory=$false, ParameterSetName="File")]
    [string]$FunctionAppDomain = "azurewebsites.net",
	[Parameter(Mandatory=$true, ParameterSetName="File")]
	[string]$ApiResourceName,
	[Parameter(Mandatory=$true, ParameterSetName="File")]
	[string]$FunctionAppResourceGroup,
	[Parameter(Mandatory=$true, ParameterSetName="File")]
	[string]$OutputFilePath

)

if ($PSCmdlet.ParameterSetName -eq "File") {
    Import-Module $ModulePath

    $Swagger = Get-Swagger -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain -ApiResourceName $ApiResourceName -ResourceGroupName $FunctionAppResourceGroup
    Write-Verbose -Message $($Swagger | ConvertTo-Json -Depth 20)

    $FileName = "$($FunctionAppName)_swagger-def_$([DateTime]::Now.ToString("yyyyMMdd-hhmmss")).json"
    Write-Verbose -Message "Filename: $FileName"

    $OutputFolder = New-Item -Path $OutputFilePath -ItemType Directory
    $OutputFile = New-Item -Path "$($OutputFolder.FullName)\$FileName" -ItemType File
    Write-Verbose -Message "OutputFile: $($OutputFile.FullName)"
    Set-Content -Path $OutputFile.FullName -Value ($Swagger | ConvertTo-Json -Depth 20)
}

try {
    # --- Build context and retrieve apiid
    Write-Host "Building APIM context for $ApimResourceGroup\$InstanceName"
    $Context = New-AzureRmApiManagementContext -ResourceGroupName $ApimResourceGroup -ServiceName $InstanceName
    Write-Host "Retrieving ApiId for API $ApiName"
    $Api = Get-AzureRmApiManagementApi -Context $Context -ApiId $ApiName

    # --- Throw if Api is null
    if (!$Api) {
        throw "Could not retrieve Api for API $ApiName"
    }

    # --- Import swagger definition
    
    if($PSCmdlet.ParameterSetName -eq "Url") {
        Write-Host "Updating API $InstanceName\$ApiId from definition $SwaggerSpecficiationUrl"
        Import-AzureRmApiManagementApi -Context $Context -SpecificationFormat "Swagger" -SpecificationUrl $SwaggerSpecificationUrl -ApiId $($Api.ApiId) -Path $($Api.Path) -ErrorAction Stop -Verbose:$VerbosePreference
    }
    elseif ($PSCmdlet.ParameterSetName -eq "File") {
        Write-Host "Updating API $InstanceName\$ApiId from definition $($OutputFile.FullName)"
        Import-AzureRmApiManagementApi -Context $Context -SpecificationFormat "Swagger" -SpecificationPath $($OutputFile.FullName) -ApiId $($Api.ApiId) -Path $($Api.Path) -ErrorAction Stop -Verbose:$VerbosePreference
    }
} catch {
   throw $_
}