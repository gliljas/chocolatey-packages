$ErrorActionPreference = 'Stop';

$packageName = 'foxit-phantompdf-business'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = '{{DownloadUrl}}'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url

  # Log file specification has been removed: " /l*v '$env:TEMP\chocolatey\$packageName\install.log'"
  # It always failed within my virtual machine with the error:
  # Error 1622, error opening installation log file. Verify that the specified log file
  # location exists and is writable.
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)

  # optional
  checksum      = '{{Checksum}}'
  checksumType  = 'md5'
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'md5'
}

Install-ChocolateyPackage @packageArgs