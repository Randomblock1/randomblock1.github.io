---
title: "Build Your Own 1Gbps Wireguard VPN + AdBlock for $1/month"
categories:
  - blog
tags:
  - Linux
---

So you want an ultra-cheap VPN service, huh?

Whether it's unblocking websites or securing a public hotspot, it's only $1/month!

Why not build it yourself? The only person you can trust is yourself, after all. And, of course, you want to use Wireguard because it's just that good, and add built-in adblocking for good measure. But not only is it $1/month, it has 1 Gbps bandwidth! That's faster than my own Internet, so it sounds like a great deal to me!

## Summary
Here's a quick rundown of what we're gonna do:
- Purchase a VPS for $1/month
- Set up WireGuard
- Set up Docker + PiHole for built-in adblocking
- Set up Uncomplicated Firewall (UFW) to prevent unauthorized access

## Get the server
Okay, first things first. We need the server. 
You have 2 options:

First option: if you will use less than 3TB of bandwidth monthly and want to use your VPS for literally anything else (like a website), RackNerd sells 1GB RAM servers with 3TB 1Gbps monthly bandwidth for $1/month. I have no clue how that can possibly be profitable, but I digress. Go to the [RackNerd](https://my.racknerd.com/cart.php?a=add&pid=358) site to purchase it.

Second option: 3TB of data should be more than enough for most people, but if you absolutely _need_ more data (and are willing to sacrifice lots of RAM and therefore possibly make your adblocker slower) you can order a VPS from [CatalystHost](https://portal.catalysthost.com/cart.php?a=add&pid=174) instead. It has barely enough RAM for the adblocker, but it should still work.

Go ahead and purchase one of those virtual servers, and select Debian as your operating system if you can. This tutorial is designed for Debian, but it should work with other OSes too.

Now, connect to your server via SSH and enter these commands. All of them should be executed as root, use `sudo su` if you're not logged in as root.
```
apt update && apt upgrade -y
```
This will update the system kernel to one that should include WireGuard support built-in. Now, reboot the VPS with `shutdown -r now`.  We're running a shiny new kernel with WireGuard support in it now, so install WireGuard with `apt install wireguard`.

## Set up WireGuard
Now that we have WireGuard installed, it's time to actually set it up as a server and let your devices connect to it.
`wget https://git.io/wireguard -O wireguard-install.sh && bash wireguard-install.sh`
Follow the instructions; scan the QR code with your phone or use `scp` to transfer the configuration files over SSH. At this point, if all you wanted was a cheap VPN with no frills, you're done! Every time you want to add a device, just rerun the script. You can set up other VPN protocols if you want, too!

## Set up PiHole
OK, great, we have a VPN. But what about that ad blocking? Ads blocked on every website, every app... sounds perfect! But how do we do it?

First step is to install Docker. Just follow [the official Docker install instructions](https://docs.docker.com/engine/install/debian/) and you'll be ready in no time. Make sure to also run `curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
` to install Docker Compose. Create a folder for PiHole to store all its data with `mkdir ~/pihole && cd ~/pihole`.  Use `nano` or your favorite text editor (obviously also nano) to create `docker-compose.yml` with the following text:
```
version: "3"

# More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "80:80/tcp"
    environment:
      TZ: 'America/Chicago'
      WEBPASSWORD: 'very_secure_password'
    # Volumes store your data between container upgrades
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    # Recommended but not required (DHCP needs NET_ADMIN)
    #   https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
```
Make sure to set WEBPASSWORD to your own secure password, then save the file with CTRL-X.

Alright; moment of truth. `docker-compose up -d`. If all goes well, you can navigate to `10.66.66.1` in your browser to access the PiHole web UI when you're connected to WireGuard, or just via the normal IP address of your VPS. Wait... anyone can see it with just the IP??? Yes, anyone on the internet can access it! That's bad!

## Secure it
Install the Uncomplicated Firewall with `apt install ufw`. It's now time to set up firewall rules so only WireGuard users can use the PiHole VPN, and some random person on the internet can't.

First up: in case it goes horribly wrong, SSH access is a must, since we don't have physical access. `ufw allow ssh` should do the trick.
Next: WireGuard users should have access to everything. `ufw allow from 10.66.66.0/24` will do just that. Also make sure to allow access to your WireGuard port from the Internet, otherwise this is all pointless! `ufw allow [wireguard port]` will let you connect to the VPN with your configuration file.
Our PiHole Docker container needs a little workaround to let only WireGuard users use it, since Docker likes to ignore firewalls.
```
wget -O /usr/local/bin/ufw-docker https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
chmod +x /usr/local/bin/ufw-docker
ufw-docker install
systemctl restart ufw
ufw enable
```

## PiHole Configuration
Voila! If you navigate to 10.66.66.1 while connected to the VPN, you should be able to access the PiHole web interface! One last step: in Settings/DNS, you need to set interface behavior to "**Listen on all interfaces, permit all origins**", since WireGuard is more than 1 hop away and PiHole will deny DNS access otherwise. You should also install another blocklist, like [OISD](oisd.nl/downloads) into PiHole to block more ads, and edit your WireGuard configuration file to use 10.66.66.1 as the primary DNS (and a normal DNS like 1.1.1.1 as a backup.) That's it! Any time you want to add another device, rerun the Wireguard script.

## Conclusion
That's it! $1/month for a VPS with adblocking built-in! Of course, you can also install other VPN protocols if you want to, and use anything else in a Docker container like a Nginx web server, or Gitea self-hosted Git.
