let toolchain_version = "esp-2022r1-11.2.0"

import os, strformat

var target = "esp32"
var gcc_target = "xtensa-esp32-elf"
var gcc_path = &"{os.getHomeDir()}.espressif/tools/{gcc_target}/{toolchain_version}/{gcc_target}/bin"

const sdkconfig_file = "sdkconfig"

if not sdkconfig_file.fileExists():
    quit("sdkconfig file not found, run 'idf.py set-target TARGET' or 'idf.py menuconfig' first")

let sdkconfig = sdkconfig_file.readFile()

import regex
const rx: Regex= re"CONFIG_IDF_TARGET=\x22(.+)\x22"
for m in sdkconfig.findAll(rx):
    target = m.groupFirstCapture(0, sdkconfig)
    break

if target == "esp32s2":
    gcc_target = "xtensa-esp32s2-elf"
elif target == "esp32s3":
    gcc_target = "xtensa-esp32s3-elf"
elif target == "esp32c3":
    gcc_target = "riscv32-elf-elf"
elif target == "esp32c2":
    gcc_target = "riscv32-elf-elf"

gcc_path = &"{os.getHomeDir()}.espressif/tools/{gcc_target}/{toolchain_version}/{gcc_target}/bin"
