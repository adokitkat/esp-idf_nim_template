let toolchain_version = "esp-12.2.0_20230208"

import os, strformat

const sdkconfig_file = "sdkconfig"

if not sdkconfig_file.fileExists():
    quit("sdkconfig file not found, run 'idf.py set-target TARGET' or 'idf.py menuconfig' first")

let sdkconfig = sdkconfig_file.readFile()

import regex
var target: string
var gcc_target: string
const rx: Regex= re"CONFIG_IDF_TARGET=\x22(.+)\x22"
for m in sdkconfig.findAll(rx):
    target = m.groupFirstCapture(0, sdkconfig)
    break

if target == "esp32":
    gcc_target = "xtensa-esp32-elf"
elif target == "esp32s2":
    gcc_target = "xtensa-esp32s2-elf"
elif target == "esp32s3":
    gcc_target = "xtensa-esp32s3-elf"
else:
    gcc_target = "riscv32-esp-elf"

let gcc_path = &"{os.getHomeDir()}.espressif/tools/{gcc_target}/{toolchain_version}/{gcc_target}/bin"
