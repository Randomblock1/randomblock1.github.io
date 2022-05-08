---
title: "How to 100% Unlock LHR on Nvidia RTX GPUs (HiveOS)"
categories:
  - blog
tags:
  - Cryptocurrency
---

You heard that right. You can nearly double your hashrate with minimal effort, and increase efficiency. Just download a miner, it's that easy. haha gpu go brrrr

NOTE: this guide does not work if you have LHRv3 (3050 and 3080 12GB) GPUs but will work on LHRv1/2 cards. Chances are, your card is compatible.
{: .notice--warning}

## Wait, what?

Yesterday, May 7, [NiceHash announced they have unlocked LHR cards](https://lnk2.page/ig5li) with their own QuickMiner software. While nobody except them knows how, it's very likely that [the NVIDIA Lapsus$ hack](https://lnk2.page/PGbRq) and [NVIDIA's leaked source code](https://lnk2.page/nvleak1) helped them reverse-engineer a bypass. They haven't said anything on the matter, but that's the most likely explanation.

However, the QuickMiner software is only available on Windows, and most miners prefer Linux because it is more stable, customizable, and better for overclocking. Today, [NBMiner released their LHR bypass](https://lnk2.page/iAt0b), and it is available for both [Windows](https://lnk2.page/7uUE8) and [Linux](https://lnk2.page/lhr).

## Install without HiveOS

Just visit the [NBMiner Download Page](http://lnk2.page/iAt0b) and download either a .tgz or .zip file, according to which OS you mine on. That's it.

## Install for HiveOS

Right now, there is no official HiveOS package. However, installing this directly for HiveOS is very simple.

First, update your Nvidia drivers. You can [visit the website](https://www.nvidia.com/Download/driverResults.aspx/187526/en-us) or run `nvidia-driver-update`. Downloading from NVIDIA is much faster, so I recommend that. Then just run `nvidia-driver-update DRIVER_YOU_DOWNLOADED.run`, and HiveOS will take care of the rest.

Once you're all done with that, log into your web interface and create and run a flight sheet configured with NBMiner. Make sure it starts mining, then just run the following command:

```bash
curl -s https://randomblock1.com/assets/scripts/install-nbminer.sh | bash
```

It will download NBMiner 41 (the version with the full LHR bypass) and replace your old miner version with this new one. It will also restart your miner for you.

It's that easy! You should now experience much higher hash rates and efficiency. This article will be updated as more mining tools gain LHR bypasses. Personally, my favorite is T-Rex miner, but I'm happy as long as I get higher hash rates.

## Results

Before I applied the NBMiner LHR bypass, I had approximately 30 MH/s on my RTX 3070. After the LHR bypass, it went up to 52 MH/s, and that was all before applying any overclocking. With a full overclock (1200/3700/120 core/memory/power) and the LHR bypass, I got 64 MH/s at 120 W with an efficiency of 550 kH/w. It's absolutely incredible.

## The Future

While this is great and all, Eth 2.0 is coming quite soon, and it will switch ETH from Proof of Work to Proof of Stake. So if you mine Ethereum for a living, I wouldn't go out and buy LHR cards. Unless you want to mine some other coin like Conflux, which is actually quite profitable (I mined this when I got a LHR card).

Additionally, as more people download and use the LHR bypass, the [ETH Network difficulty](https://2miners.com/eth-network-difficulty) will probably increase, meaning you'll earn less per hash. That shouldn't be too much of a concern, though, because more hashes still means more shares.
