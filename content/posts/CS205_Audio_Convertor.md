---
title: CS205 C/C++ Project Audio Convertor
tags: C/C++
categories: CS
description: Project description for CS205 C/C++ Program Design, SUSTech, 2023 Fall.
date:
---

Designer: [Artanisax](https://github.com/Artanisax) and [Gu Tao](https://github.com/GuTaoZi).

## Overview

In this project, you need to implement a library in C/C++ that supports encoding conversion from .pcm raw audio files to `.wav` files and then to simple `.flac` files, as well as decoding wav and flac format files. Also you need to implement a **Command Line Interface (CLI)** to demonstrate your project.

## Audio Formats

### [PCM](https://en.wikipedia.org/wiki/Pulse-code_modulation)

A [raw audio file](https://en.wikipedia.org/wiki/Raw_audio_format) is any file containing un-containerized and uncompressed audio. The data is stored as **raw pulse-code modulation (PCM)** values **without any metadata header information** (such as sampling rate, bit depth, endian, or number of channels).

### [WAV](https://en.wikipedia.org/wiki/WAV)

WAV, known for WAVE (Waveform Audio File Format), is a subset of Microsoft’s Resource Interchange File Format (RIFF) specification for storing digital audio files. The format doesn’t apply any compression to the bitstream and stores the audio recordings with different sampling rates and bitrates. This format is of **little-endian**!

```
                           RIFF Header                         
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
| 0                          15 | 16                       31 |
|=============================================================|
|                    RIFF header identifier                   |
|-------------------------------------------------------------|
|                          Total Size                         |
|-------------------------------------------------------------|
|                          File type                          |
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

                          Format Chunk                         
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
| 0                          15 | 16                       31 |
|=============================================================|
|                    Format chunk identifier                  |
|-------------------------------------------------------------|
|                         Chunk Size                          |
|-------------------------------------------------------------|
|         audio format         |      number of channels      |
|-------------------------------------------------------------|
|                         Sample Rate                         |
|-------------------------------------------------------------|
|                          Byte Rate                          |
|-------------------------------------------------------------|
|          Block Align         |        Bits Per Sample       | 
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

                           Data Chunk                          
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
| 0                          15 | 16                       31 |
|=============================================================|
|                     Data chunk identifier                   |
|-------------------------------------------------------------|
|                          Data Size                          |
|-------------------------------------------------------------|
|                         Sample Data                         |  
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
```

### [FLAC](https://en.wikipedia.org/wiki/FLAC)

**FLAC** stands for **Free Lossless Audio Codec**, an audio format similar to MP3, but lossless, meaning that audio is compressed in FLAC without any loss in quality.

FLAC stands out as the fastest and most widely supported lossless audio codec, and the only one that at once is non-proprietary, is unencumbered by patents, has an open-source reference implementation, has a well documented format and API, and has several other independent implementations. This format is of **big-endian**!

More information like the FLAC format specification can be found on the [official documentation of FLAC](https://xiph.org/flac/documentation.html).

## Requirements

The tasks below are listed in ascending order of difficulty to implement, and we recommend that you implement them in this order.

### Metadata Display & Edit (15 pts)

In this part, you need to impement an executable file to display and edit the metadata of FLAC files. Given a `.flac` file, your program should be able to decode and display the information of metadata blocks of **type 0 (STREAMINFO)** and **type 4 (VORBIS_COMMENT)**.

A `.flac` file is given as the official testcase for this task.

### Encoder: RAW → WAV → FLAC (30 pts)

In this part, you need to implement a convertor from `.raw` to `.wav` (10 pts), and then to `.flac` (20 pts).

The first subtask is to convert a raw audio file to a `.wav` file. Since the raw audio file does not contain information like sample rate, bits per sample (depth), number of channel etc., when converting `.raw` to `.wav`, an additional JSON file is needed to provide extra information for the header. In official test cases, a `.json` file is given along with each `.raw` file.

The second subtask is to convert a `.wav` file into a `.flac` file. For basic requirement, the depth will only be **16Bit int** or **24Bit int**, and you only need to encode every subblock into a subframe using **[verbatim predictor](https://xiph.org/flac/format.html#subframe_verbatim)** with channel assignment of **[2 channels: left](https://xiph.org/flac/format.html#frame_header)**, with **[STREAMINFO](https://xiph.org/flac/format.html#metadata_block_streaminfo)** and **[VORBIS_COMMENT](https://xiph.org/flac/format.html#metadata_block_vorbis_comment)** metadata.

An important evaluation metric in this task is whether the audio files converted by your library can be played with commonly used media players.

A `.raw` file with `.json` is given as the official testcase for this task.

### Decoder: FLAC → WAV → RAW (30 pts)

For the third task, you are required to implement a decoder for your library, to convert a `.flac` file into `.wav` format (20 pts), and then to `.raw` format (10 pts).

Same as above, you only need to handle simple `.flac` files with **STREAMINFO** and **VORBIS_COMMENT** metadata and **verbatim subframes**.

You can choose the `.flac` file generated in the second task as the input (testcase) for this task, and check if the `.wav` and `.raw` files are the same as the input ones of the encoder.

No official testcase is given for this task.

### Possible Bonus Ideas ($\infty$ pts)

Here we offer some ideas about the possible bonus functions, with estimated difficulties. You are also encouraged to explore your own bonus ideas.

The tasks below are listed in ascending order of difficulty to implement.

- 😊 **Excellent Project Management:**
  How to manage a project during development can be very easy, or very hard. Try to manage your project structure well, keep a changelog for revision control, write a user-friendly document, cooperate via GitHub, GitLab, Gitee, ...
  
  This should have been a basic requirement, but we set it as bonus to encourage you to learn how to manage a cooperating project well, which is an important skill that you can benefit from in future project development.
  
  > Stop using QQ/Wechat to synchronize your project!
  > That's too brutal!

- 😊 **More Metadata Block Types:**
  Support (analyze, display and edit) additional metadata block types, like PADDING, SEEKTABLE, PICTURE etc.

  - If a **COMMENT** block is followed by a **PADDING** block, the additional comments to be appended should overwright part of the **PADDING** block first rather than insert directly.

  - If an existing **SEEKTABLE** block (one .flac file has atmost one **SEEKTABLE** block) has placeholder seekpoints, the added ones are supposed to replace the placeholders. And if it's followed by a **PADDING** block, do the same as the direction above.

- 😊 **Extreme Robustness:**
  Although robustness is one of the basic requirements to obtain basic points, you can get bonus points if your library is excellent in terms of exception handling and memory management!
  
  MD5 signiture and CRC check should also be covered in your decoder for this bonus.
  
  However, to get this bonus part, you need to rethink what kind of robustness can be qualified as **"extreme"**.
  
  > Oops! Why segmentation fault again!

- 🤔 **Interchannel Decorrelation**
  Though the basic requirement for channel assignment is to store the left channel and the right channel seperately, there are more ways to deal with 2-channel audios, which can be helpful for compression. So try to support at least one of these [speciall stereo assignments](https://xiph.org/flac/format.html#interchannel) (from $1000$ to $1010$) with your convertor.
  - To implement this function, you may need to modify both the encoder and decoder, to adapt to different channel assignment.

- 🤔 **More Subframe Types**
  Support additional subblock encoding patterns like **SUBFRAME_CONSTANT**, **SUBFRAME_FIXED**, **SUBFRAME_LPC**. You will learn the magic of lossless data compression during this bonus.
  - When implementing this part, you are doing **real lossless compression**, the .flac file generated will reduce in size.
  - CONSTANT is recommended, the other two may need some pre-knowledge of signal processing.
  
  > My dad taught me that in Hawaii.
  
- 🤔 **GUI**
  Implement a pretty GUI for your convertor! However, you should still focus on the main part of this project: your library.
  > Gold needs to shine, too.

- 😇 **All-round Decoder**
  [FLAC decoder testbench](https://github.com/ietf-wg-cellar/flac-test-files) provides a collection of FLAC files that can be used to test various FLAC decoder abilities. Improve your decoder to pass as many testcases as possible [here](https://github.com/ietf-wg-cellar/flac-test-files/tree/main/subset), the more robust your library is, the more bonus points you get.
  > It's a hexagonal warrior.

- 😇 **More Audio Formats**

  Modify your library to make it work for more audio formats. A recommended challenge for those who are familiar with the audio file encoding formats.
  > No pain, no gain.

- **Anything You Regard as "Bonus"**

  Your team is encouraged to come up with your own ideas, we will grade your bonus according to your workload and implementation.
  

Please describe your bonus clearly in your report, so that inspectors can fully understand and grade your bonus ideas.

### Self-Prepared Testcases (5 pts)

You are required to prepare at least 1 testcase for each basic function.

For your bonus part, you should prepare at least 1 testcase for each bonus function, otherwise the bonus is invalid.

Good news: any valid testcases that check the full usability of your library will obtain all of the 5 points.

### Report (10 pts)

The report should be in **PDF** format, easy to understand and provide a clear description of the project, especially the **highlights**. <u>Notice that your report should contain everything that a good README has.</u>

The report should also includes a detailed description of each team member's contribution, and contribution rated as

- A (significant contribution)
- B (moderate contribution)
- C (little contribution)
- D (free rider).

Reports that meaninglessly pile up pages will result in lower scores. Please be as concise and brief as possible and just show the highlights. Please avoid pasting too much code in your report. Any non-technical detail should be discarded, that's a waste of time for both your team and the inspectors.

You are encouraged to use IEEE, ACM, or any other elegant templates, however this will not affect your score, just to ease the veins of inspectors.

## Grading Policy

The maximum of this project is 110 points, consists of:
- basic functions (75)
- report (10)
- self-prepared testcases (5)
- bonus functions (20 + overflow to make up for basic requirements)

1. Your library need to support basic functions, including metadata display and editing, encoding and decoding, and pass all official testcases.
    After implementing the basic part, the **upper bound** of your basic score will reach 65, failure to pass the basic usability test will make your upper bound less than 65.

2. If your bonus part gains over 20 points, the overflow part can fill the basic part loss.

3. Be careful of the memory management and exception handling! Your library should be robust enough for basic use. Bad memory management will reduce your score.

4. Attention should be paid to code style. Adequate time is given for code to be written correctly and with good style. Deductions on the score will be made for poor code style. Code style guides, such as the [Google C++ Style Guide](http://google.github.io/styleguide/cppguide.html), can be used as a reference.

## Rules

1. To make this project more interesting, you are not allowed to use libFLAC, libFLAC++, ffmpeg, or any other library making it TOO easy to implement your convertor. Since your workload will be evaluated for grading.

2. The project files must be submitted before the deadline. Any submission after the deadline (even by 1 second) will result in a score of 0. The deadline is 23:59, on the Sunday of week 18.

## Utilities
Heres some useful tools to help you understand the formats and file streams. Notice that you may **NOT** invoke them in your own source code.

- [FLAC](https://xiph.org/flac/documentation_tools.html)
  The official command-line tools, which contains two sub programs. `flac` is an encoder as well as a decoder, while `metaflac` is a metadata editor. Your project may imitate the CLI of this official tool.
  
  We highly recommend you to check the format of .flac files using `flac -a` rather than reading the file in hexadecimal when debugging.
  
  ```
  flac input.wav      # encode WAVE into FLAC
  flac -d input.flac  # decode FLAC into WAVE
  flac -a input.flac  # analyze audio frames
  ```

  ![](https://s2.loli.net/2023/11/26/lZD8UhqR17aQeSk.png)
  
- [Sound eXchange](https://sourceforge.net/projects/sox/)
  SoX is the Swiss Army Knife of sound processing utilities. It can convert audio files to other popular audio file types and also apply sound effects and filters during the conversion.
  
  You may check if your convertor generates the same result as SoX does.
  
  ```
  sox -i input.wav        # show WAVE header info
  sox input.wav -t raw output.raw  # decode WAVE into RAW
  sox -t raw -c 2 -e signed-integer -b 16 -r 44100 name.raw name.wav
    # add headers for RAW and then encode them into WAVE
  ```
  
- [Hex Editor](https://marketplace.visualstudio.com/items?itemName=ms-vscode.hexeditor)
  A custom editor extension for Visual Studio Code which provides a hex editor for viewing and manipulating files in their raw hexadecimal representation.
## Reference

[Wikipedia: Waveform Audio File Format](https://en.wikipedia.org/wiki/WAV)

[Wikipedia: Free Lossless Audio Codec](https://en.wikipedia.org/wiki/FLAC)

[FLAC Official Webpage](https://xiph.org/flac/index.html)

[GitHub: xiph/flac](https://github.com/xiph/flac)

[FLAC decoder testbench](https://github.com/ietf-wg-cellar/flac-test-files)