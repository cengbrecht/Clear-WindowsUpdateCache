############################################
#Craig's Script for Windows Update Fixing - General Cleanup too if needed.
############################################

# Re-register the name of the session for record keeping.
Unregister-PSSessionConfiguration
Register-PSSessionConfiguration


# Clear-WindowsUpdateCache
# Script to clear the Windows Update Cache to free up disk space

$time = Get-Date -Format "(dd-MM-yyyy)"

$logpath = "C:\Temp\WindowsUpdateFix." + $time + ".txt"
$ErrorActionPreference = 'silentlycontinue'
$PSDefaultParameterValues['out-file:width'] = 2000
$VerbosePreference = "Continue"
$CurrentService = ""

# Log all output
Start-Transcript -Path $logpath

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
$UpdateCachePath = Join-Path $env:windir "SoftwareDistribution\Download"
$fileNames = (Get-ChildItem -Path $UpdateCachePath -Recurse)
ForEach ($item in $fileNames){
    Write-Host $item.Name
    $item | Remove-Item -Force -Whatif
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
