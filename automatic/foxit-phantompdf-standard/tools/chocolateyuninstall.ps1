$ErrorActionPreference = 'Stop';

$packageName = 'foxit-phantompdf-standard'
$shouldUninstall = $true

$local_key     = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$local_key6432   = "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$machine_key   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$machine_key6432 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

Try {
  # We cannot rely on the MSI GUID as it sometimes changed in our tests
  $msiProductCodeGuid = @($local_key, $local_key6432, $machine_key, $machine_key6432) `
      | ?{ Test-Path $_ } `
      | Get-ChildItem `
      | % {
        Try {
          $_ | Get-ItemProperty
        }
        Catch [System.InvalidCastException] {
          # This is an internal PowerShell v3 bug where Get-ItemProperty fails
          # when reading a REG_DWORD value which contains binary data.
          # See http://connect.microsoft.com/PowerShell/feedbackdetail/view/801007/get-itemproperty-specified-cast-is-not-valid-error-when-reg-dword-value-has-binary-data
          return @{}
        }
      } `
      | Where-Object -Property DisplayName -eq -Value "Foxit PhantomPDF Standard" `
      | Select-Object -ExpandProperty PSChildName
}
Catch [System.InvalidCastException] {
}
if ($msiProductCodeGuid -eq $null) {
    Write-Host "$packageName has already been uninstalled by other means."
    $shouldUninstall = $false
}

$installerType = 'MSI' 
$silentArgs = "$msiProductCodeGuid /qn /norestart"
$validExitCodes = @(0, 3010, 1605, 1614, 1641)

if ($shouldUninstall) {
  Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File ''
}