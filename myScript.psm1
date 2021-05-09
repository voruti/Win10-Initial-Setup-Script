

# Wait 5 seconds
Function WaitASec {
	Write-Output "Waiting 5 seconds..."
	Start-Sleep 5
}

# Check for running programs to prevent conflicts
Function CheckRunningPrograms {
	Write-Output "Checking running programs..."
	$processes = @('CCleaner64', 'CCleaner', 'KeePass', 'OOSU10', 'Code')
	do {
		$doWait = $false
		foreach ($process in $processes) {
			if (Get-Process $process -ErrorAction SilentlyContinue) {
				Write-Output "Please close $process!"
				$doWait = $true
			}
		}

		if ($doWait) {
			WaitForKey
		}
	} while ($doWait)
}


# Download Firefox
Function DownloadFirefox {
	Write-Output "Downloading Firefox..."
	$programUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$programOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Firefox
Function InstallFirefox {
	Write-Output "Installing previously downloaded Firefox..."
	$programOutput = "$PSScriptRoot\firefox_latest_ssl_win64_de.exe"
	
	& $programOutput /DesktopShortcut=false /MaintenanceService=false; Wait-Process firefox_latest_ssl_win64_de
}


# Remove CCleaner
Function RemoveCCleaner {
	Write-Output "Removing CCleaner..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	Remove-Item -path $programDirectory -recurse -exclude ccleaner.ini
}

# Download CCleaner
Function DownloadCCleaner {
	Write-Output "Downloading CCleaner..."
	$programUrl = "https://download.ccleaner.com/portable/ccsetup579.zip" # https://www.ccleaner.com/de-de/ccleaner/builds
	$programOutput = "$PSScriptRoot\ccsetup.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install CCleaner
Function InstallCCleaner {
	Write-Output "Installing previously downloaded CCleaner..."
	$programOutput = "$PSScriptRoot\ccsetup.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}

# Update CCleaner, if installed
Function UpdateCCleaner {
	Write-Output "Updating CCleaner..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	
	if (Test-Path $programDirectory\*) {
		RemoveCCleaner
		DownloadCCleaner
		InstallCCleaner
	}
}


# Remove KeePass
Function RemoveKeePass {
	Write-Output "Removing KeePass..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"
	Remove-Item -path $programDirectory -recurse -include Languages, Plugins, XSL, KeePass.chm, KeePass.exe, KeePass.exe.config, KeePass.XmlSerializers.dll, KeePassLibC32.dll, KeePassLibC64.dll, License.txt, ShInstUtil.exe
}

# Download KeePass
Function DownloadKeePass {
	Write-Output "Downloading KeePass..."
	# $programUrl = "https://downloads.sourceforge.net/project/keepass/KeePass%202.x/2.47/KeePass-2.47.zip" # https://keepass.info/download.html
	$programUrl = "https://sourceforge.net/projects/keepass/files/latest/download"
	$programOutput = "$PSScriptRoot\KeePass.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
}

# Install KeePass
Function InstallKeePass {
	Write-Output "Installing previously downloaded KeePass..."
	$programOutput = "$PSScriptRoot\KeePass.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}

# Update KeePass, if installed
Function UpdateKeePass {
	Write-Output "Updating KeePass..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"
	
	if (Test-Path $programDirectory\*) {
		RemoveKeePass
		DownloadKeePass
		InstallKeePass
	}
}


# Download ShutUp10
Function DownloadShutUp10 {
	Write-Output "Downloading ShutUp10..."
	$programUrl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
	$programOutput = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10\OOSU10.exe"

	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10"
	If (!(Test-Path $programDirectory)) {
		New-Item -ItemType Directory -Force -Path $programDirectory
	}

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Update ShutUp10, if installed
Function UpdateShutUp10 {
	Write-Output "Updating ShutUp10..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10"
	
	if (Test-Path $programDirectory\*) {
		DownloadShutUp10
	}
}


# Download Avira
Function DownloadAvira {
	Write-Output "Downloading Avira..."
	$programUrl = "http://install.avira-update.com/package/antivirus/win/de-de/avira_antivirus_de-de.exe"
	$programOutput = "$PSScriptRoot\avira_antivirus_de-de.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}


# Download Notepad++
Function DownloadNPP {
	Write-Output "Downloading Notepad++..."
	$programUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.9.5/npp.7.9.5.portable.x64.zip" # https://github.com/notepad-plus-plus/notepad-plus-plus/releases/
	$programOutput = "$PSScriptRoot\npp_portable_x64.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Notepad++
Function InstallNPP {
	Write-Output "Installing previously downloaded Notepad++..."
	$programOutput = "$PSScriptRoot\npp_portable_x64.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NotepadPP"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}


# Remove VSCode
Function RemoveVSCode {
	Write-Output "Removing VSCode..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\VSCode"
	Remove-Item -path $programDirectory -recurse
}

# Download VSCode
Function DownloadVSCode {
	Write-Output "Downloading VSCode..."
	$programUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
	$programOutput = "$PSScriptRoot\VSCode.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install VSCode
Function InstallVSCode {
	Write-Output "Installing previously downloaded VSCode..."
	$programOutput = "$PSScriptRoot\VSCode.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\VSCode"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)

	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1" -Name "DisplayName" -Type String -Value "Microsoft Visual Studio Code"
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1" -Name "InstallLocation" -Type String -Value $programDirectory
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1" -Name "Publisher" -Type String -Value "Microsoft Corporation"
}

# Update VSCode, if installed
Function UpdateVSCode {
	Write-Output "Updating VSCode..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\VSCode"
	
	if (Test-Path $programDirectory\*) {
		RemoveVSCode
		DownloadVSCode
		InstallVSCode
	}
}



# Export functions
Export-ModuleMember -Function *
