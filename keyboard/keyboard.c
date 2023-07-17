#include "keyboard.h"
#include "../ports/ports.h"
#include "../types/stdint.h"

uint8_t get_key()
{
    uint8_t key;
    key = inportb(0x60); // in al, 0x60 - wait key asm
    return key;
}