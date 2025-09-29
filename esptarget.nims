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


const rx_toolchain_ver_old: Regex = re".espressif/tools/xtensa-esp32-elf/esp-(.+)/xtensa-esp32-elf/bin"
const rx_toolchain_ver: Regex = re".espressif/tools/xtensa-esp-elf/esp-(.+)/xtensa-esp-elf/bin"

let path_env = getEnv("PATH")
var toolchain_version = "esp-"
var gcc_target_path = gcc_target

import strutils
for m in path_env.findAll(rx_toolchain_ver):
    toolchain_version &= m.groupFirstCapture(0, path_env)
    if target == "esp32" or "esp32s" in target:
        gcc_target_path = "xtensa-esp-elf"
    else:
        gcc_target_path = "riscv32-esp-elf"
    break

if toolchain_version == "esp-":
    for m in path_env.findAll(rx_toolchain_ver_old):
        toolchain_version &= m.groupFirstCapture(0, path_env)
        break

if toolchain_version == "esp-":
    quit("Could not determine toolchain version from PATH environment variable")

echo "Using toolchain version: ", toolchain_version

let gcc_path = &"{os.getHomeDir()}.espressif/tools/{gcc_target_path}/{toolchain_version}/{gcc_target_path}/bin"
