#!/bin/bash
# Wrapper script to run sby with system yosys (which has yosys-slang plugin)

# Temporarily override PATH to prioritize system yosys over oss-cad-suite
export PATH=/usr/local/bin:/usr/bin:/bin:$PATH

# Run sby with the modified PATH
/home/ljh/haveFun/tools/oss-cad-suite/bin/sby "$@"
