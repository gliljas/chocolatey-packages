Import-Module au

function global:au_AfterUpdate ($Package)  {
	Set-DescriptionFromReadme $Package
}

function global:au_SearchReplace {
	@{
		'foxitreader.nuspec' = @{
			"<version>[^<]*</version>" = "<version>$($Latest.Version)</version>"
		}
		'tools\chocolateyInstall.ps1' = @{
			"(^[$]url32\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
			"(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
		}
	}
}

function global:au_GetLatest {
	$uri = 'https://www.foxitsoftware.com/downloads/downloadForm.php?product=Foxit-Reader&language=English&platform=Windows'
	$page = Invoke-WebRequest -Uri $uri -UserAgent "Update checker of Chocolatey Community Package 'foxitreader'"

	$version = Get-FixedQuerySelectorAll $page "select[name='version'] option:first-child" | Select -First 1 -ExpandProperty value

	# The '/de/' part in the URL forces the server to respond with an English language setup.
	#
	# Without it - even with the HTTP request header "Accept-Language: en-us" - Foxit's server
	# will deliver a setup based on the geolocation of the requesting IP.
	$url32 = "https://www.foxitsoftware.com/de/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=$version&package_type=exe&language=English"

	$actualVersion = $version

	# Fix for issue #5: Checksum fails due to IP-specific language redirect
	if ($version -eq "9.0.1.1049") {
		$version = "9.0.1.1050"
	}
	elseif ($version -eq "9.0.1.1050") {
		Write-Error -Message @"
FoxitReader's current version collides with a version used as package fix notation.
"@
	}

	return @{ URL32 = $url32; Version = $version; ActualVersion = $actualVersion }
}

# Function taken from http://stackoverflow.com/a/37663738 under CC BY-SA 3.0
# Many thanks to author midnightfreddie: http://stackoverflow.com/users/4844551/midnightfreddie
function Get-FixedQuerySelectorAll {
	param (
		$HtmlWro,
		$CssSelector
	)
	# After assignment, $NodeList will crash powershell if enumerated in any way including Intellisense-completion while coding!
	$NodeList = $HtmlWro.ParsedHtml.querySelectorAll($CssSelector)

	for ($i = 0; $i -lt $NodeList.length; $i++) {
		Write-Output $NodeList.item($i)
	}
}

Update-Package -ChecksumFor 32
