param(  
      [Parameter(Mandatory=$true, 
      HelpMessage="Name your VM")]    
      $vmname,
      [Parameter(Mandatory=$false, 
      HelpMessage="Select your TCBSD image")]    
      $tcbsdimagefile="TCBSD-x64-12-40411.iso",
      [Parameter(Mandatory=$false, 
      HelpMessage="Where is your VirtualBox installation?")]    
      $virtualBoxPath = 'C:\Program Files\Oracle\VirtualBox'
)

$workingDirectory=pwd

if(!(Test-Path $virtualBoxPath))
{

    Write-Warning 'You do not have the VirtualBox installed at' $virtualBoxPath  
    $answer = Read-Host 'Would you like me to download the VirtualBox and install it [Y]es [N]o?'
    if($answer.ToUpperInvariant() -eq 'Y')
    {
        Invoke-WebRequest https://download.virtualbox.org/virtualbox/6.1.30/VirtualBox-6.1.30-148432-Win.exe -OutFile VirtualBoxInstall.exe
        .\VirtualBoxInstall.exe    
    }
    else
    {
        Write-Warning "Installation of VirtualBox not found. Install it manually or if you have it installed on other location than $virtualBoxPath pass the path as parameter of this script and run it again."
        exit
    }
}


if (!(Test-Path $tcbsdimagefile))
{
    Write-Warning "You will need to login into Beckhoff site to dowload TCBSD image requeste image is: $tcbsdimagefile" 
    Write-Warning "Download the $tcbsdimagefile to $workingDirectory. Then run the script again"
    Write-Warning "Presse any key to go download page"
    Read-Host
    Start https://www.beckhoff.com/en-en/products/ipc/software-and-tools/operating-systems/c9900-s60x-cxxxxx-0185.html 
    exit   
}

cd $virtualBoxPath
Write-Output "Creating Virtual Machine TwinCAT 3 BSD"

.\VBoxManage createvm --name $vmname --basefolder $workingDirectory --ostype FreeBSD_64 --register > $null
.\VBoxManage modifyvm $vmname --memory 1024 --vram 128 --acpi on --hpet on --graphicscontroller vmsvga --firmware efi64 > $null

$installer_image="TcBSD_installer.vdi"
$runtime_image="TcBSD.vhd"
$vmdirectory= Join-Path $workingDirectory $vmname
$sink=Join-Path $vmdirectory $installer_image
$source=Join-Path $workingDirectory $tcbsdimagefile

Write-Output "converting img image to virtualbox bootable HDD image"
$output = .\VBoxManage convertfromraw --format VDI $source $sink 2>&1

Write-Output "Creating SATA storage Controller"
.\VBoxManage storagectl $vmname --name SATA --add sata --controller IntelAhci --hostiocache on --bootable on > $null

Write-Output "attaching to installation HDD to Sata Port 1"
.\VBoxManage storageattach $vmname --storagectl "SATA" --device 0 --port 1 --type  hdd --medium $sink > $null

Write-Output "creating empty HDD"
$runtime_hdd=Join-Path $vmdirectory $runtime_image
$output = .\VBoxManage createmedium --filename $runtime_hdd --size 4096 --format VHD 2>&1

Write-Output "attaching created HDD to Sata Port 0 where we will install TwinCAT BSD"
.\VBoxManage storageattach $vmname --storagectl "SATA" --device 0 --port 0 --type  hdd --medium $runtime_hdd  > $null

$vmpath = Join-Path $workingDirectory $vmname
$vmpath = Join-Path $vmpath "$vmname.vbox"

Start $vmpath

Write-Host "Continue the installation of TCBSD in the VirtualBox"

cd $workingDirectory

 