# 🌼 Magnolia

Magnolia is an open-source assembly program designed to be run as an
[Option ROM][option-rom], giving users access to tools and games
directly from a computer's BIOS.

![Magnolia](demo.png?raw=true "Magnolia")

## Before you start

### Compatibility notice

Despite being designed and developed specifically for use with legacy BIOS, Magnolia is UEFI compatible.
Currently, UEFI can load and execute OpROM from legacy BIOS when the Compatibility Support Module (CSM) is enabled.
There are no plans to support native UEFI in the near future.

### Disclaimer

Miralium Research, along with the authors and contributors of the
Magnolia project, disclaim all liability for any damage, either direct
or indirect, that may result from the use or misuse of this software.
Users are solely responsible for their actions and assume all risks
associated with the modification and usage of Magnolia within their
system.

## Motivation

At [Miralium Research][miralium-research], we intend to use Magnolia as
a platform for cybersecurity research by using it as a means to
facilitate testing code on the context of a PC's firmware.

We invite and encourage the community to fork Magnolia and use it as a
foundation for their own unique applications.

## Features

The following features are available on the latest release of Magnolia.

### Games

- **Floppy Bird:** A clone of the Flappy Bird game, written in assembly
   by [Mihail Szabolcs][floppy-bird].

### Tools

- **PC Speaker Test:** Plays a simple tune through the onboard PC
  speaker.

## Roadmap

Magnolia is under active development, and additional tools and games
will be made available in future releases. Currently, our primary focus
is on implementing the following features:

1. **Memory Dump:** This feature will enable users to dump their PC's
   memory over a serial cable. It is likely to be based on
   [mdump][mdump], a tool by [Davidson Francis][theldus].

2. **Dynamic Loader:** We are working on developing a tool that allows
   users to load and run code through a serial cable. This feature could
   make it more convenient and efficient to test custom code within the
   BIOS environment, since it reduces the need for reflashing the EEPROM
   for validating code on real hardware.

## Running

To run Magnolia, you will need to either assembly its binary file from
the source code within this repository by running the `build.py` script
or download a pre-assembled version from the [releases][releases] page.
The binary should be loaded into a system as an Option ROM.

On some cases, it may be required to modify the PCI-related values on
the `build.yml` file in order to build a customized version for a
specific system.

### Using QEMU

To load an Option ROM in QEMU, simply specify the path to the image
using the `-option-rom` command line option. For example, after running
the `build.py` script, you can run the following command from the root
of this repository:

```bash
qemu-system-i386 -option-rom ./bin/magnolia.bin
```

Alternatively, `qemu-system-x86_64` can be used. It does not really make
a difference in this case, since Magnolia and its modules run entirely
in 16 bit real mode.

### Using real hardware

Detailed instructions on loading Magnolia as an Option ROM into real
hardare are currently not covered by this README. It is expected that
users attempting this have a solid understanding of the processes
involved and are well-aware of the risks associated with modding and
reflashing BIOSes and/or ROMs.

## License

Magnolia's original source code is released under
[The Unlicense][the-unlicense], granting permission for unlimited use,
modification and distribution. However, please note that some of the
included source code files are released under different licenses.

See the [LICENSE.txt][license] file for more information.

## Support

If you have any issues or questions, please [submit an issue][issues]
on the GitHub repository, and we will get back to you as soon as
possible.

[floppy-bird]: https://github.com/icebreaker/floppybird
[issues]: https://github.com/miraliumre/magnolia/issues
[license]: LICENSE.txt
[mdump]: https://github.com/Theldus/AMI_BIOS_CodeInjection/tree/main/tools/mdump
[miralium-research]: https://miralium.re
[option-rom]: https://en.wikipedia.org/wiki/Option_ROM
[releases]: https://github.com/miraliumre/magnolia/releases
[the-unlicense]: https://unlicense.org
[theldus]: https://github.com/Theldus
