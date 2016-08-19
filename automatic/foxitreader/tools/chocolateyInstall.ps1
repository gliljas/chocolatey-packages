$packageArgs = @{
  packageName   = '{{PackageName}}'
  fileType      = 'EXE'
  url           = '{{DownloadUrl}}'
  silentArgs    = '/verysilent'
  validExitCodes= @(0)
  checksum      = '{{Checksum}}'
  checksumType  = 'md5'
}

Install-ChocolateyPackage @packageArgs
