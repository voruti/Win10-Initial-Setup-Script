Function DisableWidgets {
	Write-Output "Disabling Widgets..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Type DWord -Value 0
}

Function DisableFeeds {
	Write-Output "Disabling Feeds..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
}
