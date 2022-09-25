# Example Nim code

proc add_int_in_nim*(a, b: cint): cint {.exportc.} =
    result = a+b
    echo "Echo in Nim: ", a, " + " , b, " = ",  result 

proc add_float_in_nim*(a, b: cfloat): cfloat {.exportc.} =
    result = a+b
    echo "Echo in Nim: ", a, " + " , b, " = ",  result

proc add_double_in_nim*(a, b: cdouble): cdouble {.exportc.} =
    result = a+b  
    echo "Echo in Nim: ", a, " + " , b, " = ", result
