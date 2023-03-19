# ESP-IDF + Nim shared lib example template

Project structure:

```text
├── main
│   ├── CMakeLists.txt
│   ├── libnim.nim             Your Nim code 
│   └── main.c                 Your C code
├── CMakeLists.txt 
├── config.nims                Nim compilation config
├── esp_nim_template.nimble
├── esptarget.nims             Nim compilation config helper file
├── README.md
└── sdkconfig                  
```

## Configure

1. Install dependecies of this repo: `nimble install regex`
1. Install and export `ESP-IDF`

Toolchain version should be found automatically from `PATH` enviroment variable.

## Build

1. `idf.py set-target <TARGET>`
1. `nimble prepare`
1. `idf.py build`

`nimble prepare` genereates a shared library (`libnim.a` file). `idf.py build` then links your IDF program to the Nim library - this is configured in `main/CMakeLists.txt`.
