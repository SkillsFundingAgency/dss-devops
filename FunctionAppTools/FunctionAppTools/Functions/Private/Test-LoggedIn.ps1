function Test-LoggedIn {
    [CmdletBinding()]
    param()

    $NeedLogin = $true
    try 
    {
        $Content = Get-AzContext
        if ($Content) {

            $NeedLogin = ([string]::IsNullOrEmpty($Content.Account))

        } 
    } 
    catch 
    {
        if ($_ -like "*Connect-AzAccount to login*") {

            $NeedLogin = $true
            
        } 
        else 
        {

            throw

        }
    }

    if ($NeedLogin) {

        Login-AzAccount

    }
}
