Import-Module au
. '.\tools\languages.ps1'

function global:au_SearchReplace {
	@{
		'hxd.nuspec' = @{
			"<version>[^<]*</version>" = "<version>$($Latest.Version)</version>"
		}
	}
}

function global:au_GetLatest {
	$uri = 'https://mh-nexus.de/en/hxd/changelog.php'
	$page = Invoke-WebRequest -Uri $uri -UserAgent "Update checker of Chocolatey Community Package 'HxD'"
	
	$version = Get-FixedQuerySelectorAll $page "tr td:first-child" | Select -First 1 -ExpandProperty innerText
	
	# Package fix notation because the software actually uses 4 segments
	# Unless the third segment is increased, we always have to append our suffix.
	if ($version.StartsWith('1.7.7.')) {
		$version = $version + '20160827'
	}

	return @{ Version = $version }
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

Update-Package -ChecksumFor None
