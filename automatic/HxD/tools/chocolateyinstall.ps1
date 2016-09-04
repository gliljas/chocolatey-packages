$ErrorActionPreference = 'Stop';

if (Get-Command ConvertFrom-Json -errorAction SilentlyContinue) {

	# Following ConvertFrom-Json polyfill is based on http://stackoverflow.com/a/29689642
	# Thanks to its author Edward (http://stackoverflow.com/users/2934838/edward)
	# License is CC BY-SA 3.0

	Add-Type -Assembly System.Web.Extensions
	function ConvertFrom-Json {
		param(
			[Parameter(ValueFromPipeline = $true)] $json
		)

		$ps_js = New-Object System.Web.Script.Serialization.JavaScriptSerializer

		# The comma operator is the array construction operator in PowerShell
		return ,$ps_js.DeserializeObject($json)
	}
}


$packageName = 'HxD'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

. "$toolsDir\languages.ps1"

$zipLocation = Join-Path $toolsDir 'setup.zip'
$setupLocation = Join-Path $toolsDir 'setup.exe'
$hashLocation = Join-Path $toolsDir 'hashes.json'

$fallbackLanguage = 'en'

$packageParameters = $env:chocolateyPackageParameters
if ($packageParameters) {
	$argumentMap = ConvertFrom-StringData $packageParameters
	$passedLanguage = $argumentMap.Item('lang')
}

$installLanguage = $fallbackLanguage
$availableLanguages = Get-AvailableLanguages

$systemLanguage = (Get-Culture).TwoLetterISOLanguageName.toLower()
if ($availableLanguages.ContainsKey($systemLanguage)) {
	$installLanguage = $systemLanguage
}

if ($passedLanguage -and $availableLanguages.ContainsKey($passedLanguage)) {
	$installLanguage = $passedLanguage
}

# Public account details extracted from the official download page
$username = 'wa651f5'
$password = 'anonymous'

$url = "ftp://mh-nexus.de/HxDSetup$($availableLanguages.Get_Item($installLanguage)).zip"

$checksum = ((Get-Content $hashLocation -Raw | ConvertFrom-Json) | Where-Object { $_.lang -eq $installLanguage }).hash
$checksumType = 'sha256'

$ftpFileArgs = @{
	url          = $url
	filename     = $zipLocation
	username     = $username
	password     = $password
}

# Cannot use Get-ChocolateyWebFile as it currently doesn't support authentication via username + password
Get-FtpFile @ftpFileArgs
Get-ChecksumValid -File $zipLocation -Checksum $checksum -ChecksumType $checksumType -OriginalUrl $url
Get-ChocolateyUnzip $zipLocation $toolsDir
Install-ChocolateyPackage $packageName 'exe' '/silent' $setupLocation -registryUninstallerKey 'HxD Hex Editor_is1'

Remove-Item $zipLocation
Remove-Item $setupLocation
