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

$url = 'http://mh-nexus.de/downloads/HxDSetup' + $availableLanguages.Get_Item($installLanguage) + '.zip'

Get-ChocolateyWebFile $packageName $zipLocation $url -checksum $checksum -checksumType $checksumType

Get-ChocolateyUnzip $zipLocation $toolsDir

Install-ChocolateyPackage $packageName 'exe' '/silent' $setupLocation -registryUninstallerKey 'HxD Hex Editor_is1'

Remove-Item $zipLocation
Remove-Item $setupLocation