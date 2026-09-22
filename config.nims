import os, strformat

include "esptarget.nims"

let gcc_exe = gcc_target & "-gcc"

switch "cc", "gcc" # Nim defaults to clang on macOS/BSD, which would ignore the gcc.* switches below
switch "gcc.path", gcc_path
switch "gcc.exe", gcc_exe
switch "gcc.linkerexe", gcc_exe

import strutils
if target in ["esp32", "esp32s2", "esp32s3"]:
    # Xtensa CPU
    switch "cpu", "esp"
    switch "passC", "-mlongcalls"
    switch "passC", "-fno-builtin-memcpy"
    switch "passC", "-fno-builtin-memset"
    switch "passC", "-fno-builtin-bzero"
    if target == "esp32":
        switch "passC", "-Wno-frame-address"
    # Workaround for newer GCC versions (14+?)
    switch "passC", "-Wno-incompatible-pointer-types" # https://github.com/nim-lang/Nim/issues/25200
else:
    # RISC-V CPU
    switch "cpu", "riscv32"
    var mtune = "-mtune=esp-base"
    if target in ["esp32c2", "esp32c3"]:
        switch "passC", "-march=rv32imc_zicsr_zifencei"
        mtune = fmt"-mtune={target}"
    elif target in ["esp32c5", "esp32c6", "esp32c61", "esp32h2", "esp32h21"]:
        switch "passC", "-march=rv32imac_zicsr_zifencei_zaamo_zalrsc"
        if target in ["esp32c5", "esp32c61"]:
            mtune = fmt"-mtune={target}"
    elif target in ["esp32h4"]:
        switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_xespdsp"
        switch "passC", "-mabi=ilp32f"
        mtune = fmt"-mtune={target}"
    elif target in ["esp32p4"]:
        var esp32p4_rev = ""
        const esp32p4_rev_rx: Regex= re"(# CONFIG_ESP32P4_SELECTS_REV_LESS_V3)"
        for m in sdkconfig.findAll(esp32p4_rev_rx):
            esp32p4_rev = m.groupFirstCapture(0, sdkconfig)
            break
        if esp32p4_rev == "":
            switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_xesploop_xespv2p1" # ESP32-P4 rev. 2 and earlier
        else:
            switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_zcb_zcmp_zcmt_xesploop_xespv" # ESP32-P4 rev. 3+
            switch "passC", "-mno-cm-popret"
            switch "passC", "-mno-cm-push-reverse"
        switch "passC", "-mabi=ilp32f"
        mtune = fmt"-mtune={target}"
    elif target in ["esp32s31"]:
        switch "passC", "-march=rv32imafcb_zicsr_zifencei_zcb_zcmp_zcmt_xesploop_xespv"
        switch "passC", "-mno-cm-popret"
        switch "passC", "-mabi=ilp32f"
        mtune = fmt"-mtune={target}"
    switch "passC", mtune

# The libc must match the one ESP-IDF builds with, otherwise Nim compiles against
# newlib headers and references newlib internals (__getreent, _REENT, ...)
if "CONFIG_LIBC_PICOLIBC=y" in sdkconfig:
    switch "passC", "-specs=picolibc.specs"
    switch "passC", "-D__PICOLIBC_ERRNO_FUNCTION=__errno"

switch "os", "freertos"
switch "mm", "orc"
switch "threads", "off"

switch "define", "release"
switch "opt", "size"
switch "out", "main/libnim.a"

switch "define", "nimAdaptiveOrc"
switch "define", "use_malloc"
switch "define", "no_signal_handler"

switch "debugger", "native"
switch "tls_emulation", "off"
switch "app", "staticLib"
switch "noMain"
switch "header"
switch "nimcache", "main/nimcache"
switch "forceBuild"
# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
    include "nimble.paths"
# end Nimble config
