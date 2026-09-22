# Package

version       = "0.2.3"
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

    # Record the target libnim.a was built for. main/CMakeLists.txt checks it, so that a
    # stale library (e.g. left over after `idf.py set-target`) is reported clearly instead
    # of failing the link with "relocations in generic ELF".
    var idf_target = ""
    for line in readFile("sdkconfig").splitLines():
        if line.startsWith("CONFIG_IDF_TARGET="):
            idf_target = line.split('=')[1].strip(chars = {'"'})
            break
    writeFile("main/nimcache/.idf_target", idf_target)

    # Nim hardcodes `ar rcs` for --app:staticLib (compiler/extccomp.nim), so the host
    # archiver is used. macOS' ar/ranlib cannot index cross-compiled ELF objects and
    # leaves libnim.a without a symbol table, which makes the ESP-IDF link fail with
    # "undefined reference to NimMain". Re-index with the target's ranlib.
    when defined(macosx):
        var gcc_target = "riscv32-esp-elf"
        if idf_target in ["esp32", "esp32s2", "esp32s3"]:
            gcc_target = &"xtensa-{idf_target}-elf"
        exec &"{gcc_target}-ranlib main/libnim.a"
