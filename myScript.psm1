

# Wait 5 seconds
Function WaitASec {
    Write-Output "Waiting 5 seconds..."
	Start-Sleep 5
}


# Download Firefox
Function DownloadFirefox {
    Write-Output "Downloading Firefox..."
	$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$firefoxOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"

	Invoke-WebRequest -Uri $firefoxUrl -OutFile $firefoxOutput
}

# Install Firefox
Function InstallFirefox {
    Write-Output "Installing previously downloaded Firefox..."
	$firefoxOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"
	
	& $firefoxOutput /DesktopShortcut=false /MaintenanceService=false; Wait-Process firefox_latest_ssl_win64_de
}

# Download CCleaner
Function DownloadCCleaner {
    Write-Output "Downloading CCleaner Portable..."
	$ccleanerUrl = "https://download.ccleaner.com/portable/ccsetup558.zip" # https://www.ccleaner.com/de-de/ccleaner/builds
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"

	Invoke-WebRequest -Uri $ccleanerUrl -OutFile $ccleanerOutput
}

# Install CCleaner
Function InstallCCleaner {
    Write-Output "Installing previously downloaded CCleaner..."
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($ccleanerOutput, "$HOME\Documents\CCleaner")
}

# Download ShutUp10
Function DownloadShutUp10 {
    Write-Output "Downloading ShutUp10..."
	$shutUp10Url = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
	$shutUp10Output = "$HOME\Documents\ShutUp10\OOSU10.exe"

	$shutUp10Directory = "$HOME\Documents\ShutUp10"
	If(!(Test-Path $shutUp10Directory))
	{
		New-Item -ItemType Directory -Force -Path $shutUp10Directory
	}

	Invoke-WebRequest -Uri $shutUp10Url -OutFile $shutUp10Output
}




# Export functions
Export-ModuleMember -Function *
