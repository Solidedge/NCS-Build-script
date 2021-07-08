# Powershell-script for checking state of Toolchain
# Press "F5" to start powershell and run script

## Variables ########################################################
$startTime = Get-Date

## Prepping visuals #################################################
Clear-Host
Write-Host "`n`n$startTime Running Debug-script." -ForegroundColor Magenta

## Toolchain version check ##########################################
# CMAKE #############################################################
Write-Host "`nC-Make" -ForegroundColor Magenta

# New values
$verErr = $false
$minVer = "3.16.2"
$progVer = cmake --version

if($progVer -eq $null) {
    cmake --version
    Write-Host "Error: cmake --version" -ForegroundColor Red
} else {
    #Extracting version number
    $progVer = $progVer -replace "[^0-9.]" , ''
    $progVer = $progVer[0]
    $progVer = $progVer.Trim()
    $progPrint = $progVer
    $progVer = $progVer -join ''
    $progVer = $progVer -split '[^0-9]'

    $minVer = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# West ##############################################################
Write-Host "`nWest" -ForegroundColor Magenta

# New values
$verErr = $false
$minVer = "0.10.1"
$progVer = west --version

if($progVer -eq $null) {
    west --version
    Write-Host "Error: west --version" -ForegroundColor Red
} else {
    #Extracting version number
    $progVer = $progVer -replace "[^0-9.]" , ''
    $progVer = $progVer.Trim()
    $progPrint = $progVer
    $progVer = $progVer -split '[^0-9]'

    $minVer = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# Ninja #############################################################
Write-Host "`nNinja" -ForegroundColor Magenta

# New values
$verErr = $false
$minVer = "1.10.0"
$progVer = ninja --version

if($progVer -eq $null) {
    ninja --version
    Write-Host "Error: ninja --version" -ForegroundColor Red
} else {
    #Extracting version number
    $progPrint = $progVer
    $progVer = $progVer -split '[^0-9]'

    $minVer = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# nRFjProg ##########################################################
Write-Host "`nnRFJProg" -ForegroundColor Magenta

# New values
$verErr = $false
$progVer = nrfjprog -v
$minVer = "10.12.1"     #nRFjprog

if($progVer -eq $null) {
    nrfjprog -v
    Write-Host "Error: nrfjprog -v" -ForegroundColor Red
} else {
    #Extracting version number
    $progVer    = $progVer -replace "[^0-9.]" , ''
    $progVer    = $progVer[0]
    $progVer    = $progVer.Trim()
    $progPrint = $progVer
    $progVer    = $progVer -join ''
    $progVer    = $progVer -split '[^0-9]'

    $minVer     = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# J-Link ARM ########################################################
Write-Host "`nJ-Link ARM" -ForegroundColor Magenta

# New values
$verErr = $false
$progVer = nrfjprog -v
$minVer = "6.88"    #JlinkARM
if($progVer -eq $null) {
    nrfjprog -v
    Write-Host "Error: nrfjprog -v" -ForegroundColor Red
} else {
    #Extracting version number
    $progVer    = $progVer -replace "[^0-9.]" , ''
    $progVer    = $progVer[1]
    $progVer    = $progVer.Trim()
    $progVer    = $progVer.substring(1) 
    $progPrint = $progVer
    $progVer    = $progVer -join ''
    $progVer    = $progVer -split '[^0-9]'

    $minVer     = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# Powershell ########################################################
Write-Host "`nPowershell" -ForegroundColor Magenta

# New values
$verErr = $false
$minVer = "2021.2.2"
$progVer = Get-Host | Select-Object Version

if($progVer -eq $null) {
    Get-Host | Select-Object Version
    Write-Host "Error: Get-Host | Select-Object Version" -ForegroundColor Red
    exit
} else {
    #Extracting version number
    $progVer = $progVer -join ''
    $progVer = $progVer -replace "[^0-9.]" , ''
    $progVer = $progVer.Trim()
    $progPrint = $progVer
    $progVer = $progVer -split '[^0-9]'

    $minVer = $minVer -split '[^0-9]'

    #Comparing minimum version to actual version
    for ($num = 0; $num -lt $progVer.Count; $num++) {
        if ($progVer[$num] -lt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Red
            break
        } elseif ($progVer[$num] -gt $minVer[$num]) {
            Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
            break
        } elseif ($progVer[$num] -eq $minVer[$num]) {
            if ($num -ge ($progVer.Count-1)) {
                Write-Host "Current Version: `t$progPrint" -ForegroundColor Green
                break
            }
        }
    }

    $minVer = $minVer -join "."
    Write-Host "Minimum: `t`t$minVer" -ForegroundColor Gray
}


#####################################################################
# Windows ###########################################################
Write-Host "`nWindows" -ForegroundColor Magenta

# New values
$verErr = $false
$minVer = "10.19042.0"
$minVer = $minVer -split '[^0-9]'

#Extracting version number
$winVer     = [System.Environment]::OSVersion.Version.Major
$buildVer   = [System.Environment]::OSVersion.Version.Build
$revVer     = [System.Environment]::OSVersion.Version.Revision

if ($winVer -ne $minVer[0]) {
    Write-Host "Version: `t`tWindows $winVer "      -ForegroundColor Red
    Write-Host "Build: `t`t`t$buildVer"             -ForegroundColor Gray
    Write-Host "Revision: `t`t$revVer"              -ForegroundColor Gray
    Write-Host "Only Windows 10 is supported, as far as we know!"      -ForegroundColor Red
} elseif ($winVer -eq $minVer[0]) {
    if ($buildVer -lt $minVer[1]) {
        Write-Host "Version: `t`tWindows $winVer "  -ForegroundColor Green
        Write-Host "Build: `t`t`t$buildVer"         -ForegroundColor Red
        Write-Host "Revision: `t`t$revVer"          -ForegroundColor Gray
        Write-Host "The system has only been tested for build 19042 (20H2)" -ForegroundColor Red
    } elseif ($buildVer -ge $minVer[1]) {
        Write-Host "Version: `t`tWindows $winVer "  -ForegroundColor Green
        Write-Host "Build: `t`t`t$buildVer"         -ForegroundColor Green
        Write-Host "Revision: `t`t$revVer"          -ForegroundColor Green
    }
}

#####################################################################
# Control Toolchain paths ###########################################
Write-Host "`nToolchain paths:" -ForegroundColor Magenta
write-output "Toolchainpath `t`t$env:GNUARMEMB_TOOLCHAIN_PATH"  -ForegroundColor Gray
write-output "Toolchain variant `t$env:ZEPHYR_TOOLCHAIN_VARIANT"  -ForegroundColor Gray
write-output "Zephyr Base `t`t$env:ZEPHYR_BASE"  -ForegroundColor Gray

Write-Host "`nWest:" -ForegroundColor Magenta

$manifest = west config -l
$manifest = $manifest -split '='
$printVal = $manifest[1]
if($manifest[1] -eq "insert_manifest_folder_here") {
    Write-Host "Manifest path: `t`t$printVal"  -ForegroundColor Gray
} else {
    Write-Host "Manifest path: `t`t$printVal" -ForegroundColor Red
}

$printVal = $manifest[3]
if($manifest[3] -eq "zephyr") {
    Write-Host "Zephyr Base: `t`t$printVal"  -ForegroundColor Gray
} else {
    Write-Host "Zephyr Base: `t`t$printVal" -ForegroundColor Red
}

$westDir = west topdir
Write-Host "Top dir: `t`t$westDir" -ForegroundColor Gray


#####################################################################
# Externals #########################################################
Write-Host "`nBoards:" -ForegroundColor Magenta

$externalBoards = @(nrfjprog -i)
$visible2PC     = $externalBoards.Count
$family         = @(nrfjprog -i)

for ($serNum = 0; $serNum -lt $visible2PC; $serNum++) {
    $family[$serNum] = nrfjprog --snr $family[$serNum] --deviceversion
}

if ($visible2PC -le 0) {
    Write-Host "Connected: `t`t$visible2PC"  -ForegroundColor Red
} else {
    Write-Host "Connected: `t`t$visible2PC" -ForegroundColor Gray
    
    $externalBoards = $externalBoards -join ', '
    Write-Host "Serials: `t`t$externalBoards" -ForegroundColor Gray

    $family = $family -join ', '
    Write-Host "Types: `t`t`t$family" -ForegroundColor Gray
}


#####################################################################
# Other #############################################################
Write-Host "`nOther:" -ForegroundColor Magenta
Write-Host "Current folder: `t$PSScriptRoot" -ForegroundColor Gray


## Script finished ##################################################
$endTime = Get-Date
$timePassed = $endTime - $startTime
[system.media.systemsounds]::Hand.play()
Write-Host "`n$endTime Script finished after $timePassed!" -ForegroundColor Magenta