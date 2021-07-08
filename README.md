# NCS-Build-script
Powershell script for building and flashing several Development Kits, when working with nRF Connect SDK (Nordic Semiconductor). Developed to be used with Visual Studio Code and the Powershell extension.

## How to utilize
Put the build.ps1 file in the same folder as the "/src/" folder and run it, configure the script to your own desire and run it.

## How it should behave
The script will print the added information in purple, and if the build is sucessfull a pleasant interval of notes are played. If not successfull a unpleasant interval of notes are played. A windows sound is played at the end of the script. The audio feedback is to give you the opportunity to work on other things, instead of watching the build log roll by.
