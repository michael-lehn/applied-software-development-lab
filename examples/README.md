# Programming examples

Example programs used in Lab Handouts 2–4 and in the project companion
([`blinking-led-bare-metal.pdf`](../pdf/blinking-led-bare-metal.pdf)).
All programs run on an ATmega328P clocked at 16 MHz (e.g., Arduino Uno or
Adafruit Metro) and toggle pin 2 (`PD2`).

| Directory | Contents |
|-----------|----------|
| [`asm/`](asm) | Assembly programs: simple blinking, toggling with XOR, and delay loops with one, two, and four registers |
| [`c/`](c) | Bare-metal C programs without the Arduino framework |

Requirements: the AVR GNU toolchain (`avr-as`, `avr-ld`, `avr-gcc`,
`avr-objcopy`) and `avrdude`.

```sh
cd asm
make                            # assemble all *.s files into *.hex
make upload HEX=led_pin2.hex    # flash a program via the Arduino bootloader
```

The upload target looks for the first `/dev/ttyUSB*` device on Linux and the
first `/dev/cu.usb*` device on macOS.
