

# Wait 5 seconds
Function WaitASec {
	Start-Sleep 5
}


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

# Download CCleaner
Function DownloadCCleaner {
	$ccleanerUrl = "https://download.ccleaner.com/portable/ccsetup557.zip" # https://www.ccleaner.com/de-de/ccleaner/builds
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"

	Invoke-WebRequest -Uri $ccleanerUrl -OutFile $ccleanerOutput
}

# Install CCleaner
Function InstallCCleaner {
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($ccleanerOutput, "$HOME\Documents\CCleaner")
}

# Download ShutUp10
Function DownloadShutUp10 {
	$shutUp10Url = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
	$shutUp10Output = "$HOME\Documents\ShutUp10\OOSU10.exe"

	Invoke-WebRequest -Uri $shutUp10Url -OutFile $shutUp10Output
}




# Export functions
Export-ModuleMember -Function *
