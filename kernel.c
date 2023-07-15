typedef char int8_t;
typedef unsigned char uint8_t;

typedef short int int16_t;
typedef unsigned short int uint16_t;

typedef long int int32_t;
typedef unsigned long int uint32_t;

/*
typedef long long int int64_t;
typedef unsigned long long int uint64_t;
*/


void printf(uint8_t colour, const char *string)
{
    char *video = (char*)0xB8000;
    while(*string != 0)
    {
        *video++ = *string++;
        *video++ = colour;
    }
}

extern void main(){
	printf(4, "Hello from kernel!") // 0 -	Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red, 5 - Purple, 6 -	Brown, 7 - Gray, 8 - Dark Gray, 9 -	Light Blue, 10 - Light Green, 11 - Light Cyan, 12 - Light Red, 13 - Light Purple, 14 - Yellow, 15 - White
}