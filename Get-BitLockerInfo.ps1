# Get the directory where this script is located
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Create filename with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputFile = Join-Path $scriptPath "bitlocker_recovery_$timestamp.txt"

# Start capturing output to the file
"BitLocker Recovery Information - Generated on $(Get-Date)" | Out-File -FilePath $outputFile
"=================================================" | Out-File -FilePath $outputFile -Append

# Get BitLocker volume information
$BitLockerVolume = Get-BitLockerVolume

# Process each volume and write to file
foreach ($Volume in $BitLockerVolume) {
    "Drive Letter: $($Volume.MountPoint)" | Out-File -FilePath $outputFile -Append
    "Volume Status: $($Volume.VolumeStatus)" | Out-File -FilePath $outputFile -Append
    "Encryption Method: $($Volume.EncryptionMethod)" | Out-File -FilePath $outputFile -Append
    "Protection Status: $($Volume.ProtectionStatus)" | Out-File -FilePath $outputFile -Append
    
    # Get recovery information including the actual recovery key
    $RecoveryInfo = $Volume | Select-Object -ExpandProperty KeyProtector | 
                    Where-Object KeyProtectorType -eq 'RecoveryPassword'
    
    "`nRecovery Key Information:" | Out-File -FilePath $outputFile -Append
    foreach ($Protector in $RecoveryInfo) {
        "- Type: $($Protector.KeyProtectorType)" | Out-File -FilePath $outputFile -Append
        "- ID: $($Protector.KeyProtectorId)" | Out-File -FilePath $outputFile -Append
        "- Recovery Password: $($Protector.RecoveryPassword)" | Out-File -FilePath $outputFile -Append
    }
    "-----------------" | Out-File -FilePath $outputFile -Append
    "`n" | Out-File -FilePath $outputFile -Append
}

Write-Host "BitLocker information has been saved to: $outputFile"