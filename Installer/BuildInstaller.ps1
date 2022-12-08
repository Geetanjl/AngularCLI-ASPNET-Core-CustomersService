<#
.SYNOPOSIS
This is a simple quick and dirty powershell script to build the Installer

.DESCRIPTION
This script is to make sure that the arguments are passed correctly to the IS build including the setup version

.EXAMPLE
Just call the script from the build definition in TFS

.NOTES
    Author: Mary Shatby
    Date: Oct 22, 2018

#>

$BuildNum=$Env:BUILD_BUILDNUMBER
#$BuildNum="Develop.Nova_2020.6.4.2"
$BuildDef=$Env:BUILD_DEFINITIONNAME
$BuildSrcDir= $Env:BUILD_SOURCESDIRECTORY
$BuildSrcDir="C:\dev\tools\agent\_work\4\s"
"Build Source directory is $BuildSrcDir"
$ISCmdBld= '"C:\Program Files (x86)\InstallShield\2022\System\IsCmdBld.exe"'
$Path_2_ISM="$BuildSrcDir"+"\Installer\CoustmerService.ism"
"Path 2 ism is $Path_2_ism"

$setupPath=$BuildSrcDir +"\Installer\CoustmerService\PROJECT_ASSISTANT\SINGLE_EXE_IMAGE\DiskImages\DISK1\CustomerService.exe"
"setup path is $setupPath"

#$OutFile="BldInstaller.out"
"********Extracting the version to be passed to ISCmd from the build definition*********"
"*********Build Number Passed is $BuildNum....MUST BE STRING_NUM****"
# $parts=$BuildNum -split '_'
$ver= $BuildNum # $parts[1]
"Version Extracted is $ver"

$ISCommand= "$ISCmdBld -x -p $Path_2_ISM -l PATH_TO_BUILDROOT=$BuildSrcDir -y $ver"

Write-Host '***Calling Script to Build Installer ***' #*> $OutFile
iex "&$ISCommand"

#iex "&$ISCommand *>> $OutFile"

"************ Checking Exit Status *****************"
if ($LastExitCode -notmatch 0) {write-error "Error In Installer Command $Error"}
else {"SUCCESS"}

$newName=$BuildSrcDir +"\Installer\"+"CustomerService_Setup_"+$ver+".exe"
"************* Installer will be renamed to $newName ***********"
rm -Force $BuildSrcDir\Installer\CustomerService*.exe
mv $setupPath $newName
