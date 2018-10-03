<#   
    .SYNOPSIS
    Uses the Azure REST API to set the Sampling Percentage of a APIM API logger

    .EXAMPLE
    Set-AzureRmApiManagementLoggerSettings.ps1 -SubscriptionId "962cae10-2950-412a-93e3-d8ae92b17896" -ResourceGroupName "dss-at-shared-rg" -ApimInstanceName "dss-at-shared-apim" -ApiName "ActionPlans" -ApimLoggerId "dss-at-apim-ai-logger" -ApimApiLoggerId "applicationinsights" -SamplingPercentage 100 -TenantId "1a92889b-8ea1-4a16-8132-347814051567" -ApplicationId "6ea292bf-3532-4c09-9be7-668aaee20b8d" -AppRegistrationKey $AppRegistrationKey -Verbose

    .NOTES
    https://docs.microsoft.com/en-us/rest/api/apimanagement/diagnostic/createorupdate
#>  
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApimInstanceName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApiName,

    #The name of the APIM instance logger, found in the portal under {APIM instance} > Monitoring > Application Insights or using PowerShell cmdlet Get-AzureRmApiManagementLogger
    [Parameter(Mandatory=$true)]
    [string]$ApimLoggerId,

    <#The name of the logger for this API, if created using an ARM template it will normally be set to applicationinsights.
    This property isn't exposed in the Portal or via PowerShell but can be found at https://resources.azure.com by navigating to
    https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ApiManagement/service/{apimInstance}/apis/{apiName}/diagnostics?api-version=2018-01-01
    The name is the last section of the id property#>
    [Parameter(Mandatory=$true)]
    [string]$ApimApiLoggerId,

    #Required.  Between 0 and 100%, the sampling percentage will have a performance impact - https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-app-insights#performance-implications-and-log-sampling
    [Parameter(Mandatory=$true)]
    [int]$SamplingPercentage,

    #Required.  The tenant id for the AAD tenant supplying the bearer token.
    [Parameter(Mandatory=$true)]
    [Guid]$TenantId,

    #Required.  The ApplicationId of the AAD registered application that will be requesting the bearer token.
    [Parameter(Mandatory=$true)]
    [Guid]$ApplicationId,
    
    #Required.  They key for the AAD registered application application that will be requesting the bearer token.
    [Parameter(Mandatory=$true)]
    [string]$AppRegistrationKey
)

Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Helpers.psm1).Path

$SecurePassword = ConvertTo-SecureString $AppRegistrationKey -Force -AsPlainText

Write-Verbose "Requesting bearer token"
$BearerToken = Get-AzureApiBearerToken -TenantId $TenantId -ApplicationId $ApplicationId -AppRegistrationKey $SecurePassword
Write-Verbose "Bearer token obtained`n$($BearerToken.access_token)"

$Body = @{
    "properties" = @{
        "alwaysLog" = "allErrors"
        "loggerId" = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ApiManagement/service/$ApimInstanceName/loggers/$ApimLoggerId"
        "sampling" = @{
            "samplingType" = "fixed"
            "percentage" = $SamplingPercentage
        }
        "frontend" = @{
            "request" = @{
              "headers" = @(
              )
              "body" = @{
                "bytes" = 0
              }
            }
            "response"= @{
              "headers"= @(
              )
              "body"= @{
                "bytes"= 0
              }
            }
        }
        "backend"= @{
            "request"= @{
                "headers"= @(
                )
                "body"= @{
                    "bytes"= 0
                }
            }
            "response"= @{
                "headers"= @(
                )
                "body"= @{
                    "bytes"= 0
                }
            }
        }
    }
}

$Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ApiManagement/service/$ApimInstanceName/apis/$ApiName/diagnostics/$($ApimApiLoggerId)?api-version=2018-06-01-preview"
Write-Verbose "Calling Azure REST API method`n$Uri"
Write-Verbose -Message "Sending Body: `n$($Body | ConvertTo-Json -Depth 4)"
Invoke-RestMethod -Method PUT -Uri $Uri -Headers @{Authorization = "Bearer $($BearerToken.access_token)"} -Body ($Body | ConvertTo-Json -Depth 4) -ContentType "application/json"