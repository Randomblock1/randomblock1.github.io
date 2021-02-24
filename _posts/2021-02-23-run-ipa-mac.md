---
title: "How to install ANY iPhone App (Even Non-Appstore) on M1 Macs"
categories:
  - blog
tags:
  - MacOS
---
IPA files contain iPhone apps. Some of them are from the App Store, which Macs can install by simply double-clicking. But what if you want to install an app you compiled using Xcode yourself, or an IPA you download off the Internet? Previously, there was no way to do this, but I've figured out a workaround to run any IPA file on a M1 Mac. And I mean ANY app. Especially the Non-Appstore ones.

Prerequisites:
  - M1 Mac
  - An IPA file you want to install (not from the App Store)
  - 5 mins of time

Note: if your app is downloadable from the App Store, just use [the iMazing method](https://www.theverge.com/2020/11/18/21574207/how-to-install-run-any-iphone-ipad-app-m1-mac) instead. It is a LOT easier, you just double-click a file and go. This is meant to be use for IPA files that are NOT obtainable on the App Store.

1. Download a wrapper
  The way MacOS runs iPhone apps is by downloading the app from the Appstore and manipulating its metadata into something MacOS can read. It does this by installing a "wrapper" for iOS apps. We will need a wrapper to run our app, too. The first thing you need to do is download an iOS AppStore app. You'll need this to generate the wrapper, but it can be uninstalled after we're done. I'm using a podcast app called Overcast, but most other iPhone apps will work. Enter the macOS App Store, and search for your app. Make sure to select "iPhone and iPad apps" instead of "macOS apps", as we need an iOS app to use as our wrapper. Simply download it and proceed to step 2.

2. Copy the wrapper
  Open the Terminal application. Type ```cd /Applications/``` and then ```cp -R [the app you just downloaded].app ~/Documents```. DON'T DO THIS VIA FINDER, it will mess up the wrapper.

3. Sign your IPA
  Use [iOS App Signer](https://dantheman827.github.io/ios-app-signer/) to resign the IPA file you plan to install. This is essential! If you compiled an iPA with Xcode, you can skip this step, as it is already signed.

4. Prepare your IPA
  Then, ```cd``` to wherever your downloaded your IPA file, and unzip it with ```unzip YOURIPA.ipa```. Using Finder, copy the app inside the Payload folder into our wrapper in ~/Documents.

5. Modify the wrapper
  Right-click the wrapper we copied into Documents and select "Show Package Contents." Delete WrappedBundle, and move into Wrapper. Copy the app extracted from the IPA into this folder, and delete the original app that was in there. Do not delete the plist files. Leave BundleMetadata.plist alone, as we don't need to change it. Modify iTunesMetadata.plist, replacing the softwareVersionBundleId, bundleShortVersionString, itemName, and artistName with the proper information that can be found in your app's Info.plist (again, use Show Package Contents). While changing these are all recommended, the only one you REALLY need to change is itemName and bundleShortVersionString.

6. Fix the wrapper
  Remember how we deleted WrappedBundle? Well, we actually do need that to run, but we couldn't use the one already made. It's a simple fix though. Open Terminal and ```cd``` into the first wrapper folder (~/Documents/WrapperApp.app). Run ```ln -S Wrapper/YourIOSApp.app WrappedBundle```.

7. Install the wrapper
  Finally, we're done! Rename the wrapper app in your Documents folder to the name of the app you're installing, and run it! You can copy it into your /Applications folder if you want it to live in the Launchpad.

8. Approve your app
  When you run your app, macOS will complain about not trusting you. Open System Preferences, select "Security and Privacy", and click "Open Anyway" next to the text saying "x was blocked from use". Select "always trust this developer" (since it's you) and click "Open", and you're done! The app will now run like it's on iOS!

In the future, I will create a script to do all this for you, automatically. For now though, you'll have to do it all by hand. There is a limit to how many apps an Apple account can make; if you run into that problem, create a new Apple ID and use it for signing. One more thing: I think you might have to resign the app file like you do if you want to sideload an app on iOS, but I've just discovered this today, so I'm not sure. If you have a Developer Account, it will last a year. But who knows, maybe it won't need to be resigned? Either way, occasional resigning is nothing, compared to having any app installed on a Mac.
