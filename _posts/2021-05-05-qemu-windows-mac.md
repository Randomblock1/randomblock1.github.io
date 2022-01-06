---
title: "Running Windows 10 on M1 Mac with QEMU & Hypervisor.Framework"
categories:
  - blog
tags:
  - MacOS
---
M1 Macs don't have support for Bootcamp. So, in order to have a working Windows environment, you have to do it all in a virtual machine. The problem is that QEMU isn't optimized for M1 Macs, and virtualization is very slow... unless it uses MacOS' Hypervisor.Framework. While this isn't quite as performant as paid solutions (like Parallels), it works 'fast enough' and is completely free.

Updated 1/6/22: Building your own QEMU is no longer needed. It's been merged into the main branch, woohoo! Just make sure your QEMU is up-to-date (6.2 or higher.)

Let's get started.

1. Prerequisites
    - M1 Mac
    - 32GB of Free Space

2. Get Windows for ARM

    Go visit [the Windows for ARM download page](https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewARM64) and sign in with a Microsoft account. Then, download the VHDX file.
    <details>
        <summary>View optional build instructions</summary>

    You can still build your own QEMU if you want, but you don't really need to anymore. You can just use the Homebrew binaries. You really should just skip this part.

    Build QEMU with HV.F support

    ```bash
    brew install ninja pkgconfig glib pixman
    wget https://download.qemu.org/qemu-6.2.0.tar.xz
    tar xvJf qemu-6.2.0.tar.xz
    cd qemu-6.2.0
    ./configure
    make
    ```

    </details>

3. Enable extra resolutions for ramfb

    ```bash
    curl -L https://git.io/J3w5c | tar xz
    dd if=/dev/zero of=pflash0.img bs=1m count=64
    dd if=/dev/zero of=pflash1.img bs=1m count=64
    dd if=QEMU_EFI.fd of=pflash0.img conv=notrunc
    dd if=QEMU_VARS.fd of=pflash1.img conv=notrunc
    ```

4. Make the QCOW2 disk file

    Now that you've built QEMU, the Windows VHDX is probably done downloading. We want to convert it to a QCOW2 file, so we can take snapshots of it and compress it.

    `qemu-img convert -O qcow2 Windows.vhdx disk.qcow2`

    Remember to change Windows.vhdx to the path to your own vhdx file. Now you just wait; this might take a while.
    Once it's done, delete the original VHDX file, as we no longer need it.

5. How to take a QCOW2 snapshot

    We are going to take a snapshot of our QCOW2 file, just in case anything goes wrong during installation. That way, we won't have to redownload the VHDX file.

    `qemu-img snapshot disk.qcow2 -c brand_new`

    Remember to take another differently-named snapshot after installation is complete (I like to name mine clean_install). If something goes wrong and you need to revert to a snapshot, just do

    `qemu-img snapshot disk.qcow2 -l` to list snapshots, and

    `qemu-img snapshot disk.qcow2 -a SNAPSHOT_NAME` to revert to a snapshot.

6. Get VirtIO drivers

    Download [the LATEST VirtIO driver ISO for Windows](https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md).

7. Create start script

    Finally. It's time to get started.
    Use your favorite text editor to create start.sh:

    ```bash
    qemu-system-aarch64 \
        -accel hvf \
        -cpu host \
        -smp 4 -m 2048 \
        -M virt,highmem=off
        -device qemu-xhci \
        -device usb-kbd \
        -device usb-tablet \
        -drive file=disk.qcow2,if=none,id=windows \
        -device nvme,drive=windows,serial="dummyserial" \
        -nic user,model=virtio \
        -drive file="virtio.iso",media=cdrom,if=none,id=drivers \
        -device usb-storage,drive=drivers \
        -monitor stdio \
        -device ramfb \
        -drive file=pflash0.img,format=raw,if=pflash,readonly=on \
        -drive file=pflash1.img,format=raw,if=pflash \
    ```

8. Set Up Windows

    Run `chmod 755 start.sh && ./start.sh` to run Windows.

    When QEMU first starts up, select the window and press ESC before it starts booting.
    This will make it boot into its BIOS so we can configure it.

    Set your display resolution up to 1440x900 in Device Manager > OVMF Platform Configuration (or any other resolution you want to use). It's limited to a relatively small resolution, due to standard VGA for ARM64 not being supported, and having to use ramfb instead. This may change in the future, but we have to use ramfb for now.

    Save the settings, and select Reset in the main BIOS menu to test out your new resolution. Then, just set up Windows.

    You'll notice that Windows doesn't have Internet access at first. To enable Internet access, once you have opened your desktop, open up a Command Prompt terminal as Administrator:

    `bcdedit.exe -set TESTSIGNING ON`

    Reboot, then open Device Manager in Windows. Select View>Devices by Connection in the top menu bar.

    Select ACPU ARM64-based PC>Microsoft ACPI-Compliant System>PCI Express Root Complex>Unknown device.

    Right click 'Unknown device' then select Update Drivers>Browse my computer for drivers>D:\NetKVM\w10\ARM64. Click next to install the driver. Once that's done, shutdown, take a snapshot, and remove the following files from your start script:

    ```bash
    -drive file="virtio.iso",media=cdrom,if=none,id=drivers \
    -device usb-storage,drive=drivers \
    ```

9. Optimize Windows (optional)

    Windows isn't really expecting to be run inside a virtual machine, so we're going to add some small tweaks to make it faster.

    Open Command prompt and run:

    ```bash
    REM Disable Printing
    sc stop "Spooler"
    sc config "Spooler" start= disabled
    REM Disable Automatic Defragmentation
    schtasks /Delete /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /F
    REM Disable Pagefile
    wmic computersystem set AutomaticManagedPagefile=FALSE
    wmic pagefileset delete
    REM Disable Hibernation
    powercfg -h off
    ```

    If you want to save some space, if you've taken a second snapshot of the fully set-up virtual machine, you can run

    `qemu-img snapshot disk.qcow2 -d brand_new`

    to delete the first snapshot.

10. Done!
    You're now done installing Windows 10 on your M1 Mac! It's not terribly fast, but it works well and is fast enough to do most things.
