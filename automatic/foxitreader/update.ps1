Import-Module au

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
	
	$url32 = "https://www.foxitsoftware.com/downloads/latest.php?product=Foxit-Reader&platform=Windows&version=$version&package_type=exe&language=English"

	return @{ URL32 = $url32; Version = $version }
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
