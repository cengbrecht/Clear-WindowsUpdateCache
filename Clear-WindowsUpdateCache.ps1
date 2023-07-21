############################################
#Craig's Script for Fixing Windows Update - General Cleanup too if needed.
############################################

# Where do you want the Transcript Stored?
$thefolderlocation = "C:\Temp"
$WhatIf = "Enabled" #Change to Disabled to delete files.




# There is not much below here to edit unless you're rebuilding the script
# Most of the variables here are for automation purposes

####################################################################
##################### Do Not Modify below here #####################
####################################################################
$ErrorActionPreference = 'silentlycontinue'
$PSDefaultParameterValues['out-file:width'] = 2000
$VerbosePreference = "Continue"
$UpdateCachePath = Join-Path $env:windir "SoftwareDistribution\Download"

# Log all output
$date = Get-Date -Format "(dd-MM-yyyy)"
$logpath = "$thefolderlocation\WindowsUpdateFix" + $date + ".txt"
Start-Transcript -Path $logpath
Write-Host "Path where files will be cleaned up:"
Write-Host $UpdateCachePath

# Clear-WindowsUpdateCache
# Script to clear the Windows Update Cache to free up disk space
$CurrentService = ""

function Get-FreeDiskSpace {
    $OS = Get-WmiObject -Class Win32_OperatingSystem
    $Disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$($os.SystemDrive)'" |
        Select @{Name="FreeGB";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}
    return $Disk.FreeGB
}

# Get initial free disk space
$Before = Get-FreeDiskSpace

# Run the Stop Sequence
$Stage = "stop"

# List of Services to Stop
[array] $services = (
    'wuauserv',
    'cryptSvc',
    'bits',
    'msiserver'
)

Function Set-ServiceActions (
    $Stage,
    $Services
    ){
    $Output = ForEach ($service In $services) {
        # Check $service status
        $CurrentService = Get-Service $service
        If ($Stage -eq "stop") {
            # Stop $service if it's running
            If ($CurrentService.Status -eq "Running") {
                $CurrentService | Stop-Service
                $Status = Get-Service $Service
                Write-Host $Status.DisplayName "is" $Status.Status
            }else {
                $Status = Get-Service $Service
                Write-Host $Status.DisplayName "was already" $Status.Status
            }
        }elseif ($Stage -eq "start") {
            # Re-Start the Services
            If ($CurrentService.Status -eq "Stopped") {
                $CurrentService | Start-Service
                $Status = Get-Service $Service
                Write-Host $Status.DisplayName "is now" $Status.Status
            }
        }
    }
}

#Set the stage and list services
Set-ServiceActions -Stage $Stage -Services $Services

# Clean Windows Update Cache
$fileNames = (Get-ChildItem -Path $UpdateCachePath -Recurse)
ForEach ($item in $fileNames){
    If ($WhatIf -eq "Enabled") {
        Write-Host $item.name
        $item | Remove-Item -Force -Verbose -Recurse -WhatIf
    }Elseif ($WhatIf -eq "Disabled") {
        Write-Host $item.name
        $item | Remove-Item -Force -Verbose -Recurse 
    }
}

#Run the Start Sequence
$Stage = "Start"

Set-ServiceActions -Stage $Stage -Services $Services

# Get final free disk space
$After = Get-FreeDiskSpace

# Calculate and display the freed disk space
$Cleaned = $After - $Before

# Finish Logging all output
Stop-Transcript
