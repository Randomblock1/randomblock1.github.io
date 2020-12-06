---
title: "Checkra1n-Linux"
excerpt: "Making checkra1n easy to install on Linux systems everywhere"
---

# checkra1n-linux
## A simple all-platform checkra1n installer
This script works on x86, x86\_64, ARM and ARM64! Why is this important? The default method of installing checkra1n is with a Debian repo. It should be simple, right?

Nope. The checkra1n official repo _only contains packages for x86_64_. Compared to all the devices that can run checkra1n, that's not that big of a percentage.

Not only can desktops run checkra1n, but so can ARM devices, like Android phones and tablets, as well as system-on-chip computers like the Raspberry Pi 4. But in order to get checkra1n, you have to visit the website, download the file, mark it as exectuable, move it to another folder, get the dependencies, and run it. This is made even harder if you don't have a GUI, since how can you view the website?

This script aims to fix that. It downloads every dependency needed, automatically finds the correct download link, and automatically installs it. It makes download it a 5-minute task to a 15-second task.

In addition to that, it features an automatic installer for the Procursus bootstrap. Procursus is faster and has more updated programs, and also features Sileo (in addition to Cydia). However, the install process involves quite a few steps, and this script simplifies it greatly.

If that wasn't enough, it will automatically update itself and checkra1n _every time it is run_. Not only is installing super easy, but so is updating!

Sold? Check it out at [the GitHub page](https://github.com/randomblock1/checkra1n-linux) and follow the install instructions.