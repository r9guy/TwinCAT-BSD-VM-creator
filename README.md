# TwinCAT-BSD-VM-creator
script creates VirtualBox Virtual Machine from Twincat BSD image provided by [Beckhoff Automation](https://www.beckhoff.com/en-en/products/ipc/software-and-tools/operating-systems/c9900-s60x-cxxxxx-0185.html)

## Using batch file

download TwinCAT BSD image from beckhoff automation website.
extract the zip file in the same directory where the script is located.
the image file qill be xxxx.img
open the script and modify on line 3 the "TCBSD-x64-12-40411.iso" to match your image name

SET sourcefilename="new image name.iso"

## Using PowerShell script

Run `Create-TcBsdVM.ps1` where the firt paramter is the virual machine name and the second is the TCBSD image file that you will need to download and unzip the working folder.

The script will also verify the installation of the `VirtualBox` at the location `Program Files\Oracle\VirtualBox` on the same drive where the working folder is located. If you have the VirtualBox installed in some other location provide path to that folder at third positional paramters of the script.

The vitual machine folder will be created in the working folder.

Usage

~~~PowerShell
PS C:\YOUR_FOLDER\.\Create-TcBsdVM.ps1 MyLovelyTcBSD TCBSD-x64-12-40411.iso
~~~

# Setting up the newtowk interface

If VMs network is set up to `NAT` you may not be able to connect to the PLC. You should the setting of the virtual network card either to `Host-Only Adapter` if you are working with the PLC only from the host computer; or `Bridged Adpater` to set-up real connection to outside network.

![Host only](assets/pics/host-only.png)
![Bridged](assets/pics/host-only.png)





