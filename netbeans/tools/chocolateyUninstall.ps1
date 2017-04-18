$netbeansVersion = '8.2'

function Get-UninstallString {
  $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\nbi-nb-base-$netbeansVersion*"
  $key = Get-Item -Path $regPath -ErrorAction Stop

  if (-not($key -eq $null) -and -not(($uninstallString = $key.GetValue('UninstallString')) -eq $null)) {
    return $uninstallString
  }
  else {
    throw [System.IO.FileNotFoundException] "Uninstall string not found in `"$regPath`"."
  }
}

$uninstallArgs = @{
	packageName    = 'netbeans'
	fileType       = 'exe'
	silentArgs     = '--silent'
	file           = (Get-UninstallString).Trim(@('"'))
	validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @uninstallArgs
