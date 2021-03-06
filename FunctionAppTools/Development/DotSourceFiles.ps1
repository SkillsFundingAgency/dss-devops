$Private = Get-ChildItem -Path "..\dss-devops\FunctionAppTools\FunctionAppTools\Functions\Private\*.ps1" -Verbose

foreach($Function in $Private) {

    try {

        . $Function.FullName

    }
    catch {

        Write-Error "Failed to import function $($Function.FullName)"

    }

}

$Public = Get-ChildItem -Path "..\dss-devops\FunctionAppTools\FunctionAppTools\Functions\Public\*.ps1" -Recurse -Verbose

foreach($Function in $Public) {

    try {

        . $Function.FullName

    }
    catch {

        Write-Error "Failed to import function $($Function.FullName)"

    }

}
