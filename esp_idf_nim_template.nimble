# Package

version       = "0.2.2"
author        = "Adam Múdry"
description   = "Run Nim from ESP-IDF C code"
license       = "MIT"
skipDirs      = @["main"]

# Dependencies

requires "nim >= 1.6.2"
requires "regex >= 0.19.0"

task prepare, "Build Nim part":
    exec "nim c main/libnim.nim"

import os
before prepare:
    rmDir("build", checkDir=false)
    rmDir("main/nimcache", checkDir=false)
    mkDir("main/nimcache")
    writeFile("main/nimcache/.gitkeep", "") # Ensure the directory exists in git

import strutils, strformat
after prepare:
    let nimbase_path = getCurrentCompilerExe().rsplit("/", maxsplit=2)[0] & "/lib/nimbase.h"
    exec &"cp {nimbase_path} main/nimcache/nimbase.h"
