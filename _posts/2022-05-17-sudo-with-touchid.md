---
title: "Use Sudo with Touch ID"
categories:
  - blog
tags:
  - MacOS
---

If you have a MacBook with Touch ID, you can skip typing your password into sudo by using Touch ID! It's much faster and potentially more secure. It's also surprisingly easy, and you can do it by adding one line to a file.

We can tell PAM (the authentication agent) that it is allowed to use Touch ID as a substitute for a password when using sudo by editing `/etc/pam.d/sudo`.

Open up your terminal and type this:

`sudo nano /etc/pam.d/sudo`

Nano will open up the file so we can edit it. Then, at the top of the file (above or below the comment, doesn't matter), paste this line:

`auth sufficient pam_tid.so`

Press CTRL+X, Y, and then Enter to confirm our changes and write to the file. The next time you use `sudo`, it will ask for you to use Touch ID instead of your password!

Here's it explained for you in a simple diagram:

```text
  ┌──► use this for authentication
  │
  │       ┌──► optional, but enough on its own
  │       │
  │       │          ┌──► load the TouchID module
  │       │          │
┌─┴──┬────┴─────┬────┴─────┐
│auth│sufficient│pam_tid.so│
└────┴──────────┴──────────┘
```

Note that this will not ask you for your Touch ID when you SSH into your MacBook, because that wouldn't make any sense. You will still have to enter your password then.
