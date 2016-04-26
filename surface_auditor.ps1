# Surface Tablet Auditor PowerShell Script
# Created by: Daniel Compton @ Info-Assure Ltd
# @info_assure @commonexploits.com
# April 2016

$version = "1.0 beta"

cls

Write-Host ""
Write-Host "	    _____             __                                   _ _ _             		"
Write-Host "           / ____|           / _|                   /\            | (_) |       			"     
Write-Host "          | (___  _   _ _ __| |_ __ _  ___ ___     /  \  _   _  __| |_| |_ ___  _ __ 		"		
Write-Host "            \___ \| | | | '__|  _/ _` |/ __/ _ \   / /\ \| | | |/ _` | | __/ _ \| '__|		"
Write-Host "           ____) | |_| | |  | || (_| | (_|  __/  / ____ \ |_| | (_| | | || (_) | |   		"
Write-Host "          |_____/ \__,_|_|  |_| \__,_|\___\___| /_/    \_\__,_|\__,_|_|\__\___/|_|   		"
Write-Host "                                                                                                	"																
Write-Host "				  ---- Version "$version" -----								"


# Check if admin
function CheckAdmin {
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

}

 if (!(CheckAdmin)){

Write-Host ""
Write-Host "This script requires admin priviliges. Please run again with 'run as' Administrator." -foreground Red
Write-Host ""
;break
}


#Check UEFI Firmware Tools are Installed

$tools = (Get-WMIObject -Class Win32_Product | Where-Object {$_.Name -match 'Surface Pro 3 Firmware Tools'})

if (!$tools)
	{ 
	Write-Host ""
	Write-Host "Surface Pro Firmware Tools Are Not Installed!" -foreground Red
	Write-Host ""
	Write-Host "Please Install Firmware Tools from the following URL and try again:"
	Write-Host ""
	Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=38826"
	Write-Host ""
	;break
	}

# Load Surface Extension
[Void] [System.Reflection.Assembly]::Load("SurfaceUefiManager, Version=1.0.5483.22783, Culture=neutral, PublicKeyToken=20606f4b5276c705")

$model = (Get-WmiObject Win32_ComputerSystem | foreach { $_.Model })
$serial = (Get-wmiobject win32_bios | ForEach-Object {$_.serialnumber})
$hostname = (Get-WmiObject Win32_ComputerSystem | foreach { $_.Name })
$firmware = (Get-WmiObject win32_bios | foreach { $_.SMBIOSBIOSVersion })

$usb = [Microsoft.Surface.FirmwareOption]::Find("SideUsb").CurrentValue
$secureboot = [Microsoft.Surface.FirmwareOption]::Find("Secureboot").CurrentValue
$tpm = [Microsoft.Surface.FirmwareOption]::Find("TPM").CurrentValue
$networkboot = [Microsoft.Surface.FirmwareOption]::Find("PxeBoot").CurrentValue
$password = [Microsoft.Surface.FirmwareOption]::Find("Password").CurrentValue
$bootorder = [Microsoft.Surface.FirmwareOption]::Find("AltBootOrder").CurrentValue
$sdport = [Microsoft.Surface.FirmwareOption]::Find("SdPort").CurrentValue
$bluetooth = [Microsoft.Surface.FirmwareOption]::Find("Bluetooth").CurrentValue


Write-Host ""
Write-Host "---- Surface Details ----"
Write-Host ""
if ($model -notlike "Surface Pro 3")
    {
        Write-Host "Surface Model:" "		$model", '* Note: Script only testing on the Surface Pro 3'
    }
else
    {
        Write-Host "Surface Model:" "		$model"
    }
Write-Host "Serial Number:" "		$serial"
Write-Host "Firmware Version:" "	$firmware"
Write-Host "Host Name:" "		$hostname"

Write-Host ""
Write-Host "---- Current UEFI Settings ----"
Write-Host ""

