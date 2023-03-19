import os, strformat

include "esptarget.nims"

let gcc_exe = gcc_target & "-gcc"

switch "gcc.path", gcc_path
switch "gcc.exe", gcc_exe
switch "gcc.linkerexe", gcc_exe

import strutils
if target == "esp32" or "esp32s" in target:
    # Xtensa CPU
    # Fix for "dangerous relocation: call8: call target out of range" 
    switch "passC", "-mlongcalls"
    switch "passC", "-Wno-frame-address"
    switch "cpu", "esp"
else:
    # RISC-V CPU
    switch "passC", "-march=rv32imc_zicsr_zifencei"
    switch "cpu", "riscv32"

switch "os", "freertos"
switch "mm", "orc"

switch "define", "debug"
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
