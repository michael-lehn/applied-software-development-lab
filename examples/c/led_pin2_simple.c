static void setPinModes(unsigned char mode)
{
    *(volatile unsigned char *)(0x2A) = mode;
}

static void digitalWriteAll(unsigned char val)
{
    *(volatile unsigned char *)(0x2B) = val;
}

static void delay_cycles(unsigned long count)
{
    do {
	// make the compiler keep count in a register
	asm volatile ("" : "+r"(count));
	count = count - 1;
    } while (count != 0);
}

int main()
{
    /*
     * The functions setPinModes and digitalWriteAll
     * can be used to manipulate pins 0 to 7. They take
     * a byte, i.e., 8 bits, as argument. If val = 4,
     * the bit pattern of val is 00000100, i.e., bit 2
     * is set and all others are not:
     * - setPinModes(val) then configures pin 2 as
     *   output and all others as input.
     * - digitalWriteAll(val) then sets pin 2 HIGH.
     * - digitalWriteAll(0) sets pin 2 LOW.
     */
    // configure pin 2 as output
    setPinModes(4);
    // set pin 2 HIGH
    digitalWriteAll(4);

    // If an LED is connected to pin 2, it will
    // light up.
}
