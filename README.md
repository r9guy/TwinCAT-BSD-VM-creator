# TwinCAT-BSD-VM-creator
script creates VirtualBox Virtual Machine from Twincat BSD image provided by [Beckhoff Automation](https://www.beckhoff.com/en-en/products/ipc/software-and-tools/operating-systems/c9900-s60x-cxxxxx-0185.html)

download TwinCAT BSD image from beckhoff automation website.
extract the zip file in the same directory where the script is located.
the image file qill be xxxx.img
open the script and modify on line 3 the "TCBSD-x64-12-40411.iso" to match your image name

SET %sourcefilename%="new image name.iso"

