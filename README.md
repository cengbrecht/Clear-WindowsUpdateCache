## Contents
 - [Description](#description)
 - [Updates](#updates)
 - [Usage](#usage)
 - [FAQ](#faq)
 - [Tested on following Windows Versions](#tested-on-following-windows-versions)

## Description

This is a PowerShell script to the Clear the Windows Update Cache. The Windows Update Cache is a special folder that stores the update installation files. It is located at the root of your system drive in *C:\Windows\SoftwareDistribution\Download*.

## Updates

New changes: by Craig Engbrecht  
I have updated the script, it is now WAY more complicated, though it is designed to run a log and track what changed. 
In an attempt to do Github "Right" I am forking, I would love any suggestions about my methods or information here.

## Usage

You can run the script directly from Windows Powershell, there are no extra command line options or parameters needed.

## FAQ

**Q:** Can I run the script safely?  
**A:** Definitely not. You have to understand what the functions do and what will be the implications for you if you run them.  
Continuing this, you accept all your own responsibilites for the damages done to your computer.  
Though I have tested this script on Windows 11 Pro, I have not done any further testing.

**Q:** Are elevated rights needed to run this script?  
**A:** Yes, you'll need administrator rights to delete files and folders under system directories.

**Q:** Did you test the script?  
**A:** See [Tested on following Windows Versions](#tested-on-following-windows-versions).

**Q:** I really like the script. Can I send a donation?  
**A:** The original writer had a donation button, I will currently be accepting donations.

## Tested on following Windows Versions

Verified on the following platforms:

|Windows Version         |Yes/No?|
|:-----------------------|:-----:|
| Windows Server 2019    | No    |
| Windows Server 2016    | Yes   |
| Windows 11             | No    |
| Windows 10             | Yes   |
