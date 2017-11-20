---
layout: post
title:  "Swish and SPDX"
date:   2014-11-12
categories: programming
---

I recently read an interesting blog post about the banking app Swish. Check it out
[here](http://blog.nullbyte.eu/open-curtains-in-swish-payments-service/). Also, it
seems that Swish [uses GPL'ed libraries](https://www.facebook.com/getswish/posts/10152347980456949)
in their app, but they refuse to release the source code for it. My advice is:
**don't use Swish**. 

Also, as part of my work, I've contributed for the first
time to some real open source project, namely the Yocto project. Check out [my
patch](https://git.yoctoproject.org/cgit/cgit.cgi/poky/commit/meta/classes/spdx.bbclass?id=f348071efd9419de3fa7f4e4ad78dfa5f8445412)
for the SPDX bbclass. [SPDX](http://www.spdx.org) is a standard for describing
software licenses for files (sort of). We use the Yocto project to build a custom
embedded Linux-based platform.

**Update 2014-11-20**: Another patch by me was accepted for the same class, yay!

**Update 2017-11-12**: Since at least two years back, I'm using Swish because it is too much of a
hassle not to.
