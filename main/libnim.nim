# Example Nim code

proc add_int_in_nim*(a, b: cint): cint {.exportc.} =
    result = a + b
    echo "Echo in Nim (int): ", a, " + " , b, " = ",  result 

proc add_float_in_nim*(a, b: cfloat): cfloat {.exportc.} =
    echo a + b
    result = a + b
    echo "Echo in Nim (float): ", a, " + " , b, " = ",  result

proc add_double_in_nim*(a, b: cdouble): cdouble {.exportc.} =
    echo a + b
    result = a + b  
    echo "Echo in Nim (double): ", a, " + " , b, " = ", result
