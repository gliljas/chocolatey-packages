# AU Packages Template: https://github.com/majkinetor/au-packages-template

param([string] $Name, [string] $ForcedPackages, [string] $Root = $PSScriptRoot)

if (Test-Path $PSScriptRoot/update_vars.ps1) { . $PSScriptRoot/update_vars.ps1 }

$Options = [ordered]@{
    Timeout       = 100
    UpdateTimeout = 1200
    Threads       = 10
    Push          = $true
    PluginPath    = ''

    Report = @{
        Type = 'markdown'
        Path = "$PSScriptRoot\Update-AUPackages.md"
        Params= @{
        }
    }

    RunInfo = @{
        Exclude = 'password', 'apikey'
        Path    = "$PSScriptRoot\update_info.xml"
    }

    ForcedPackages = $ForcedPackages -split ' '
    BeforeEach = {
        param($PackageName, $Options )
        if ($Options.ForcedPackages -contains $PackageName) { $global:au_Force = $true }
    }
}

if ($ForcedPackages) { Write-Host "FORCED PACKAGES:  $ForcedPackages" }
$global:au_Root = $Root                                    #Path to the AU packages
$info = updateall -Name $Name -Options $Options
