# TwinCAT-BSD-VM-creator
the script creates VirtualBox Virtual Machine from Twincat BSD image provided by [Beckhoff Automation](https://www.beckhoff.com/en-en/products/ipc/software-and-tools/operating-systems/c9900-s60x-cxxxxx-0185.html)

## Using the batch file

Download TwinCAT BSD image from Beckhoff automation website;
Extract the zip file in the same directory where the script is located.
the image file will be xxxx.iso
open the script and modify the line 3 the "TCBSD-x64-12-40411.iso" to match your image name

SET sourcefilename="new image name.iso"

## Using PowerShell script

Run `Create-TcBsdVM.ps1` where the first parameter is the virtual machine name and the second is the TCBSD image file that you will need to download and unzip the working folder.

The script will also verify the `VirtualBox` installation at the location `Program Files\Oracle\VirtualBox` on the same drive where the working folder is located. If you have the VirtualBox installed in some other location, provide the path to that folder at the third positional parameter of the script.

The virtual machine folder will be created in the working folder.

Usage

~~~PowerShell
PS C:\YOUR_FOLDER\.\Create-TcBsdVM.ps1 MyLovelyTcBSD TCBSD-x64-12-40411.iso
~~~

# Setting up the network interface

If VMs network defaults to `NAT`, you may not be able to connect to the PLC. Therefore you should set the virtual network either to `Host-Only Adapter` if you are working with the PLC only from the host computer; or `Bridged Adpater` to set up a physical connection to the outside network.

![Host only](assets/pics/host-only.png)
![Bridged](assets/pics/host-only.png)





