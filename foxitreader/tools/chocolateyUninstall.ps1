function Get-X86ProgramFiles {
	if (Test-Path "Env:\ProgramFiles(x86)") {
		return ${env:programfiles(x86)}
	}
	else {
		return ${env:programfiles}
	}
}

$uninstallExe = Join-Path $(Get-X86ProgramFiles) "Foxit Software\Foxit Reader\unins000.exe"
$uninstallArgs = '/verysilent'
$validExitCodes = @(0)
Start-ChocolateyProcessAsAdmin $uninstallArgs $uninstallExe -validExitCodes $validExitCodes