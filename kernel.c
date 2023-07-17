#include "../types/stdint.h"
//#include "../ports/ports.h"
#include "../display/display.h"
#include "../keyboard/keyboard.h"

extern void main()
{
	printf(4, "Hello from kernel!\n"); // 0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red, 5 - Purple, 6 -	Brown, 7 - Gray, 8 - Dark Gray, 9 -	Light Blue, 10 - Light Green, 11 - Light Cyan, 12 - Light Red, 13 - Light Purple, 14 - Yellow, 15 - White
    while (1)
    {
        key = get_key();
        if (key == Q_PRESSED)
        {
            printf(1, "Q pressed!");
            continue;
        }
        else if (key == X_PRESSED)
        {
            printf(2, "X pressed!");
            continue;
        }
        else {
            continue;
        }
    }
}