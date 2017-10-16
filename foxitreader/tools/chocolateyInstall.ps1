$ErrorActionPreference = 'Stop'

$url32       = 'https://www.foxitsoftware.com/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=8.3.2.25013&package_type=exe&language=English'
$checksum32  = '47b0f9bacf8323355c38fe54db9ce215fb49630366f66e1b4d1e17417d5abb3a'

$packageArgs = @{
	packageName    = 'foxitreader'
	fileType       = 'EXE'
	url            = $url32
	silentArgs     = '/verysilent'
	checksum       = $checksum32
	checksumType   = 'sha256'
	validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
