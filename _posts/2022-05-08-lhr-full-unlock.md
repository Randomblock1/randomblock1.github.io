---
title: "How to 100% Unlock LHR on Nvidia RTX GPUs (HiveOS)"
categories:
  - blog
tags:
  - Cryptocurrency
---

NOTE: this guide does not work if you have LHRv3 (3050 and 3080 12GB) but will work on LHRv1/2 cards. If you're not sure just try it, it will fall back to a partial bypass.
{: .notice--warning}

## Wait, what?

Yesterday, May 7, [NiceHash announced they have unlocked LHR cards](https://lnk2.page/ig5li) with their own QuickMiner software. While nobody except them knows how, it's very likely that [the NVIDIA Lapsus$ hack](https://lnk2.page/PGbRq) and [NVIDIA's leaked source code](https://lnk2.page/nvleak1) helped them reverse-engineer a bypass. They haven't said anything on the matter, but that's the most likely explanation.

However, the QuickMiner software is only available on Windows, and most miners prefer Linux because it is more stable, customizable, and better for overclocking. Today, [NBMiner released their LHR bypass](https://lnk2.page/iAt0b), and it is available for both [Windows](https://lnk2.page/7uUE8) and [Linux](https://lnk2.page/lhr).

## Install without HiveOS

Just visit the [NBMiner Download Page](http://lnk2.page/iAt0b) and download either a .tgz or .zip file, according to which OS you mine on. That's it.

## Install for HiveOS

Right now, there is no official HiveOS package. However, installing this directly for HiveOS is very simple.

First, run a flight sheet with NBMiner. Make sure it starts mining, then just run the following command:

```bash
curl -s https://randomblock1.com/assets/scripts/install-nbminer.sh | bash
```

It's that easy! You should now experience much higher hash rates and efficiency. This article will be updated as more mining tools gain LHR bypasses. Personally, my favorite is T-Rex miner, but I'm happy as long as I get higher hash rates.

## Results

Before I applied the NBMiner LHR bypass, I had approximately 30 MH/s on my RTX 3070. After the LHR bypass, it went up to 52 MH/s. And that was before overclocking. With a full overclock and the LHR bypass, I get 66 MH/s at 120 W. It's absolutely incredible.

## The Future

While this is great and all, Eth 2.0 is coming quite soon, and it will switch ETH from Proof of Work to Proof of Stake. So if you mine Ethereum for a living, I wouldn't go out and buy LHR cards. Unless you want to mine some other coin like Conflux, which is actually quite profitable (I mined this when I got a LHR card).
