#include <stdio.h>
#include "sdkconfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_chip_info.h"
#include "esp_flash.h"

#include "libnim.h" // Include Nim shared library

void app_main(void)
{
    NimMain(); // Call NimMain function to init GC and global variables

    int a = 2;
    int b = 3;
    printf("Int: %d + %d\n", a, b); 
    int sum = add_int_in_nim(a, b);
    printf("C printf - Nim calculated: %d\n\n", sum);

    float c = 2.0;
    float d = 3.0;
    printf("Float: %f + %f\n", c, d);
    float sum2 = add_float_in_nim(c, d);
    printf("C printf - Nim calculated: %f\n\n", sum2);

    double e = 2.0;
    double f = 3.0;
    printf("Double: %lf + %lf\n", e, f);
    double sum3 = add_double_in_nim(e, f);
    printf("C printf - Nim calculated: %lf\n\n", sum3);

    double sum4 = add_double_in_nim(20.0, -55.3);
    printf("C printf - Nim calculated: %lf\n\n", sum4);

    fflush(stdout);
}
