

# Download Firefox
Function DownloadFirefox {
	$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$firefoxOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"

	Invoke-WebRequest -Uri $firefoxUrl -OutFile $firefoxOutput
}



# Export functions
Export-ModuleMember -Function *
