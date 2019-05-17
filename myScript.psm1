

# Download Firefox
Function DownloadFirefox {
	$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$firefoxOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"

	Invoke-WebRequest -Uri $firefoxUrl -OutFile $firefoxOutput
}

# Install Firefox
Function InstallFirefox {
	$firefoxOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"
	
	& $firefoxOutput /DesktopShortcut=false /MaintenanceService=false; Wait-Process firefox_latest_ssl_win64_de
}

# Wait 5 seconds
Function WaitASec {
	Start-Sleep 5
}



# Export functions
Export-ModuleMember -Function *
