---
title: "Installing XNU Headers on MacOS 13"
categories:
  - blog
tags:
  - MacOS
---

Sometimes, you need certain header files that aren't available with the default MacOS toolchain. For example, I'm building a replacement for `caffeinate` which completely disables sleep while the laptop lid is closed, so my stuff can keep compiling, rendering, and etc. while it's in my backpack. But it needs a header that I found hidden deep within the depths of the MacOS kernel source code, AKA XNU.

Simply downloading XNU and trying to copy over the headers doesn't work, because you need extra tools, which you have to build yourself. (It's not available on Homebrew, unfortunately.)

Anyway, if you're still reading this, it means you *really* want those headers, so let's just skip the rest of the context and get to getting those headers.

1. Download the latest Xcode. I use [this Ruby script](https://gist.github.com/iandundas/fabe07455e5216442a421922361f698c?permalink_comment_id=3721309#gistcomment-3721309) to download Xcode much faster than using the App Store, but you can also use [a GUI](https://github.com/vineetchoudhary/Downloader-for-Apple-Developers/) and [a command](https://github.com/RobotsAndPencils/xcodes). You *could* use the App Store... but that's boring!
2. Download the source code you need
    1. `wget https://github.com/apple-oss-distributions/dtrace/archive/refs/tags/dtrace-388.tar.gz`
    2. `wget https://github.com/apple-oss-distributions/AvailabilityVersions/archive/refs/tags/AvailabilityVersions-112.tar.gz`
    3. `wget https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8792.61.2.tar.gz`
3. Build & install dtrace tools
    1. `tar zxf dtrace-388.tar.gz`
    2. `cd dtrace-dtrace-388`
    3. `xcodebuild install -sdk macosx -target ctfconvert -target ctfdump -target ctfmerge ARCHS='x86_64 arm64' CODE_SIGNING_ALLOWED=NO VALID_ARCHS='x86_64 arm64' DSTROOT=$PWD/dst`
    4. `sudo ditto "dst/usr/local/" "$(xcrun -sdk macosx -show-sdk-platform-path)/../../Toolchains/XcodeDefault.xctoolchain/"`
    5. `cd ..`
4. Build & install AvailabilityVersions
    1. `tar zxf AvailabilityVersions-112.tar.gz`
    2. `cd AvailabilityVersions-AvailabilityVersions-112`
    3. `make install`
    4. `sudo ditto dst/usr/local/libexec "$(xcrun -sdk macosx -show-sdk-path)/usr/local/libexec"`
5. Install the headers!
    1. `tar zxf xnu-8792.61.2.tar.gz`
    2. `cd xnu-xnu-8792.61.2`
    3. `make SDKROOT=macosx ARCH_CONFIGS="X86_64 ARM64" installhdrs`
    4. `sudo ditto BUILD/dst "$(xcrun -sdk macosx -show-sdk-path)"`

Once you're done, you'll have access to the header files you need from the XNU kernel. While I wish the headers would just be included by default, installing them manually isn't that bad. Once you've installed the tools & scripts, you only need to download XNU again to update the headers, there shouldn't be any need to reinstall the tools again. Now just point your build tools at the headers and compile to your heart's content!
