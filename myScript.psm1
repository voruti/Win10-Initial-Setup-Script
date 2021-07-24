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

# Check for single running program to prevent conflicts
Function CheckRunningProgram {
	param([parameter(Mandatory = $true)][String]$process)
	Write-Debug "Checking if program $process is running..."
	do {
		$doWait = $false
		if (Get-Process $process -ErrorAction SilentlyContinue) {
			Write-Output "Please close $process!"
			$doWait = $true
		}

		if ($doWait) {
			WaitForKey
		}
	} while ($doWait)
}

# Check for all running programs to prevent conflicts
# Function CheckAllRunningPrograms {
# 	Write-Output "Checking all running programs..."
# 	$processes = @('firefox', 'CCleaner64', 'CCleaner', 'KeePass', 'OOSU10', 'notepad++', 'Code', 'vsls-agent', 'git-bash', 'bash', 'git', 'sh', 'GitHubDesktop', 'mintty', 'MailCheck', 'node')

# 	foreach ($process in $processes) {
# 		CheckRunningProgram $process
# 	}
# }

# Create a download folder
Function CreateDownloadFolder {
	Write-Output "Creating download folder..."
	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		New-Item -ItemType Directory -Path "$PSScriptRoot\download" -Force | Out-Null
	}
}

# Update all installed programs
Function UpdateAllPrograms {
	Write-Output "Updating all programs..."
	
	UpdateCCleaner
	UpdateKeePass
	UpdateShutUp10
	UpdateVSCode
	UpdateGit
	UpdateMailCheck
	# UpdateNodeJs
}

# Print some empty lines to the console
Function ClearConsole {
	for ($i = 0; $i -lt 6; $i++) {
		Write-Output ""
	}
}


# Download Firefox
Function DownloadFirefox {
	Write-Output "Downloading Firefox..."
	$programUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
	$programOutput = "$PSScriptRoot\download\firefox_latest_ssl_win64_de.exe"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install Firefox
Function InstallFirefox {
	Write-Output "Installing Firefox..."
	$programOutput = "$PSScriptRoot\download\firefox_latest_ssl_win64_de.exe"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadFirefox
	}
	CheckRunningProgram "firefox"
	
	& $programOutput /DesktopShortcut=false /MaintenanceService=false; Wait-Process firefox_latest_ssl_win64_de
}


# Remove CCleaner
Function RemoveCCleaner {
	Write-Output "Removing CCleaner..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"

	CheckRunningProgram "CCleaner64"
	CheckRunningProgram "CCleaner"

	Remove-Item -path $programDirectory -recurse -exclude ccleaner.ini
}

# Download CCleaner
Function DownloadCCleaner {
	Write-Output "Downloading CCleaner..."
	$programUrl = "https://download.ccleaner.com/portable/ccsetup581.zip" # https://www.ccleaner.com/de-de/ccleaner/builds
	$programOutput = "$PSScriptRoot\download\ccsetup.zip"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "CCleaner64"
	CheckRunningProgram "CCleaner"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}

# Update CCleaner, if installed
Function UpdateCCleaner {
	Write-Output "Updating CCleaner..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\CCleaner"
	
	if (Test-Path $programDirectory\*) {
		DownloadCCleaner
		RemoveCCleaner
		InstallCCleaner
	}
}


# Remove KeePass
Function RemoveKeePass {
	Write-Output "Removing KeePass..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"

	CheckRunningProgram "KeePass"

	Remove-Item -path $programDirectory -recurse -include Languages, Plugins, XSL, KeePass.chm, KeePass.exe, KeePass.exe.config, KeePass.XmlSerializers.dll, KeePassLibC32.dll, KeePassLibC64.dll, License.txt, ShInstUtil.exe
}

# Download KeePass
Function DownloadKeePass {
	Write-Output "Downloading KeePass..."
	$programUrl = "https://sourceforge.net/projects/keepass/files/latest/download"
	$programOutput = "$PSScriptRoot\download\KeePass.zip"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "KeePass"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}

# Update KeePass, if installed
Function UpdateKeePass {
	Write-Output "Updating KeePass..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\KeePass"
	
	if (Test-Path $programDirectory\*) {
		DownloadKeePass
		RemoveKeePass
		InstallKeePass
	}
}


# Download ShutUp10
Function DownloadShutUp10 {
	Write-Output "Downloading ShutUp10..."
	$programUrl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
	$programOutput = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10\OOSU10.exe"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\ShutUp10"

	CheckRunningProgram "OOSU10"

	If (!(Test-Path $programDirectory)) {
		New-Item -ItemType Directory -Force -Path $programDirectory | Out-Null
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

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}


# Download Notepad++
Function DownloadNPP {
	Write-Output "Downloading Notepad++..."

	$repo = "notepad-plus-plus/notepad-plus-plus"
	$file = "portable.x64.zip"
	$programUrl = "https://github.redno.de/$repo/$file"
	$programOutput = "$PSScriptRoot\download\npp_portable_x64.zip"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "notepad++"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, $programDirectory)
}


