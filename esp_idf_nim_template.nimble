# Package

version       = "0.1.0"
author        = "Adam Múdry"
description   = "Run Nim from ESP-IDF C code"
license       = "MIT"
skipDirs      = @["main"]

# Dependencies

requires "nim >= 1.6.2"
requires "regex >= 0.19.0"

task prepare, "Build Nim part":
    exec "nim c main/libnim.nim"

import os, strutils, strformat
after prepare:
    let nimbase_path = getCurrentCompilerExe().rsplit("/", maxsplit=2)[0] & "/lib/nimbase.h"
    exec &"cp {nimbase_path} main/nimcache/nimbase.h"