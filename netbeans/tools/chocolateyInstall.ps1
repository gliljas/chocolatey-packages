$ErrorActionPreference = 'Stop'

$url32          = 'http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-javase-windows.exe'
$checksum32     = '7b0646306a7488e617837da1517a86c08b7cf6fbe4dd9d74e8a4564b5ffde004'
$checksumType32 = 'sha256'

$packageArgs = @{
	packageName    = 'netbeans'
	fileType       = 'EXE'
	url            = $url32
	silentArgs     = '--silent'
	checksum       = $checksum32
	checksumType   = $checksumType32
	validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
