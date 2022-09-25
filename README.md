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

## Building

Export ESP-IDF first. Then:

1. `idf.py set-target <TARGET>`
1. `nimble prepare`
1. `idf.py build`

`nimble prepare` genereates a shared library (`libnim.a` file) for `idf.py` to link against.
It is set in `main/CMakeLists.txt`.
