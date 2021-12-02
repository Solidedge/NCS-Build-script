# NCS-Build-script
Powershell script for building and flashing several Development Kits, when working with nRF Connect SDK (Nordic Semiconductor). Developed to be used with Visual Studio Code and the Powershell extension.

## How to utilize
Put the build.ps1 file in the same folder as the "/src/" folder and run it, configure the script to your own desire and run it.

# Disclaimer
It's been a while since I set this up to work, do so at your own risk! You might need to alter the execution policy, which is done by entering "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass" in your powershell terminal.

## Dependencies
- NCS toolchain
- West
- nrfjprog
- Windows

## How it should behave
The script will print the added information in purple, and if the build is successful a pleasant interval of notes are played. If not successful a unpleasant interval of notes are played. A windows sound is played at the end of the script. The audio feedback is to give you the opportunity to work on other things, instead of watching the build log roll by.
