$ErrorActionPreference = 'Stop'

# See the comments in  https://github.com/ComFreek/chocolatey-packages/blob/master/foxitreader/update.ps1
# on the '/de/' part.
$url32       = 'https://www.foxitsoftware.com/de/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=9.0.1.1049&package_type=exe&language=English'
$checksum32  = '8130970e6976a953e98f89fcf24783b67d1080f84b961ac2c1cee2051673ff9a'

$packageArgs = @{
	packageName    = 'foxitreader'
	fileType       = 'EXE'
	url            = $url32
	silentArgs     = '/verysilent'
	checksum       = $checksum32
	checksumType   = 'sha256'
	validExitCodes = @(0)
	Options = @{
		Headers = @{
			# In addition on the '/de/' part in the URL (which actually forces
			# an English language setup), also specify the desired language as
			# an HTTP header even though this had no effect in the past.
			'Accept-Language' = 'en-US;en-GB'
		}
	}
}

Install-ChocolateyPackage @packageArgs