# Remove VSCode
Function RemoveVSCode {
	Write-Output "Removing VSCode..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\VSCode"

	CheckRunningProgram "Code"
	CheckRunningProgram "vsls-agent"
	CheckRunningProgram "git-bash"
	CheckRunningProgram "bash"
	CheckRunningProgram "git"
	CheckRunningProgram "sh"
	CheckRunningProgram "mintty"

	Remove-Item -path $programDirectory -recurse
}

# Download VSCode
Function DownloadVSCode {
	Write-Output "Downloading VSCode..."
	$programUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
	$programOutput = "$PSScriptRoot\download\VSCode.zip"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "Code"
	CheckRunningProgram "vsls-agent"
	CheckRunningProgram "git-bash"
	CheckRunningProgram "bash"
	CheckRunningProgram "git"
	CheckRunningProgram "sh"
	CheckRunningProgram "mintty"
	
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
		DownloadVSCode
		RemoveVSCode
		InstallVSCode
	}
}


# Remove Git
Function RemoveGit {
	Write-Output "Removing Git..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\Git"

	CheckRunningProgram "Code"
	CheckRunningProgram "vsls-agent"
	CheckRunningProgram "GitHubDesktop"
	CheckRunningProgram "git-bash"
	CheckRunningProgram "bash"
	CheckRunningProgram "git"
	CheckRunningProgram "sh"
	CheckRunningProgram "mintty"

	Remove-Item -path $programDirectory -recurse -force
}

# Download Git
Function DownloadGit {
	Write-Output "Downloading Git..."

	$repo = "git-for-windows/git"
	$file = "ortable.*64.*7z.exe"
	$programUrl = "https://github.redno.de/$repo/$file"
	$programOutput = "$PSScriptRoot\download\Git.7z.exe"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "Code"
	CheckRunningProgram "vsls-agent"
	CheckRunningProgram "GitHubDesktop"
	CheckRunningProgram "git-bash"
	CheckRunningProgram "bash"
	CheckRunningProgram "git"
	CheckRunningProgram "sh"
	CheckRunningProgram "mintty"
	
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
		DownloadGit
		RemoveGit
		InstallGit
	}
}


# Remove MailCheck
Function RemoveMailCheck {
	Write-Output "Removing MailCheck..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\MailCheck"

	CheckRunningProgram "MailCheck"

	Remove-Item -path $programDirectory -recurse -exclude mailcheck.ini
}

# Download MailCheck
Function DownloadMailCheck {
	Write-Output "Downloading MailCheck..."
	$programUrl = "https://www.d-jan.de/MailCheck2Setup118Build512-64bit.exe" # https://www.d-jan.de/download.shtml
	$programOutput = "$PSScriptRoot\download\MailCheck.exe"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

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
	CheckRunningProgram "MailCheck"
	
	Set-Content $programInf "[Setup]`r`nSetupType=portable`r`nDir=$programDirectory"

	Start-Process -Wait $programOutput -ArgumentList "/LOADINF=`"$programInf`""
}

# Update MailCheck, if installed
Function UpdateMailCheck {
	Write-Output "Updating MailCheck..."
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\MailCheck"
	
	if (Test-Path $programDirectory\*) {
		DownloadMailCheck
		RemoveMailCheck
		InstallMailCheck
	}
}


# Remove NodeJs
# Function RemoveNodeJs {
# 	Write-Output "Removing NodeJs..."
# 	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NodeJs"

# 	CheckRunningProgram "node"

# 	Remove-Item -path $programDirectory -recurse
# }

# Download NodeJs
Function DownloadNodeJs {
	Write-Output "Downloading NodeJs..."
	$programUrl = "https://nodejs.org/dist/v16.4.1/node-v16.4.1-win-x64.zip"
	$programOutput = "$PSScriptRoot\download\NodeJs.zip"

	If (!(Test-Path -PathType Container "$PSScriptRoot\download")) {
		CreateDownloadFolder
	}

	Invoke-WebRequest -Uri $programUrl -OutFile $programOutput
}

# Install NodeJs
Function InstallNodeJs {
	Write-Output "Installing NodeJs..."
	$programOutput = "$PSScriptRoot\download\NodeJs.zip"
	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NodeJs"

	If (!(Test-Path -PathType Leaf "$programOutput")) {
		DownloadNodeJs
	}
	CheckRunningProgram "node"
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($programOutput, "$programDirectory\..")

	Rename-Item "$programDirectory\..\node-v16.4.1-win-x64" $programDirectory

	If (!([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -Match [regex]::escape("$programDirectory"))) {
		[System.Environment]::SetEnvironmentVariable(
			"Path", 
			[System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";$programDirectory",
			[System.EnvironmentVariableTarget]::User
		)
	}
}

# Update NodeJs, if installed
# Function UpdateNodeJs {
# 	Write-Output "Updating NodeJs..."
# 	$programDirectory = [Environment]::GetFolderPath('MyDocuments') + "\NodeJs"
	
# 	if (Test-Path $programDirectory\*) {
# 		DownloadNodeJs
# 		RemoveNodeJs
# 		InstallNodeJs
# 	}
# }



# Export functions
Export-ModuleMember -Function *
