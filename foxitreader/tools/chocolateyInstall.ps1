$ErrorActionPreference = 'Stop'

$url32       = 'https://www.foxitsoftware.com/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=9.0.0.29935&package_type=exe&language=English'
$checksum32  = 'd432cce767779e369bfe5c3d367aea6953abe364ca0f48dd5b0d9575d4f296b3'

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
