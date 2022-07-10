---
title: "Mass Convert Videos with FFmpeg and PowerShell"
categories:
  - blog
tags:
  - Linux
---

FFmpeg is immensely powerful when it comes to modifying and transcoding videos, but it’s lacking one important feature: it can't handle multiple files at once! Luckily, we have scripts.

Let's say you have a bunch of videos in a folder and you want to convert them to a different format. You could do this manually, but that would be a pain. Instead, you can use a PowerShell script to do it for you.

There are many reasons you would want to do this, like encoding to AV1 to save space, converting to MP4 to make a video viewable on anything, and an innumerable amount of other use cases.

There are plenty of programs that can do this for you, like [HandBrake](https://handbrake.fr), but that doesn't support every codec, and it's not as customizable. PowerShell scripts are infinitely customizable, require mere kilobytes of space, and are as easy to install as copy-pasting, so I've decided to spend a little time learning PowerShell and create my own script. It lets you choose what codecs to use, the quality factor, video containers (extensions like mp4), and it works on Windows, MacOS, and Linux, as long as you have ffmpeg.

You need:

- [PowerShell](https://microsoft.com/PowerShell)
- [ffmpeg](https://ffmpeg.org)
- [ffpb](https://github.com/althonos/ffpb) (optional)

Here's the script I made:
<!-- markdownlint-disable-next-line MD033 -->
<script src="https://gist.github.com/Randomblock1/3c5c449608840939180baaf604f3f456.js"></script>

See that "View Raw" button? Right click it and select "Save Link As". Once you open up PowerShell, you can easily run the script.

Here's the usage information I've provided with the `Get-Help` command:

```powershell
NAME
    MassFFmpegConvert.ps1

SYNOPSIS
    Transcode all files in a folder recursively with a given file extension.


SYNTAX
    MassFFmpegConvert.ps1 [-path] <String> [[-inputExtension] <String>] [[-outputExtension] <String>] [[-videoCodec]
    <String>] [[-crf] <String>] [[-audioCodec] <String>] [-notRecursive] [-dryRun] [<CommonParameters>]


DESCRIPTION
    Transcode all files in a folder recursively with a given file extension.
    Prints the name of each file it transcodes.
    Uses ffpb to display a progress bar if possible.


PARAMETERS
    -path <String>
        Required. Specifies the folder path to recursively search for files.

    -inputExtension <String>
        Specifies the extension. "mp4" is the default.

    -outputExtension <String>
        Specifies the extension. "mkv" is the default.

    -videoCodec <String>
        Specifies the video codec. "libsvtav1" is the default.

    -crf <String>
        Specifies the constant rate factor. "30" is the default.

    -audioCodec <String>
        Specifies the audio codec. "copy" is the default.

    -notRecursive [<SwitchParameter>]
        Specifies if it should scan recursively for files. "false" is the default.

    -dryRun [<SwitchParameter>]
        Specifies if it should perform a dry run. "false" is the default.

    -------------------------- EXAMPLE 1 --------------------------

    PS>MassFFMpegConvert -path .\Videos
    Transcoding mp4 to mkv with c:v libsvtav1, CRF 30, c:a copy
    Transcoding .\Videos\test.mp4
    test.mp4: 100%|#############| 600/600 [00:05<00:00, 120.0 frames/s]
    Done! ✅






    -------------------------- EXAMPLE 2 --------------------------

    PS>MassFFMpegConvert -path .\Videos -inputExtension webm -outputExtension mp4 -videoCodec libx264 -crf 20 -audioCodec aac
    Transcoding webm to mp4 with c:v libx264, CRF 20, c:a aac
    Transcoding .\Videos\test.webm
    test.webm: 100%|#############| 600/600 [00:05<00:00, 120.0 frames/s]
    Done! ✅






    -------------------------- EXAMPLE 3 --------------------------

    PS>MassFFMpegConvert -path .\Videos -dryRun
    Transcoding mp4 to mkv with c:v libsvtav1, CRF 30, c:a copy
    Transcoding .\Videos\test.mp4
    Done! ✅

    # Notice how nothing is actually transcoded. It's just a dry run.
    



REMARKS
    To see the examples, type: "Get-Help MassFFmpegConvert.ps1 -Examples"
    For more information, type: "Get-Help MassFFmpegConvert.ps1 -Detailed"
    For technical information, type: "Get-Help MassFFmpegConvert.ps1 -Full"
```

To view it again, just run `Get-Help MassFFmpegConvert.ps1`.

This script should be flexible enough for most situations, but feel free to fork the script to suit your needs. I would appreciate a follow or star if this script helped you.
