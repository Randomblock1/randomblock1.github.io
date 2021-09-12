---
title: "Making Discord 2x Faster And Efficient On M1 Macs"
categories:
  - blog
tags:
  - MacOS
---
Discord is an Electron app. Electron apps are super portable and can run on every platform without having to change any code. However, Discord's MacOS app doesn't support ARM64 (Apple M1) CPUs natively, which means it has to go through Apple's Rosetta 2, which allows x86_64 applications to run on ARM64 processors.

This introduces some graphical bugs and massively slows down the application, which makes it less responsive and use more battery than it should. Discord has neglected to create a ARM64 version of their app even after 6 months of M1 users asking for it, and probably won't do it for the forseeable future.

This means we have to take the problem into our own hands. Luckily, there's already a tool for making Electron apps from webpages, and it just so happens that Discord has a fully-functioning web app...

Enter [Nativefier](https://github.com/nativefier/nativefier). Nativefier creates an Electron app from a webpage, which is already amazing, but it also allows us to inject our own code! This will allow us to imitate pretty much all features in the actual MacOS version and add them to our web version.

Time to get started. You will need:

- M1 Mac (otherwise just use the normal Discord app)
- [Homebrew](https://brew.sh)
- [This Discord icon](https://media.macosicons.com/parse/files/macOSicons/8bd2d46228e7ecc74e67901948a8df93_Discord.icns) and save it as 'discord.icns'
- [The discord.js script](https://gist.github.com/Randomblock1/b8cd3948ce0b4688b874f2643a2a6941)

1. Open up a terminal

2. `cd` to where you downloaded the icon and discord.js (probably `~/Downloads`)

3. Install Nativefier
  `brew install nativefier`

4. Run the following command:

    ```bash
    nativefier \
    --background-color '#23272A' \
    --browserwindow-options '{ "fullscreenable": "true", "simpleFullscreen": "false" }' \
    --counter \
    --darwin-dark-mode-support \
    --enable-es3-apis \
    --icon discord.icns \
    --inject discord.js \
    --title-bar-style hiddenInset \
    https://discord.com/app
    ```

5. Move Discord-darwin-arm64/Discord.app into your /Applications folder

6. Run it!

Everything should work just like the desktop app, while being about 2 times faster. Notifications? Turn them on in the settings. Voice chat? Works great. Unfortunately, game statuses won't work, but you can update your status manually.

One thing to note, though; sometimes the Discord web app will update itself and break read functionality (specifically, it won't mark a channel as 'read' when you scroll to the very bottom). This can be fixed by simply running Nativefier again and installing the newly generated app.
