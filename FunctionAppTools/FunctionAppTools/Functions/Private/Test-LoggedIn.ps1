function Test-LoggedIn {
    [CmdletBinding()]
    param()

    $NeedLogin = $true
    try 
    {
        $Content = Get-AzureRmContext
        if ($Content) {

            $NeedLogin = ([string]::IsNullOrEmpty($Content.Account))

        } 
    } 
    catch 
    {
        if ($_ -like "*Login-AzureRmAccount to login*") {

            $NeedLogin = $true
            
        } 
        else 
        {

            throw

        }
    }

    if ($NeedLogin) {

        Login-AzureRmAccount

    }
}