--
title: "Pi 5 / CM5 Errata: USB VBUS up before host ready"
categories:
  - blog
tags:
  - Electronics
---

# 5 generations of SBCs, and they messed up USB.

## Context

At work, I needed to use a Pi CM5 (in its IO board) to control an Android device via ADB. Sounds simple, what could possibly go wrong? 
I mean, controlling another device with USB... that's like what the Pi was made for! And the Android in question was a Google Pixel, THE Android phone, by the people who made Android. This was going to be easy.

Well, I found that if the phone was connected while the Pi rebooted, it would not be detected again, unless a physical replug happened. At first I thought this was because the data lines needed to be disconnected (Hi-Z) or something.

Not so, the bug is much simpler, but it's in something I didn't even know you _could_ mess up.

## Problems

Eventually I narrowed down this behavior to 2 things that combined:

1. Pi-side
  - The CM5 drops VBUS for a few seconds on reboot
  - The CM5 brings up VBUS before the host is alive and it hasn't actually set up xHCI USB yet (data lines not ready)
  - The phone sees VBUS return while data lines are attached to a dead uninitialized PHY.

2. Android-side
  - Android runs BC1.2 charger detection when VBUS appears and latches the result. Since host isn't pulling down data lines, detection concludes "AC charger" and the phone enters charge-only mode. Only a VBUS event can make it re-run detection.
  - It does not even try to enable ADB since it thinks it's not connected to a computer.

<details>
<summary>What is BC1.2?</summary>

  ## What is BC1.2?
  
  ### Definitions
  
  The specification defines three distinct port types to manage current and data capabilities:
  
  - Standard Downstream Port (SDP): Provides 500 mA (USB 2.0) or 900 mA (USB 3.0) and supports full data enumeration. 
  - Charging Downstream Port (CDP): Supports data enumeration and provides up to 1.5 A for charging. 
  - Dedicated Charging Port (DCP): Supplies up to 1.5 A for charging only, with no data transmission support.
  
  ### Explanation
  
  BC1.2 is a USB standard for charger detection, triggered by VBUS rising:
  
  1. Data Contact Detect. Phone sources ~10 µA into D+ and waits for it to drop below ~0.8 V. A host's 15 k resistor would hold it at ~0.15 V. With nothing there, D+ drifts up and the phone times out after ~0.3–0.9 s.
  2. Primary detection. Phone drives D+ to 0.6 V through a source and sinks ~100 µA from D−, then reads D−. On a host, D− is held near 0 V by its 15 k → "SDP". On a dedicated charger, D+ and D− are shorted so D− reads 0.6 V → "DCP".
  
  On a DCP result the phone enables 1.5 A charging and does not turn on its 1.5 kΩ D+ pull-up, which is how a device announces itself. When the kernel finally powers the PHY, the host sees D+ and D− both at 0 V through its own pull-downs, i.e. an empty port.
  It has no way to tell a charge-only phone from an unplugged cable. The phone's classification is latched; only VBUS dropping makes the it run BC1.2 detection again.
  
  ---
  
</details>

Essentially, the Pi 5 does not properly handle its VBUS. So the phone looks to see if it's connected to a computer, sees it isn't, and goes "oh well, I tried". 

Shortly after, the Pi wakes up and is patiently waiting for a device to show up, unaware that it has essentially ding dong ditched the device. Or maybe it's the other way around? The device tries to knock, to no answer.

Doesn't matter. Here's how to fix it.

## Reproduce

You might need to specify xhci-hcd.1 instead of 0 depending on the physical USB port you use.

```bash
adb devices # hi phone!!
echo xhci-hcd.0 | sudo tee /sys/bus/platform/drivers/xhci-hcd/unbind   # host "dead" VBUS stays on
# unplug and replug the phone -> it latches charge-only
echo xhci-hcd.0 | sudo tee /sys/bus/platform/drivers/xhci-hcd/bind     # host live
adb devices # phone gone :(
```

## Fix

The proper solution is to keep VBUS low until the host is actually ready to accept USB devices. I might file a kernel issue later.

The workaround is to pulse VBUS, making the phone realize it is actually connected to a USB host.

On Pi 5, USB_VBUS_EN (GPIO 42) controls VBUS.

```bash
pinctrl set USB_VBUS_EN op dl    # VBUS off
sleep 1
pinctrl set USB_VBUS_EN op dh    # VBUS on, device reconnects
```

Create a systemd service to do this automatically on boot:

```systemd
# /etc/systemd/system/usb-vbus-pulse.service
[Unit]
Description=Pulse USB VBUS so devices attach to a live host
After=multi-user.target
# If a specific service talks to the phone, add:  Before=that.service  and set that.service After=usb-vbus-pulse.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'pinctrl set USB_VBUS_EN op dl; sleep 1; pinctrl set USB_VBUS_EN op dh'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

And of course `sudo systemctl enable --now usb-vbus-pulse`.

Once that's done, you shouldn't run into this issue again.
