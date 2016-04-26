Surface Auditor
========

This security auditing script is intended to be run on Microsoft Surface Pro 3 tablet devices. The script will collect the currently configured UEFI security settings and give the recommended security settings to be applied.


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

* Detects the current configuration of the UEFI security related settings
* Recommends the best security configuration for the UEFI settings


Configuration and Auditing Guide
========
A full configuration and auditing paper can be downloaded for the Microsoft Surface Pro Tablet below

http://www.info-assure.co.uk/microsoft-surface-security-configuration-and-auditing-guide

Screen Shots
========

![](http://wwww.info-assure.co.uk/wp-content/uploads/2016/04/surfaceaudtor.png)


Change Log
========
* Version 1.0 - First release.
