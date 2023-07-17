#include "../types/stdint.h"

extern uint8_t inportb(uint16_t portid);
extern uint16_t inportw(uint16_t portid);
extern uint32_t inportl(uint16_t portid);

extern void outportb(uint16_t portid, uint8_t value);
extern void outportw(uint16_t portid, uint16_t value);
extern void outportl(uint16_t portid, uint32_t value);