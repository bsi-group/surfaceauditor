Surface Auditor
========

This security auditing script is intended to be run on Microsoft Surface Pro 3 tablet devices. The script will collect the currently configured UEFI security settings and give recommendtions to hardening the security of these settings.


Developed by Daniel Compton

https://github.com/commonexploits/


Requirements
========

The Microsoft Surface Pro Firmware tools must be installed on the tablet device.

https://www.microsoft.com/en-gb/download/details.aspx?id=38826

The script must be run as the Administrator of the device.


How To Use
========

The PowerShell scripts runs on the Surface Tablet device itself.

    ./surfaceauditor.ps1


Features
========

* Passively detects the DTP mode of a Cisco switch for VLAN hopping
* Reports if switch is in Default mode, trunk, dynamic, auto or access mode

Screen Shots
========

![](http://wwww.info-assure.co.uk/wp-content/uploads/2016/04/surfaceaudtor.png)


Change Log
========
* Version 1.0 - First release.
