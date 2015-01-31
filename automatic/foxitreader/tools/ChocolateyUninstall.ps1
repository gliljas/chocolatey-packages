function Get-UninstallString {
	# for 32-bit systems
	$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Foxit Reader_is1'
	if (Get-ProcessorBits 64) {
		# for 64-bit systems
		$regPath = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Foxit Reader_is1'
	}

	$regKey = Get-Item -Path $regPath -ErrorAction SilentlyContinue
	if ($regKey -eq $null) {
		Write-Warning "Uninstall entry in registry could not be found: `"$regPath`""
		return $null
	}

	$uninstallStringKey = "UninstallString"
	$uninstallString = $regKey.GetValue($uninstallStringKey)

	if ($uninstallString) {
		return $uninstallString
	}
	else {
		Write-Warning "Uninstall string not found in `"" + (Join-Path $regPath $uninstallStringKey) + "`"."
		return $null
	}
}

$packageName = 'Foxit Reader'

try {
	$uninstallArgs = '/verysilent'
	$validExitCodes = @(0)
	$uninstallString = $(Get-UninstallString)
	
	if ($uninstallString) {
		Start-ChocolateyProcessAsAdmin $uninstallArgs $(Get-UninstallString) -validExitCodes $validExitCodes
	}
	else {
		Write-Warning "FoxitReader could not be uninstalled by this script."
		Write-Warning "The Chocolatey package is removed nonetheless in case you have already uninstalled FoxitReader yourself."
	}
	
	Write-ChocolateySuccess $packageName
}
catch {
	Write-ChocolateyFailure $packageName $($_.Exception.Message)
	throw
}