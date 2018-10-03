<#   
    .SYNOPSIS

    .EXAMPLE

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

    [Parameter(Mandatory=$true)]
    [int]$SamplingPercentage,

    [Parameter(Mandatory=$true)]
    [Guid]$TenantId,

    [Parameter(Mandatory=$true)]
    [Guid]$ApplicationId,
    
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
Invoke-RestMethod -Method PUT -Uri $Uri -Headers @{Authorization = "Bearer $($BearerToken.access_token)"} -Body $Body -ContentType "application/json"