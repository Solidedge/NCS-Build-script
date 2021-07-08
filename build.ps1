# Powershell-script for building and flashing unto nRF-DK with nRF Connect SDK toolchain.
# The Powershell extension, by Microsoft is needed to run this script in VS Code.
# Fill out the local variables before first run.
#
# Press "F5" to start powershell and run script, 
# press "F8" to run current line or marked content.
#
# This file should be placed above the src-folder.
# To avoid messy terminal log, press: CTRL+Shift+P, and search for tclear command.


Clear-Host
Write-Host "STARTING SCRIPT" -ForegroundColor Magenta
$startTime = Get-Date

Write-Host "...Setting variables" -ForegroundColor Magenta
## Paths
$currentPath    = $PSScriptRoot
$ncsFolder      = west topdir
$buildFileCheck  = "\build\zephyr\zephyr.hex"

## Process settings
$deleteBuildFiles           = $true     # Buildfiles are deleted before each build.
$buildWithoutBoard          = $false    # Build without connecting a board
$fakeBoard                  = @("nrf5340dk_nrf5340_cpuapp", "nrf5340dk_nrf5340_cpunet")
$forceFlash                 = $false    # Flash regardless of build success
$flashAfterBuild            = $true     # Flash after each build
$confirmEveryPerformedFlash = $false    # Only functional for 53 and 91
$nrf91Check                 = $false
$logFlashProcess            = $false    # Not inmplemented yet
$reset840AfterFlash         = $true     # Temporary fix for 840 not booting correctly

 
## Supported board types
$BoardSpecs = @(
    [pscustomobject]@{  DevKit          = 'NRF5340 DK 0.11'; 
                        DeviceVersion   = 'NRF5340_xxAA_ENGD';
                        CoreVariants    = @("nrf5340dk_nrf5340_cpuapp", 
                                            "nrf5340dk_nrf5340_cpunet");
                        CoreNames       = @("Applikasjonskjernen",
                                            "Nettverkskjernen");
                        FilePaths       = @("$currentPath",
                                            "$ncsFolder\nrf_midi_priv\samples\hci_rpmsg\");
                        ProjectSupport  = $true
                        Boards2Flash    = 0
                        BoardSerials    = $null
                    }
    [pscustomobject]@{  DevKit          = 'NRF9160'; 
                        DeviceVersion   = 'NRF9160_xxAA_REV2';
                        CoreVariants    = @("nrf9160dk_nrf9160ns", 
                                            "nrf52840dk_nrf52840");
                        CoreNames       = @("Modem-delen",
                                            "BLE-delen");
                        FilePaths       = @("$currentPath",
                                            "$ncsFolder\nrf_midi_priv\samples\hci_rpmsg\")
                        ProjectSupport  = $false
                        Boards2Flash    = 0
                        BoardSerials    = $null
                    }
    [pscustomobject]@{  DevKit          = 'NRF52840 REV1'; # On nRF9160 Rev2 DK
                        DeviceVersion   = 'NRF52840_xxAA_REV1';
                        CoreVariants    = @("nrf52840dk_nrf52840");
                        CoreNames       = @("840-en");
                        FilePaths       = @("$currentPath")
                        ProjectSupport  = $false
                        Boards2Flash    = 0
                        BoardSerials    = $null
                    }
    [pscustomobject]@{  DevKit          = 'NRF52840 REV2'; 
                        DeviceVersion   = 'NRF52840_xxAA_REV2';
                        CoreVariants    = @("nrf52840dk_nrf52840");
                        CoreNames       = @("8-40-en");
                        FilePaths       = @("$currentPath")
                        ProjectSupport  = $true
                        Boards2Flash    = 0
                        BoardSerials    = $null
                    }
    [pscustomobject]@{  DevKit          = 'NRF52832 REV2'; 
                        DeviceVersion   = 'NRF52832_xxAA_REV2';
                        CoreVariants    = @("nrf52dk_nrf52832");
                        CoreNames       = @("8-32-en");
                        FilePaths       = @("$currentPath")
                        ProjectSupport  = $false
                        Boards2Flash    = 0
                        BoardSerials    = $null
                    }
)

$nrf5340pdkA    = 0
$nrf5340pdkB    = 1
$nrf5340dk      = 2
$nrf9160        = 3
$nrf52840r1     = 4 # On nRF9160 Rev2 DK
$nrf52840r2     = 5
$nrf52832       = 6

## Checks how many boards are connected
Write-Host "...Checking for connected boards" -ForegroundColor Magenta
$allSerials      = @(nrfjprog -i)
nrfjprog -i
$amountOfBoardsConnected    = $allSerials.Count


## Check what type of boards are connected, no building or flashing.
if ($allSerials.Count -eq 0) {
    #No boards connected
    if ($buildWithoutBoard) {
        Write-Host "...No boards connected, no flashing will be performed" -ForegroundColor Magenta
        $flashAfterBuild     = $false

        ## For each type of board spec available
        for ($spec=0 ;$spec -lt $BoardSpecs.Count; $spec++){
            
            ## For each fake board "connected"
            for ($board=0 ;$board -lt $fakeBoard.Count; $board++){
                $boardFamily = $fakeBoard[$board]
                $matchCheck = $boardFamily -Match $BoardSpecs[$spec].DeviceVersion

                if ($matchCheck) {
                    $BoardSpecs[$spec].Boards2Flash++
                    
                    ## Add board serial to flash list
                    if ($BoardSpecs[$spec].BoardSerials -eq $null) {
                        $BoardSpecs[$spec].BoardSerials = @($allSerials[$board])
                    } else {
                        $BoardSpecs[$spec].BoardSerials += $allSerials[$board]
                    }
                }
            }
            
            $printVal1 = $BoardSpecs[$spec].DevKit
            $printVal2 = $BoardSpecs[$spec].Boards2Flash
            $printVal3 = $BoardSpecs[$spec].BoardSerials

            Write-Host "$printVal2 x$printVal1 : $printVal3`r"
        }

        # Build only
    } else {
        Write-Host "...No boards connected, aborting script" -ForegroundColor Magenta
        exit
    }
} else {
    Write-Host "...$amountOfBoardsConnected board(s) connected, checking board variant(s)" -ForegroundColor Magenta
    
    ## For each type of board spec available
    for ($spec=0 ;$spec -lt $BoardSpecs.Count; $spec++){
        
        ## For each board connected
        for ($board=0 ;$board -lt $allSerials.Count; $board++){
            $boardFamily = nrfjprog --snr $allSerials[$board] --deviceversion
            $matchCheck = $boardFamily -Match $BoardSpecs[$spec].DeviceVersion

            if ($matchCheck) {
                ## Checks wether the 840 should have been a 91.
                if ($BoardSpecs[$spec].DevKit -eq "NRF52840" -and $nrf91Check -and $BoardSpecs[$nrf9160].Boards2Flash -eq 0 -and $BoardSpecs[$nrf9160].ProjectSupport) {
                    $coreChanged = $false
                    $BoardSpecs[$nrf9160].BoardSerials = $null
                    while (-Not $coreChanged) {
                        Read-Host "No nRF91 connected, switch to it and press enter to continue"
                        $allSerials      = @(nrfjprog -i)

                        ## For each board connected
                        for ($board=0 ;$board -lt $allSerials.Count; $board++){
                            $boardFamily = nrfjprog --snr $allSerials[$board] --deviceversion
                            $matchCheck = $boardFamily -Match $BoardSpecs[$nrf9160].DeviceVersion

                            if ($matchCheck) {
                                $coreChanged = $true
                            }
                        }                           
                    }

                    #This might create an bug. 
                    $spec = 0
                    $board = 0
                    break
                }

                $BoardSpecs[$spec].Boards2Flash++
                
                ## Add board serial to flash list
                if ($BoardSpecs[$spec].BoardSerials -eq $null) {
                    $BoardSpecs[$spec].BoardSerials = @($allSerials[$board])
                } else {
                    $BoardSpecs[$spec].BoardSerials += $allSerials[$board]
                }
            }
        }
        
        $printVal1 = $BoardSpecs[$spec].DevKit
        $printVal2 = $BoardSpecs[$spec].Boards2Flash
        $printVal3 = $BoardSpecs[$spec].BoardSerials

        Write-Host "$printVal2 x$printVal1 : $printVal3`r"
    }
}

## Build and flash to every supported board variant
for ($build = 0; $build -lt $BoardSpecs.Count; $build++) {
    ## Amount of boards to flash
    if ($BoardSpecs[$build].Boards2Flash -gt 0 -and $BoardSpecs[$build].ProjectSupport) {
        $printVal = $BoardSpecs[$build].DevKit
        Write-Host "...Building and flashing to $printVal" -ForegroundColor Magenta

        for ($cores = 0; $cores -lt $BoardSpecs[$build].CoreVariants.Count; $cores++) {
            # Change directory for application sample
            $activeDirectory = $BoardSpecs[$build].FilePaths[$cores]
            Write-Host "...Changing directory" -ForegroundColor Magenta
            Write-Host "Set-Location $activeDirectory" -ForegroundColor Yellow
            Set-Location $activeDirectory

            ## Delete old build
            if ($deleteBuildFiles) {
                Write-Host "...Deleting old build-files" -ForegroundColor Magenta
                Write-Host "Remove-Item -LiteralPath 'build' -Force -Recurse" -ForegroundColor Yellow
                Remove-Item -LiteralPath "build" -Force -Recurse
            }

            $printVal = $BoardSpecs[$build].CoreNames[$cores]
            Write-Host "...$printVal" -ForegroundColor Magenta
            
            ## Build
            $printVal = $BoardSpecs[$build].CoreVariants[$cores]
            Write-Host "west build -b $printVal" -ForegroundColor Yellow
            west build -b $BoardSpecs[$build].CoreVariants[$cores]
            

            [System.Console]::Beep(440,100)
            [System.Console]::Beep(523,100)
            ## Checks whether build was succesfull or not.
            if ((Test-Path "$activeDirectory$buildFileCheck" -PathType leaf) -Or $forceFlash) {
                [System.Console]::Beep(659,600)
                $printVal = $BoardSpecs[$build].CoreNames[$cores]
                Write-Host "...Sucessfull build to $printVal!" -ForegroundColor Magenta

                if ($flashAfterBuild) {
                    ## Flash
                    Write-Host "...Running West Flash on $printVal" -ForegroundColor Magenta
                    for ($flash = 0; $flash -lt $BoardSpecs[$build].Boards2Flash; $flash++) {
                        $printVal1 = $flash + 1
                        $printVal2 = $BoardSpecs[$build].Boards2Flash
                        Write-Host "...Flashing board $printVal1/$printVal2"-ForegroundColor Magenta
                        $printVal = $BoardSpecs[$build].BoardSerials[$flash]
                        
                        if ($logFlashProcess) {
                            Write-Host "west flash --snr $printVal" -ForegroundColor Yellow
                            west flash --snr $BoardSpecs[$build].BoardSerials[$flash]
                        } else {
                            Write-Host "west flash --snr $printVal" -ForegroundColor Yellow
                            west flash --snr $BoardSpecs[$build].BoardSerials[$flash]
                        }
                    }

                    $printVal = $BoardSpecs[$build].CoreNames[$cores]
                    Write-Host "...Flashing of $printVal performed" -ForegroundColor Magenta
                    
                    ## If nRF91, prompt change to 840.
                    if ($BoardSpecs[$build].DevKit -eq "NRF9160" -and $cores -eq 0) {
                        $coreChanged = $false

                        while (-Not $coreChanged) {
                            read-host "Change to nRF52 and Press ENTER to continue..."
                            $allSerials      = @(nrfjprog -i)

                            ## For each board connected
                            for ($board=0 ;$board -lt $allSerials.Count; $board++){
                                $boardFamily = nrfjprog --snr $allSerials[$board] --deviceversion
                                $matchCheck = $boardFamily -Match $BoardSpecs[$nrf52840r1].DeviceVersion

                                if ($matchCheck) {
                                    $coreChanged = $true
                                }
                            }                           
                        }
                    } elseif ($confirmEveryPerformedFlash) {
                        read-host "Press ENTER to continue..."
                    }

                    if ($BoardSpecs[$build].DevKit -eq "NRF52840 REV2" -and $reset840AfterFlash -eq $true) {
                        Write-Host "...Resetting 840 (cause it doesn't always work..." -ForegroundColor Magenta
                        for ($resetb = 0; $resetb -lt $BoardSpecs[$build].Boards2Flash; $resetb++) {
                            $printVal = $BoardSpecs[$build].BoardSerials[$resetb]
                            Write-Host "nrfjprog --snr $printVal --reset" -ForegroundColor Yellow
                            nrfjprog --snr $BoardSpecs[$build].BoardSerials[$resetb] --reset
                        }
                    }
                
                } else {
                    Write-Host "...Flash turned off" -ForegroundColor Magenta
                }

            } else {
                [System.Console]::Beep(420,600)
                $printVal = $BoardSpecs[$build].CoreNames[$cores]
                Write-Host "...Failed to build  sample, aborting" -ForegroundColor Magenta
                break
            }
        }
    } elseif ($BoardSpecs[$build].Boards2Flash -gt 0 -and -Not $BoardSpecs[$build].ProjectSupport){
        $printVal = $BoardSpecs[$build].DevKit
        Write-Host "...Board $printVal not supported" -ForegroundColor Magenta
    }
}

## Resetting and changing directory to default
Set-Location $ncsFolder
$endTime = Get-Date
$timePassed = $endTime - $startTime
[system.media.systemsounds]::Hand.play()
Write-Host "$endTime Script finished after $timePassed! To remove terminal log: click CTRL+Shift+P and search for Terminal Clear." -ForegroundColor Magenta

