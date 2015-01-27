function Get-UninstallString {
	$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\nbi-nb-base-8.0.2.0.201411181905'
	$key = Get-Item -Path $regPath -ErrorAction Stop
	$uninstallString = $key.GetValue('UninstallString')
	
	if ($uninstallString) {
		return $uninstallString
	}
	else {
		throw [System.IO.FileNotFoundException] "Uninstall string not found in `"$regPath`"."
	}
}

$packageName = 'NetBeans Java SE'

try {
	$uninstallArgs = '--silent'
	$validExitCodes = @(0)
	Start-ChocolateyProcessAsAdmin $uninstallArgs $(Get-UninstallString) -validExitCodes $validExitCodes
	
	Write-ChocolateySuccess $packageName
}
catch {
	Write-ChocolateyFailure $packageName $($_.Exception.Message)
	throw
}