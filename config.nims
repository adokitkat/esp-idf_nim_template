import os, strformat

include "esptarget.nims"

let gcc_exe = gcc_target & "-gcc"

switch "gcc.path", gcc_path
switch "gcc.exe", gcc_exe
switch "gcc.linkerexe", gcc_exe

import strutils
if target == "esp32" or "esp32s" in target:
    # Xtensa CPU
    switch "cpu", "esp"
    switch "passC", "-mlongcalls -fno-builtin-memcpy -fno-builtin-memset -fno-builtin-bzero"
    if target == "esp32":
        switch "passC", "-Wno-frame-address"
    # Workaround for newer GCC versions (14+?)
    switch "passC", "-Wno-incompatible-pointer-types"
else:
    # RISC-V CPU
    switch "cpu", "riscv32"
    if target in ["esp32c2", "esp32c3"]:
        switch "passC", "-march=rv32imc_zicsr_zifencei"
    elif target in ["esp32c5", "esp32c6", "esp32c61", "esp32h2", "esp32h21"]:
        switch "passC", "-march=rv32imac_zicsr_zifencei_zaamo_zalrsc"
    elif target in ["esp32h4"]:
        switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_xespdsp"
        switch "passC", "-mabi=ilp32f"
    elif target in ["esp32p4"]:
        switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_xesploop_xespv2p1" # ESP32-P4 rev. 2 and earlier
        # switch "passC", "-march=rv32imafc_zicsr_zifencei_zaamo_zalrsc_zcb_zcmp_zcmt_xesploop_xespv -mno-cm-popret -mno-cm-push-reverse" # ESP32-P4 rev. 3+
        switch "passC", "-mabi=ilp32f"

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
