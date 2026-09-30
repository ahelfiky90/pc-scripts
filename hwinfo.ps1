# Laptop Hardware Inventory - PowerShell
$Host.UI.RawUI.WindowTitle = "Laptop Hardware Inventory"

Write-Host "==========================================" 
Write-Host "       LAPTOP HARDWARE INVENTORY"
Write-Host "=========================================="
Write-Host ""

Write-Host "[1] SERIAL NUMBER" -ForegroundColor Cyan
Get-CimInstance Win32_BIOS | Select-Object SerialNumber | Format-Table -AutoSize
Write-Host ""

Write-Host "[2] MANUFACTURER AND MODEL" -ForegroundColor Cyan
Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer,Model | Format-Table -AutoSize
Write-Host ""

Write-Host "[3] CPU" -ForegroundColor Cyan
Get-CimInstance Win32_Processor |
    Select-Object Name,NumberOfCores,NumberOfLogicalProcessors |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[4] RAM - SIZE / TYPE / SPEED" -ForegroundColor Cyan
Get-CimInstance Win32_PhysicalMemory |
    Select-Object `
        @{N='SizeGB';E={[math]::Round($_.Capacity/1GB,0)}},
        Speed,
        @{N='RAM_Type';E={
            switch ($_.SMBIOSMemoryType) {
                24 {'DDR3'}
                26 {'DDR4'}
                34 {'DDR5'}
                default {"Unknown ($($_.SMBIOSMemoryType))"}
            }
        }},
        Manufacturer,
        PartNumber |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[5] STORAGE - SSD/HDD / SIZE / BUS" -ForegroundColor Cyan
Get-PhysicalDisk |
    Select-Object FriendlyName,MediaType,
        @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},
        BusType |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[6] GPU" -ForegroundColor Cyan
Get-CimInstance Win32_VideoController |
    Select-Object Name,
        @{N='VRAM_GB';E={
            if ($_.AdapterRAM) {[math]::Round($_.AdapterRAM/1GB,2)}
            else {'N/A'}
        }} |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[7] NETWORK ADAPTERS" -ForegroundColor Cyan
Get-NetAdapter |
    Select-Object Name,InterfaceDescription,MacAddress,Status,LinkSpeed |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[8] WINDOWS" -ForegroundColor Cyan
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption,Version,OSArchitecture |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[9] BIOS" -ForegroundColor Cyan
Get-CimInstance Win32_BIOS |
    Select-Object Manufacturer,SMBIOSBIOSVersion,
        @{N='ReleaseDate';E={
            if ($_.ReleaseDate) {$_.ReleaseDate.ToString('yyyy-MM-dd')}
        }} |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[10] MOTHERBOARD" -ForegroundColor Cyan
Get-CimInstance Win32_BaseBoard |
    Select-Object Manufacturer,Product,SerialNumber |
    Format-Table -AutoSize
Write-Host ""

Write-Host "[11] DEVICE MANAGER / DRIVERS" -ForegroundColor Cyan
Write-Host "Open Device Manager with: devmgmt.msc"
Write-Host ""

Write-Host "=========================================="
Write-Host "          INVENTORY COMPLETE"
Write-Host "=========================================="
Write-Host ""
Read-Host "Press Enter to exit"
