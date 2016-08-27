$ErrorActionPreference = 'Stop';

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