# Check Side USB Port
Write-Host -NoNewline 'USB Port:'
  	if ($usb -Like 'FF')
		{
			Write-Host '		Fail: Side USB Port Enabled' -foreground Red
		}

	elseif ($usb -Like 'FE')
		{
			Write-Host '		Pass: Side USB Port Not-Bootable' -foreground Green
		}

# Check SecureBoot
Write-Host -NoNewline 'Secure Boot:'
  	if ($secureboot -eq '0')
		{
			Write-Host '		Fail: Secure Boot Disabled' -foreground Red
		}

	elseif ($secureboot -eq '1')
		{
			Write-Host '		Pass: Secure Boot Enabled' -foreground Green
		}

# Check TPM
Write-Host -NoNewline 'TPM:'
  	if ($tpm -eq '0')
		{
			Write-Host '			Fail: TPM Disabled' -foreground Red
		}

	elseif ($tpm -eq '1')
		{
			Write-Host '			Pass: TPM Enabled' -foreground Green
		}

# Check Network Boot
Write-Host -NoNewline 'Network Boot:'
  	if ($networkboot -Like 'FF')
		{
			Write-Host '		Fail: Network Boot Enabled' -foreground Red
		}

	elseif ($networkboot -Like 'FE')
		{
			Write-Host '		Pass: Network Boot Disabled' -foreground Green
		}

# Check UEFI Password
Write-Host -NoNewline 'UEFI Setup Password:'
  	if ($password -Like $null)
		{
			Write-Host '	Fail: No UEFI Password Set' -foreground Red
		}

	else
		{
			Write-Host '	Pass: UEFI Password Set' -foreground Green
		}

# Check Boot Order
Write-Host -NoNewline 'Boot Order:'
	if ($bootorder -eq '0')
		{
			Write-Host '		Fail: Boot Order configured [ Network -> USB -> SSD ]' -foreground Red
		}
  	elseif ($bootorder -eq '1')
		{
			Write-Host '		Fail: Boot Order configured [ USB -> Network -> SSD ]' -foreground Red
		}

	elseif ($bootorder -eq '2')
		{
			Write-Host '		Fail: Boot Order configured [ USB -> SSD ]' -foreground Red
		}
	elseif ($bootorder -eq '3')
		{
			Write-Host '		Fail: Boot Order configured [ Network -> SSD ]' -foreground Red
		}

	elseif ($bootorder -eq '4')
		{
			Write-Host '		Pass: Boot Order is configured [ SSD Only ]' -foreground Green
		}

# Check SD Port
Write-Host -NoNewline 'SD Port'
  	if ($sdport -eq 'FF')
		{
			Write-Host '			Fail: SD Port is enabled' -foreground Red
		}

	elseif ($sdport -eq '00')
		{
			Write-Host '			Pass: SD Port is disabled' -foreground Green
		}


# Check Bluetooth
Write-Host -NoNewline 'Bluetooth'
  	if ($bluetooth -eq 'FF')
		{
			Write-Host '		Fail: Bluetooth Enabled' -foreground Red
		}

	elseif ($bluetooth -eq '00')
		{
			Write-Host '		Pass: Bluetooth Disabled' -foreground Green
		}


# Output Recommended Settings
Write-Host ""
Write-Host ""
Write-Host "---- Recommended UEFI Settings ----"
Write-Host ""
Write-Host -NoNewline 'USB Port:'
Write-Host '		Not-Bootable' -foreground Red
Write-Host -NoNewline 'Secure Boot:'
Write-Host '		Enabled' -foreground Green
Write-Host -NoNewline 'TPM:'
Write-Host '			Enabled' -foreground Green
Write-Host -NoNewline 'Network Boot:'
Write-Host '		Disabled' -foreground Red
Write-Host -NoNewline 'UEFI Setup Password:'
Write-Host '	Enabled' -foreground Green
Write-Host -NoNewline 'Boot Order:'
Write-Host '		[ SSD Only ]' -foreground Green
Write-Host -NoNewline 'SD Port:'
Write-Host '		Disabled' -foreground Red
Write-Host -NoNewline 'Bluetooth:'
Write-Host '		Disabled' -foreground Red
Write-Host ""

# Script End