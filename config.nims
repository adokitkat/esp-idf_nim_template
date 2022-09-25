import os, strformat

include "esptarget.nims"

let gcc_exe = gcc_target & "-gcc"

switch "gcc.path", gcc_path
switch "gcc.exe", gcc_exe
switch "gcc.linkerexe", gcc_exe

switch "passC", "-mlongcalls" # Without this I get "dangerous relocation: call8: call target out of range" 
# it is used in xtensa's CPUs

switch "define", "release"
switch "opt", "size"
switch "out", "main/libnim.a"

switch "cpu", "esp"
switch "os", "freertos"
switch "gc", "orc"

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
