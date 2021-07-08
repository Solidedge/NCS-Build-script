# Powershell-script containing usefull commands for working with nRF Connect SDK
#
# Select line, or mark sequential lines, and press F8 to run that specific code.
#

# Safety feature to prevent the script from being run from top to bottom by accidentally pressing F5
exit

#List which boards are connected.
Write-Host "`r"
$allSerials = @(nrfjprog -i)
$numBoards  = $allSerials.Count
for ($board = 0; $board -lt $numBoards; $board++) {
    nrfjprog --snr $allSerials[$board] --deviceversion
    Write-Host "`r"
}

exit #Safety feature

west flash --recover

#Build to 5340 app
Set-Location INSERT_LOCATION_OF_FOLDER
Remove-Item -LiteralPath 'build' -Force -Recurse
west build -b nrf5340dk_nrf5340_cpuapp

exit #Safety feature

#Build to 5340 net
Set-Location INSERT_LOCATION_OF_FOLDER
Remove-Item -LiteralPath 'build' -Force -Recurse
west build -b nrf5340dk_nrf5340_cpunet

exit #Safety feature

#Resets
nrfjprog --pinreset     #Performs a pin reset. Core will run after the operation.

exit #Safety feature

nrfjprog --reset        # Performs a soft reset by setting the SysResetReq
                        # bit of the AIRCR register of the core. The core
                        # will run after the operation. Can be combined with
                        # the --program operation. If combined with the
                        # --program operation, the reset will occur after
                        # the flashing has occurred to start execution.

exit #Safety feature

nrfjprog --debugreset   # Performs a soft reset by the use of the CTRL-AP.
                        # The core will run after the operation. Can be
                        # combined with the --program operation. If combined
                        # with the --program operation, the debug reset will
                        # occur after the flashing has occurred to start
                        # execution.
                        # Limitations:
                        # For nRF51 devices, the --debugreset operation is
                        # not available.
                        # For nRF52 devices, the --debugreset operation is
                        # not available for nRF52832_xxAA_ENGA devices.
exit #Safety feature