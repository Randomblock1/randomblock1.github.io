---
title: "How to Quit GlobalProtect on macOS (without it relaunching itself)"
categories:
  - blog
tags:
  - MacOS
---

I installed Palo Alto GlobalProtect on my MacBook for easier access to my university's beefy Linux servers. But it opens itself every time I login, and my poor 8GB of RAM needs every byte it can get. I also just like having an uncluttered menu bar. But if you try to force quit it through Activity Monitor, it just relaunches itself! It's not even in the Login Items! That means it's time to go digging in the launch agents to figure out a solution... and after a few minutes, I found the fix.

Just open up `/Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist` and you'll see a line that says `<key>RunAtLoad</key>`. Below it, change `<true/>` to `<false/>`. Additionally, you'll need to replace the `<true/>` below `<key>KeepAlive</key>` with this (copied from the other GlobalProtect service):

```xml
<dict>
    <key>SuccessfulExit</key>
    <false/>
</dict>
```

You're done! The GlobalProtect app will no longer launch itself, and you can quit it without it relaunching itself. One thing to note is that GlobalProtect actually uses 2 services: PanGPA (the GUI app) and PanGPS (the backend service). If you want, you can disable PanGPS's RunAtLoad as well, but you'll have to start it with `launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangps.plist` every time you want to use GlobalProtect, since it will only start PanGPA.

If you want to quit either service from the terminal, you can run `launchctl unload <PATH TO PLIST>`, otherwise you can just use Activity Monitor (make sure it's set to All Processes in the View menu). They're listed as "PanGPS" and "GlobalProtect".

Now if you don't mind, I'm going to admire my newly-decluttered menu bar...
