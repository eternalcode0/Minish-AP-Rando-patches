# Minish AP Rando Patches

This is a fork of LeonarthCG's original patches for the
[Minish Cap Randomizer by MinishMaker](https://github.com/minishmaker/randomizer).
With [LeonarchCG's permission](https://discord.com/channels/731205301247803413/1091489558325112873/1342637366921396378)
& [Myth's permission](https://discord.com/channels/342341497024151553/1110559642091790396/1346169084974334024)
I'm using their work as a foundation for [my Archipelago APWorld](https://github.com/eternalcode0/Archipelago/tree/feat/new-game-minish-cap/worlds/tmc).

## Contributing

### Pre-requisites

> [!CAUTION]
> While we use python for a buildscript and attempt to be os-agnostic, Windows is required to compile the ROM since we use ColorzCore. Unix may be used for compiling the asm or building the basepatch.

- For running the buildscript:
    - Install `python3` to run the build script with `python compile.py`
- For compiling the assembly:
    - Dump a EU version of TMC to the root of this repo named `tmc.eu.gba`
    - Make sure that the `build-essential`, `git`, `python3`, `python3-pip`, `cmake` and `libpng-dev` packages are installed. The `build-essential` package includes the `make`, `gcc-core`, and `g++` packages, so they do not have to be obtained separately.
    - If using Cygwin, [include](https://cygwin.com/cygwin-ug-net/setup-net.html#setup-packages) the `make`, `git`, `gcc-core`, `gcc-g++`, and `libpng-devel` packages.
    - To build the games code, the `arm-none-eabi-gcc` compiler is required. Both a standalone installation and [devkitPro](https://devkitpro.org/wiki/Getting_Started) are supported. For devkitPro, install the `gba-dev` package.
- For building the EA files into the modified rom:
    - Dump a EU version of TMC to the root of this repo named `tmc.eu.gba`
    - Clone and build [ColorzCore](https://github.com/FireEmblemUniverse/ColorzCore) and place the resulting executable at the root of this repo.
- For making the basepatch to be used by Archipelago:
    - Install [bsdiff](https://github.com/mendsley/bsdiff)

### Compilation

Compiling these patches are done in 3 steps, each broken down into their own flags with the python compile script.

1. `-a`: Compiling asm files to a dmp
1. `-r`: Compiling the EA files (which import the dmp files) into a `tmc.ap.gba` rom
1. `-d`: Computing a bsdiff from the original rom to `basepatch.bsdiff`

> [!NOTE]
> Flag order matters! -a must always come last since it can receive a list of assembly files to compile. Don't get confused though, this doesn't affect execution order. They always run in the above order.

Any of these flags may be passed either all at once or in separate commands but running each in order is required depending on which files need compiling.

Some example usages:

- On first run all 3 must be run:
    - `python compile.py -dra`
    - `python compile.py -a && python compile.py -r && python compile.py -d`
- Only assembly files under `src/asm/` were changed:
    - `python compile.py -rda src/asm/*.s`
- No assembly files were changed:
    - `python compile.py -rd`
- Only compiling asm and ea files to test locally, not producing basepatch for AP yet:
    - `python compile.py -ra`

---

Continued is the original README from the base repository.

# Minish Rando original patches archive
 A repository holding the original form of the patches used in the Minish Maker team's randomizer.

The purpose of this repository is to clarify the license of these game modifications, along with the source files, in an explicit way

In the future, this may be expanded to hold the patch sets for different specific old versions of the randomizer, provided all parties involved in their making allow for it.
