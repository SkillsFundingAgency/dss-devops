[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("AT", "TEST", "PP")]
    [String]$ContainerEnvironment,
    [Parameter(Mandatory=$true)]
    [String]$IpAddress,
    [Parameter(Mandatory=$true)]
    [ValidateSet("DEV", "SIT", "PP")]
    [String]$SqlServerEnvironment
)

$SharedParams = @{
    FirewallRuleName = "dss-$($ContainerEnvironment.ToLower())-restore-aci"
    ServerName = "dfc-$($SqlServerEnvironment.ToLower())-shared-sql"
    ResourceGroupName = "dfc-$($SqlServerEnvironment.ToLower())-shared-rg"
}

$ExistingFirewallRule = Get-AzSqlServerFirewallRule @SharedParams -ErrorAction SilentlyContinue

if ($ExistingFirewallRule) {

    Write-Verbose "Updating existing firewall rule: $($ExistingFirewallRule.FirewallRuleName)"
    Set-AzSqlServerFirewallRule @SharedParams -StartIpAddress $IpAddress -EndIpAddress $IpAddress

}
else {

    Write-Verbose "Creating new firewall rule: $($SharedParams['FirewallRuleName'])"
    New-AzSqlServerFirewallRule @SharedParams -StartIpAddress $IpAddress -EndIpAddress $IpAddress

}