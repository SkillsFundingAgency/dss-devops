
function Get-Swagger{
<#
    .SUMMARY
    Calls api-defintion method in DSS function apps to return the swagger definition for that resource
    .NOTES
    Depends on Invoke-AzureRmResourceAction (called in private function Get-PublishingProfileCredentialsAzure) which runs only when logged on with a Service Principal
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$FunctionAppName,
        [Parameter(Mandatory=$true)]
        [string]$FunctionAppDomain,
        [Parameter(Mandatory=$true)]
        [string]$ApiResourceName,
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$false)]
        [Switch]$AuthenticationKeyRequired
    )

    if($AuthenticationKeyRequired.IsPresent) {
        $MasterKey = Get-FunctionAppHostKey -ResourceGroupName $ResourceGroupName -FunctionAppName $FunctionAppName -FunctionAppDomain $FunctionAppDomain
    }

    $Uri = "https://$FunctionAppName.$FunctionAppDomain/api/$ApiResourceName/api-definition?code=$($MasterKey)"


    $Swagger = ""

    if($PSVersionTable.PSVersion.Major -eq 5) {
        add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@    
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy        

        $Swagger = (Invoke-WebRequest -Uri $Uri -UseBasicParsing).Content
    } else {
        $Swagger = (Invoke-WebRequest -Uri $Uri -UseBasicParsing -SkipCertificateCheck).Content
    }
    
    $Swagger
}
