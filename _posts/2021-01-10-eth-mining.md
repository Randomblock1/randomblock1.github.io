---
title: "Mining ETH with a GTX 1660 Super for Massive Profit"
categories:
  - blog
tags:
  - crypto
---
## Intro
Mining Ethereum is _very_ profitable right now. 1 ETH is worth about $1,000 right now, and it’s mainly mined by using GPUs or ASICs (purpose-built machines that can only do 1 thing, but they do that 1 thing blazing fast), or by simply having lots of ETH for staking in the “Beacon Chain” of Ethereum. You can’t currently withdraw Beacon Chain staked ETH, so mining with computing power is currently the only way.

GPUs are affordable and considerably fast for mining Ethereum. Sure, ASICs are faster, but bang-for-buck wise GPUs are pretty good and already widely available (and cheap). The new Nvidia RTX 3000 series cards (especially the 3060) are INCREDIBLE for mining, which is why they’ve been out of stock for a whole month.

I personally have a GTX 1660 SUPER, which is slow compared to the latest and greatest, but still very profitable if I decide to mine with it. Besides, I’m not using it all the time, so I may as well use it to mine when I’m not using it anyway.

For this, I’m going to use a custom OS for easy control and maximum efficiency. I will be using [Hive OS](https://hiveos.farm?ref=263127) since it’s super easy to use and monitor. It monitors everything, from hashrate to power usage to fan speed, and can be accessed from your phone. This is only worth it if you’re going to be mining a lot, like leaving it on overnight or all day.

## Setup

First, we need a graphics card (duh). If it’s reasonably newish and can run the latest games on Medium or better, it’s probably profitable to mine. I have a GTX 1660 SUPER, but Radeon cards are often preferred for mining. Just use the one already installed in your PC and plug in any spare ones you might have lying around. You’ll also need a USB drive with at least 8GB of storage to boot HiveOS.

Second, we need to create [a HiveOS account](https://hiveos.farm?ref=263127), which is needed to use HiveOS. Click that link and create an account (it’s 100% free for 1 computer, or free for 3 more if you mine on their pool, which is... _ok_.)

Once you’ve signed up, [click here](https://hiveos.farm/install/) and download the ISO image for GPUs. Meanwhile, go to your HiveOS dashboard and create a new worker. Enter whatever name and password you want. Then, click the link to download “rig.conf”.

Once the image is downloaded, use [Etcher](etcher.io) to write that image to a USB drive with 8GB or more capacity. When that’s done, you’ll see a new drive called HIVE in your file explorer. Copy over the previously-downloaded rig.conf to the HIVE drive. Also, if you’re using WiFi, make sure to edit the WiFi settings in the Network folder of HIVE. When you’re done, turn off your computer.

## Using HiveOS

Now, you’ll need to access a boot menu to boot directly into HiveOS or access your BIOS settings. You do this by hitting a key as you boot up. The key varies by motherboard, so just Google “[motherboard model] bios” or read your motherboard’s User Manual (if you have one).

If all goes well, you’ll see normal Linux bootup stuff, and a GUI will appear after a short while. At this point, you’ll need access to the web interface of HiveOS, so use your phone, another computer, or the preinstalled Firefox to open up your dashboard.

It’s a bit confusing at first, but you’ll eventually learn what everything does. First, you need to add a wallet. This is where all the crypto you mine will be credited to, so make sure you already have an Ethereum address ready to go. Click “Add Wallet” and fill in the coin name (Ethereum) and the address (looks like 0x1234567890...). Save it as a global wallet and enable fetching the balance.

Now, you’ll need to create a “Flight Sheet”. This is a profile that tells your computer what to mine, and how. Create a new Flight Sheet and enter Ethereum, your wallet, Etherpool, and whatever miner you want to use (I personally recommend T-Rex, it’s fast and feature filled). Enter a name if you want, and add the flight sheet. Finally, click the rocket next to the newly created flight sheet and apply it to your miner.

You should now hear your GPU start up and mine. Great job, you’re now up and mining! But it’s not the most efficient or fast it can be. The expensive part of mining is the electricity cost, so you want to be as efficient as possible. Enter: overclocking and power limits.

## The Overclocking Part

Every GPU can gain some extra speed by undergoing overclocking. It tells the GPU to  work harder than it normally would. This is great for us, because it allows you to get more performance, and therefore money, out of your GPU. But it’s not an exact science.

While every GPU can be overclocked, they can’t always be overclocked to the same degree. GPUs are not created equal, and some can be overclocked more than others.

However, with HiveOS, it’s super easy to overclock and get the most efficiency out of your GPU. First, in the Hive dashboard, go to your worker and select Overclocking. Then, edit the Default Config (or just the Ethash config if you will mine other cryptos).

For Ethash (the algorithm use to mine Ethereum), GPUs profit the most from a power limit and memory overclocking. Core overclocking has a minimal effect.

First, set a memory overclock. My GTX 1660 SUPER went up to 1300 while still being stable, but I’d recommend to start at 600 and increase by 200 until it becomes unstable, then reduce it by 100 until it’s stable again. Simply set an overclock, hit Apply, and wait 5 minutes to see if your miner crashes or has errors. If all is good, increase it until it crashes or errors, then decrease it until it’s all good again.

After you find a good memory overclock, set a power limit. The minimum varies, so you should run “nvidia-info” or “radeon-info” on your rig to get the minimum wattage. For me, it was 70W, so I set the limit to 75W. T-Rex will tell you the hashes per watt efficiency. Higher is better, so tweak it a bit until you’re happy. I got up to 400 kilo hashes per watt, which is WAY better than when it was not overclocked at around 250 kilo hashes per watt.

Once you’re all done with that, you can leave your miner be. I had mine turn off all the RGB stuff connected to it at startup, since I use it as a gaming computer.

You can monitor your miner with the HiveOS app, and see how much ETH has yet to be paid out through the Ethermine website. Ethermine will also give you a estimate of how much you can make every day, week, or month. It gives me an estimate of $2 every day or $60 every month.

Now, if I leave it for 3 months, it will give me about what I paid for it, including electricity, which is great! A 100% return on investment within 3 months, and that’s if Ethereum stays at $1000. If Ethereum goes up in value, mining gets even more profitable.