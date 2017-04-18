$ErrorActionPreference = 'Stop';

$packageName = 'HxD'
$registryUninstallerKeyName = 'HxD Hex Editor_is1'
$shouldUninstall = $true

$local_key     = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"
$local_key6432   = "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName" 
$machine_key   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"
$machine_key6432 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"

$file = @($local_key, $local_key6432, $machine_key, $machine_key6432) `
	| ?{ Test-Path $_ } `
	| Get-ItemProperty `
	| Select-Object -ExpandProperty UninstallString

# The registry value contains e.g. "C:\Program Files (x86)\HxD\unins000.exe"
# (incl. quotes!; the installation path might differ, of course).
# Chocolatey will emit a warning because [System.IO.File]::Exists() will return
# false on that path.
$file = $file.Trim(@('"'))

if ($file -eq $null -or $file -eq '') {
	Write-Host "$packageName has already been uninstalled by other means."
	Write-Host 'The registry uninstall entry does not exist (anymore).'
	$shouldUninstall = $false
}

$installerType = 'EXE' 
$silentArgs = '/verysilent'
$validExitCodes = @(0)

if ($shouldUninstall) {
	Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
}
