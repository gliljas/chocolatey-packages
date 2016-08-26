$ErrorActionPreference = 'Stop'

$url32       = 'https://www.foxitsoftware.com/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=8.0.2.805&package_type=exe&language=English'
$checksum32  = '5d60768d1c50c3d83c303a9c478e719347508b1617e09d8aeb38bffb8e4452c5'

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
