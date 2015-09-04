$ErrorActionPreference = 'Stop';

$packageName = 'HxD'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$zipLocation = Join-Path $toolsDir 'setup.zip'
$setupLocation = Join-Path $toolsDir 'setup.exe'

$availableLanguages = @{
	'zh' = 'CHS';
	'cs' = 'CSY';
	'de' = 'DE';
	'el' = 'ELL';
	'en' = 'EN';
	'es' = 'ES';
	'fi' = 'FI';
	'fr' = 'FR';
	'hu' = 'HU';
	'it' = 'IT';
	'ja' = 'JP';
	'ko' = 'KOR';
	'nl' = 'NL';
	'pl' = 'PL';
	'pt' = 'PTB';
	'ro' = 'ROM';
	'ru' = 'RU';
	'sk' = 'SK';
	'sl' = 'SL';
	'sv' = 'SVE';
	'tr' = 'TR';
}
$fallbackLanguage = 'en'

$packageParameters = $env:chocolateyPackageParameters
if ($packageParameters) {
	$argumentMap = ConvertFrom-StringData $packageParameters
	$passedLanguage = $argumentMap.Item('lang')
}

$installLanguage = $fallbackLanguage

$systemLanguage = (Get-Culture).TwoLetterISOLanguageName.toLower()
if ($availableLanguages.ContainsKey($systemLanguage)) {
	$installLanguage = $systemLanguage
}

if ($passedLanguage -and $availableLanguages.ContainsKey($passedLanguage)) {
	$installLanguage = $passedLanguage
}

$url = 'ftp://mh-nexus.de/HxDSetup' + $availableLanguages.Get_Item($installLanguage) + '.zip'

# Public account details extracted from the official download page
$username = 'wa651f5'
$password = 'anonymous'

Write-Host "Downloading $url"
Get-FtpFile $url $zipLocation 'wa651f5' 'anonymous' $false
Get-ChocolateyUnzip $zipLocation $toolsDir
Install-ChocolateyPackage $packageName 'exe' '/silent' $setupLocation -registryUninstallerKey 'HxD Hex Editor_is1'

Remove-Item $zipLocation
Remove-Item $setupLocation