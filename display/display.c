#include "../types/stdint.h"
#include "display.h"

void printf(uint8_t colour, const char *string)
{
    char *video = (char*)0xB8000;
    while(*string != 0)
    {
        *video++ = *string++;
        *video++ = colour;
    }
}
