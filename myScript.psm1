

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


# Remove CCleaner (Data)
Function RemoveCCleaner {
    Write-Output "Removing CCleaner Portable Data..."
	$ccleanerDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	Remove-Item -path $ccleanerDirectory -recurse -exclude ccleaner.ini
}

# Download CCleaner
Function DownloadCCleaner {
    Write-Output "Downloading CCleaner Portable..."
	$ccleanerUrl = "https://download.ccleaner.com/portable/ccsetup572.zip" # https://www.ccleaner.com/de-de/ccleaner/builds
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"

	Invoke-WebRequest -Uri $ccleanerUrl -OutFile $ccleanerOutput
}

# Install CCleaner
Function InstallCCleaner {
    Write-Output "Installing previously downloaded CCleaner..."
	$ccleanerOutput = "$PSScriptRoot\ccsetup.zip"
	$ccleanerDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($ccleanerOutput, $ccleanerDirectory)
}

# Download ShutUp10
Function DownloadShutUp10 {
    Write-Output "Downloading ShutUp10..."
	$shutUp10Url = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
	$shutUp10Output = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10\OOSU10.exe"

	$shutUp10Directory = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10"
	If(!(Test-Path $shutUp10Directory))
	{
		New-Item -ItemType Directory -Force -Path $shutUp10Directory
	}

	Invoke-WebRequest -Uri $shutUp10Url -OutFile $shutUp10Output
}

# Download Avira
Function DownloadAvira {
    Write-Output "Downloading Avira..."
	$aviraUrl = "http://install.avira-update.com/package/antivirus/win/de-de/avira_antivirus_de-de.exe"
	$aviraOutput = "$PSScriptRoot\avira_antivirus_de-de.exe"

	Invoke-WebRequest -Uri $aviraUrl -OutFile $aviraOutput
}

# Download Notepad++
Function DownloadNPP {
    Write-Output "Downloading Notepad++..."
	$nppUrl = "http://download.notepad-plus-plus.org/repository/7.x/7.8/npp.7.8.bin.x64.zip" # https://notepad-plus-plus.org/downloads/
	$nppOutput = "$PSScriptRoot\npp_bin_x64.zip"

	Invoke-WebRequest -Uri $nppUrl -OutFile $nppOutput
}

# Install Notepad++
Function InstallNPP {
    Write-Output "Installing previously downloaded Notepad++..."
	$nppOutput = "$PSScriptRoot\npp_bin_x64.zip"
	$nppDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NotepadPP"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($nppOutput, $nppDirectory)
}




# Export functions
Export-ModuleMember -Function *
