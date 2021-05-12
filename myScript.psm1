# Wait 5 seconds
Function WaitASec {
	Write-Output "Waiting 5 seconds..."
	Start-Sleep 5
}

# Execute a part of the script with administrator privileges
Function RequireAdminPortion {
	param([ScriptBlock]$Code)
	Start-Process powershell -Verb RunAs -Wait -ArgumentList "$Code"
}

# Check for running programs to prevent conflicts
Function CheckRunningPrograms {
	Write-Output "Checking running programs..."
	$processes = @('CCleaner64', 'CCleaner', 'KeePass', 'OOSU10', 'Code', 'vsls-agent', 'git-bash', 'bash', 'git', 'sh', 'GitHubDesktop', 'mintty', 'MailCheck')
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

# Create a download folder
Function CreateDownloadFolder {
	Write-Output "Creating download folder..."
	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		New-Item -ItemType Directory -Path "$PSScriptRoot\download" -Force | Out-Null
	}
}


# Download Firefox
Function DownloadFirefox {
	Write-Output "Downloading Firefox..."
	$programUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$programOutput = "$PSScriptRoot\download\firefox_latest_ssl_win64_de.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Firefox
Function InstallFirefox {
	Write-Output "Installing Firefox..."
	$programOutput = "$PSScriptRoot\download\firefox_latest_ssl_win64_de.exe"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadFirefox
	}
	
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
	$programOutput = "$PSScriptRoot\download\ccsetup.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install CCleaner
Function InstallCCleaner {
	Write-Output "Installing CCleaner..."
	$programOutput = "$PSScriptRoot\download\ccsetup.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadCCleaner
	}
	
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
	$programOutput = "$PSScriptRoot\download\KeePass.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
}

# Install KeePass
Function InstallKeePass {
	Write-Output "Installing KeePass..."
	$programOutput = "$PSScriptRoot\download\KeePass.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadKeePass
	}
	
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
	$programOutput = "$PSScriptRoot\download\avira_antivirus_de-de.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}


# Download Notepad++
Function DownloadNPP {
	Write-Output "Downloading Notepad++..."
	$programUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.9.5/npp.7.9.5.portable.x64.zip" # https://github.com/notepad-plus-plus/notepad-plus-plus/releases/
	$programOutput = "$PSScriptRoot\download\npp_portable_x64.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Notepad++
Function InstallNPP {
	Write-Output "Installing Notepad++..."
	$programOutput = "$PSScriptRoot\download\npp_portable_x64.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NotepadPP"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadNPP
	}
	
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
	$programOutput = "$PSScriptRoot\download\VSCode.zip"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install VSCode
Function InstallVSCode {
	Write-Output "Installing VSCode..."
	$programOutput = "$PSScriptRoot\download\VSCode.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\VSCode"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadVSCode
	}
	
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


# Remove Git
Function RemoveGit {
	Write-Output "Removing Git..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\Git"
	Remove-Item -path $programDirectory -recurse -force
}

# Download Git
Function DownloadGit {
	Write-Output "Downloading Git..."
	$programUrl = "https://github.com/git-for-windows/git/releases/download/v2.31.1.windows.1/PortableGit-2.31.1-64-bit.7z.exe"
	$programOutput = "$PSScriptRoot\download\Git.7z.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Git
Function InstallGit {
	Write-Output "Installing Git..."
	$programOutput = "$PSScriptRoot\download\Git.7z.exe"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\Git"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadGit
	}
	
	Start-Process -Wait $programOutput -ArgumentList "-o`"$programDirectory`" -y"

	If (!(Test-Path 'HKLM:\SOFTWARE\GitForWindows')) {
		RequireAdminPortion {
			New-Item -Path 'HKLM:\SOFTWARE\GitForWindows' -Force | Out-Null
			$programDirectory = [Environment]::GetFolderPath('MyDocuments') + '\Git'
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\GitForWindows' -Name 'InstallPath' -Type String -Value $programDirectory
		}
	}
	ElseIf ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\GitForWindows' -Name 'InstallPath').InstallPath -ne $programDirectory) {
		RequireAdminPortion {
			$programDirectory = [Environment]::GetFolderPath('MyDocuments') + '\Git'
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\GitForWindows' -Name 'InstallPath' -Type String -Value $programDirectory
		}
	}

	If (!([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -Match [regex]::escape("$programDirectory\cmd"))) {
		[System.Environment]::SetEnvironmentVariable(
			"Path", 
			[System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";$programDirectory\cmd", 
			[System.EnvironmentVariableTarget]::User
		)
	}
}

# Update Git, if installed
Function UpdateGit {
	Write-Output "Updating Git..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\Git"
	
	if (Test-Path $programDirectory\*) {
		RemoveGit
		DownloadGit
		InstallGit
	}
}


# Remove MailCheck
Function RemoveMailCheck {
	Write-Output "Removing MailCheck..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\MailCheck"
	Remove-Item -path $programDirectory -recurse -exclude mailcheck.ini
}

# Download MailCheck
Function DownloadMailCheck {
	Write-Output "Downloading MailCheck..."
	$programUrl = "https://www.d-jan.de/MailCheck2Setup118Build512-64bit.exe" # https://www.d-jan.de/download.shtml
	$programOutput = "$PSScriptRoot\download\MailCheck.exe"

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install MailCheck
Function InstallMailCheck {
	Write-Output "Installing MailCheck..."
	$programOutput = "$PSScriptRoot\download\MailCheck.exe"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\MailCheck"
	$programInf = "$PSScriptRoot\download\MailCheck.inf"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadMailCheck
	}
	
	Set-Content $programInf "[Setup]`r`nSetupType=portable`r`nDir=$programDirectory"

	Start-Process -Wait $programOutput -ArgumentList "/LOADINF=`"$programInf`""
}

# Update MailCheck, if installed
Function UpdateMailCheck {
	Write-Output "Updating MailCheck..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\MailCheck"
	
	if (Test-Path $programDirectory\*) {
		RemoveMailCheck
		DownloadMailCheck
		InstallMailCheck
	}
}



# Export functions
Export-ModuleMember -Function *
