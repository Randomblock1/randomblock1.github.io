---
title: "Running Windows 10 on Raspberry Pi KVM"
categories:
  - blog
tags:
  - Linux
  - Raspberry Pi
---
You may or may not know this, but Windows 10 is in fact completely compatible with ARM64.
ARM architectutures are very efficient, which makes them perfect for mobile devices, including laptops.
So, of course, Microsoft compiled Windows 10 for ARM64. It's not easy to download, but it can be done.
And once you have an ISO, you can run Windows 10 on a Raspberry Pi 3/4 at near-native speed.

Let's get started.

1. Prerequisites

- QEMU (or compile it, see below)
- 64-bit Kernel (NOT default in Raspbian yet)
- At least 30GB of free space

2. Get the ISO

    Go visit [this website](https://uupdump.ml/known.php?q=1909+arm64) and download the cumulative update for this version. Choose "Download and convert to ISO" to obtain an ISO file.

3. Make the newest QEMU (optional)

    To make sure you get the newest features and bugfixes, compile QEMU from tbe latest source. Visit [the QEMU download page](https://www.qemu.org/download/) and and follow the build instructions under the Source tab. You'll want to uninstall your distro's QEMU packages and run ```sudo make install``` once you're done building QEMU.
4. Make the QCOW2 disk file

    Go run ```qemu-img create -f qcow2 disk.qcow2 32G``` on your Raspberry Pi, wherever you want to store the files. It must be at least 24GB, as that's about how big Windows is.

5. Get VirtIO drivers

    Download [the VirtIO driver ISO for Windows](https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html#virtio-win-direct-downloads).

6. Get EDK2 files

    Download the edk2.git-aarch64 RPM file from [here](https://www.kraxel.org/repos/jenkins/edk2/). Then, extract QEMU_EFI.fd and vars-template-pflash.raw from it. This will be used later.

7. Create start script

    Finally. It's time to get started.
    Use your favorite text editor to create start.sh: 

    ```
    qemu-system-aarch64 -M virt -cpu host \
        -smp 4 -m 2048 \
        -device qemu-xhci\
        -device usb-kbd\
        -device usb-tablet \
        -drive file=disk.qcow2,if=virtio \
        -nic user,model=virtio-net-pci \
        -drive file="Windows.iso",media=cdrom,if=none,id=cdrom \
        -device usb-storage,drive=cdrom \
        -drive file="virtio.iso",media=cdrom,if=none,id=drivers \
        -device usb-storage,drive=drivers \
        -bios QEMU_EFI.fd \
        -device ramfb \
        -enable-kvm \
        -vnc 0.0.0.0:15
    # Remember to set Windows.iso and virtio.iso to the names or paths of the ISO files you have. 
    # You can also remove the last line (-vnc ...) if you don't want to have a VNC connection open. VNC is useful for headless systems and remote controlling Windows. It's not neccesary though.
    ```

8. Set Up Windows

    Run ```chmod 755 start.sh && ./start.sh``` and install Windows. 
    When it can't find any storage devices to install to, choose "Install Drivers", select the VirtIO driver disk, and open viostor/w10/ARM64. 
    Also, do the same thing and install the NetKVM/w10/ARM64 driver as well.
    Then, install Windows as normal.

9. Optimize Windows

    Open Command prompt and run:
    ```
    REM Disable Printing
    sc stop "Spooler"
    sc config "Spooler" start= disabled
    REM Disable Windows Search Indexing
    sc stop "WSearch"
    sc config "WSearch" start= disabled
    REM Disable Automatic Defragmentation
    schtasks /Delete /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /F
    REM Disable Pagefile
    wmic computersystem set AutomaticManagedPagefile=FALSE
    wmic pagefileset delete
    REM Disable Hibernation
    powercfg -h off
    ```

10. Change Display Resolution (optional)

    If you built QEMU from source or your QEMU version is higher than 5.1.0, you can increase your display resolution.

    Add the following somewhere in your start.sh:
    ```-drive file=vars-template-pflash.raw,if=pflash,index=1```

    Then, set your display resolution up to 1024x768 in Device Manager > OVMF Platform Configuration. It's limited to a relatively small resolution, due to standard VGA support not being supported, and having to use ramfb instead. This may change in the future, but we have to use ramfb for now.

11. Done!
    You're now done installing Windows 10 in a Raspberry Pi KVM!

This guide is based on [this one by Kitsunemi.](https://kitsunemimi.pw/notes/posts/running-windows-10-for-arm64-in-a-qemu-virtual-machine.html)