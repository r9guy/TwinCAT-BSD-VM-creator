SET current_directory=%~dp0
SET sourcefilename="TCBSD-x64-12-44089.iso"

cd "/Program Files/Oracle/VirtualBox

SET vmname="TwinCAT 3 BSD"

set installer_image="TcBSD_installer.vhd"
set runtime_image="TcBSD.vhd"
set vmdirectory=%current_directory%%vmname:"=%

set sink=%vmdirectory%\%installer_image:"=%
set source=%current_directory%%sourcefilename:"=%



:recreatevm
echo "creating Virtual Machine TwinCAT 3 BSD"
VBoxManage createvm --name %vmname% --basefolder %current_directory% --ostype FreeBSD_64 --register
if  ERRORLEVEL 1    (
    echo VM already exists, deleteing existing
    VBoxManage unregistervm %vmname% --delete 
    goto recreatevm
) 

VBoxManage modifyvm %vmname% --memory 2048 --vram 128 --acpi on --hpet on --graphicscontroller vmsvga --firmware efi64
:recreateIf
VBoxManage modifyvm %vmname% --nic1 hostonly --hostonlyadapter1 none
if ERRORLEVEL 1 (
    echo host interface doesnt exist, creating one
    VBoxManage hostonlyif create
    goto recreateIf
)




echo "converting img image to virtualbox bootable HDD image"
VBoxManage convertfromraw "%source%" "%sink%" --format VHD



VBoxManage modifyvm %vmname% --nic2 nat


echo "Creating SATA storage Controller"
VBoxManage storagectl %vmname% --name SATA --add sata --controller IntelAhci --hostiocache on --bootable on


echo "attaching to installation HDD to Sata Port 1
VBoxManage storageattach %vmname% --storagectl "SATA" --device 0 --port 1 --type  hdd --medium "%sink%"

set /p hddsize="Storege size in MB:"

echo "creating empty HDD"
set runtime_hdd=%vmdirectory%\%runtime_image:"=%
VBoxManage createmedium --filename "%runtime_hdd%" --size %hddsize% --format VHD


echo "attaching created HDD to Sata Port 0 where we will install TwinCAT BSD"
VBoxManage storageattach %vmname% --storagectl "SATA" --device 0 --port 0 --type  hdd --medium "%runtime_hdd%"

