$uninstallExe = Join-Path $env:ProgramFiles "NetBeans 8.0.2\uninstall.exe"
$uninstallArgs = '--silent'
$validExitCodes = @(0)
Start-ChocolateyProcessAsAdmin $uninstallArgs $uninstallExe -validExitCodes $validExitCodes