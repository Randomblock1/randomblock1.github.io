---
title: "Speeding up Gemini CLI 2x with Bun"
categories:
  - blog
tags:
  - Linux
  - Windows
  - AI
---

## 2X Performance With One Line

The Gemini CLI is a powerful tool for interacting with Gemini AI models, but one of my biggest peeves with it is its slow startup time. It takes about 10 seconds to start up on my laptop in efficiency mode but that's still quite a lot for a CLI tool. Sure, it has a TUI, but at that point I might as well just use an IDE or web interface. Of course the CLI has its advantages, like sandboxing and MCP, but the slow startup time is a real hindrance to productivity.

Bun is a new JavaScript runtime that is designed to be fast and efficient. It has a number of features that make it well-suited for CLI tools, like:

- Fast startup time
- Built-in package manager
- Native TypeScript support
- Highly performant

It's capable of running most Node.js code with minimal or no modifications, making it a great candidate for speeding up the Gemini CLI. In fact, I was able to get the Gemini CLI running on Bun quite easily. Bun doesn't yet allow running globally installed programs with the Bun runtime normally, but eventually, it should work out of the box (see <https://github.com/oven-sh/bun/issues/9346>). For now, here are the steps I took to get it working by manually patching files:

- Install Bun: Follow the instructions on the [Bun website](https://bun.sh/) to install Bun on your system.
- Install Gemini CLI: `bun install -g @google/gemini-cli`
- Set Bun as the runtime
  - On Linux or MacOS, edit `~/.bun/bin/gemini` and change the shebang line to `#!/usr/bin/env bun`
  - On Windows, it's... complicated. You'll see. Keep reading.

On my laptop in efficiency mode (the CPU doesn't boost as much to save battery), this makes the Gemini CLI go from about 11 seconds to completely load (including MCP servers) to just over 5 seconds. In performance mode, it goes from just over 5 seconds to 3 seconds. That's a significant improvement! And it feels much snappier, and updates are faster. There's literally no reason to not do it.

Due to the way Bun caches code, this change should persist as long as the Gemini CLI's `index.js` file doesn't change. And even if it does, it is just one line to change back.

## Act 2: Actually, It's Broken (Not My Fault Though)

Speaking of updates, this is where I ran into an issue. You see, the Gemini CLI has an auto-update mechanism that will automatically update itself using whatever package manager you used. So if you used npm, it will run `npm install -g @google/gemini-cli` to update itself. If you used yarn, it will run `yarn global add @google/gemini-cli`. And if you used bun, it will run `bun install -g @google/gemini-cli`. Et cetera.

At least, that's what it should have done. In the code, it checks to see if the current executable's path contains `/.bun/bin`. Unsuprisingly, that's where the Gemini CLI executable is installed, right at `~/.bun/bin/gemini`. You'd think that would work, right?

As it turns out, on Linux, that's a symlink to `~/.bun/install/global/node_modules/@google/gemini-cli/dist/index.js`. So the check fails, and the Gemini CLI thinks it was installed with npm, and tries to run `npm install -g @google/gemini-cli` to update itself. How annoying!

I quickly took a look at the code and [fixed it](https://github.com/google-gemini/gemini-cli/pull/12690), but it hasn't been merged yet so that'll just be a minor annoyance until then.

<br><br><br><br><br>

...

<br><br><br><br><br>

_wait why does the article keep going?_

<br><br><br><br><br>

## Act 3: Windows Woes, or, Parsing Data for No Good Reason

Recall that, on Linux, there's a symlink from `~/.bun/bin/gemini` to the actual executable. The shebang line is changed to use Bun, and everything works fine.

Windows, however, does not have symlinks in the same way. Additionally, PowerShell and the command line do not use shebangs. To deal with this, Bun creates a `gemini.exe` and `gemini.bunx` file in `~/.bun/bin/`. The `.exe` file is a small binary shim that parses the `.bunx` file, presumably pointing to the file to run and the runtime to use, effectively simulating a shebang on Windows.

Opening the `.bunx` file is relatively reassuring as it seems to be some UTF-16LE strings and a little extra hex data. I can see "node" in there so really all I have to do is change that to "bun" right?

```text
┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
│00000000│ 69 00 6e 00 73 00 74 00 ┊ 61 00 6c 00 6c 00 5c 00 │i n s t ┊a l l \ │
│00000010│ 67 00 6c 00 6f 00 62 00 ┊ 61 00 6c 00 5c 00 6e 00 │g l o b ┊a l \ n │
│00000020│ 6f 00 64 00 65 00 5f 00 ┊ 6d 00 6f 00 64 00 75 00 │o d e _ ┊m o d u │
│00000030│ 6c 00 65 00 73 00 5c 00 ┊ 40 00 67 00 6f 00 6f 00 │l e s \ ┊@ g o o │
│00000040│ 67 00 6c 00 65 00 5c 00 ┊ 67 00 65 00 6d 00 69 00 │g l e \ ┊g e m i │
│00000050│ 6e 00 69 00 2d 00 63 00 ┊ 6c 00 69 00 5c 00 64 00 │n i - c ┊l i \ d │
│00000060│ 69 00 73 00 74 00 5c 00 ┊ 69 00 6e 00 64 00 65 00 │i s t \ ┊i n d e │
│00000070│ 78 00 2e 00 6a 00 73 00 ┊ 22 00 00 00 6e 00 6f 00 │x . j s ┊"   n o │
│00000080│ 64 00 65 00 20 00 78 00 ┊ 00 00 0a 00 00 00 37 ab │d e   x ┊  _   7×│
└────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
```

WRONG! There's some validation that goes on to make sure that this file doesn't get corrupted. Replacing "node" with "bun" would change the length of the string from 4 characters to 3 characters, which would break the validation. And the data at the end isn't just the string length. Bun recognizes this and immediately complains of corrupted data. I guess I could pad it with a space or something, but that feels risky.

So it's time to create a script to parse and modify these `.bunx` files. It's a good thing the entire thing is open source.

After a quick chat with some AI, feeding it the source code responsible for parsing these files, a [working script](https://gist.github.com/Randomblock1/c3476d59e660de7ec849f9041079199a) was created. Simply run `bun run bunx-util.ts patch-shebang ~/.bun/bin/gemini.bunx` in Powershell, and it will patch the shebang to use Bun instead of Node.js, backing up the original in the process. Now the Gemini CLI runs on Bun on Windows as well! It sped up from 6 seconds to 3.

I don't even use Windows for coding so there was really no good reason for me to go through all this trouble, but hey, now it works!

## Conclusion

If you're using the Gemini CLI and are frustrated with its slow startup time, I highly recommend switching to Bun as the runtime. With just a one-line change (or a small script on Windows), you can significantly speed up your workflow. Hopefully, in the future, Bun will support being the runtime for global executables out of the box.
