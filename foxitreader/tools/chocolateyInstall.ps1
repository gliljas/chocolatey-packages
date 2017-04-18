$ErrorActionPreference = 'Stop'

$url32       = 'https://www.foxitsoftware.com/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=8.3.0.14878&package_type=exe&language=English'
$checksum32  = 'f1a4c530740cfcb5afc4ee6f335b4b69137a21809c85128a19a609a8f09c0ca6'

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
