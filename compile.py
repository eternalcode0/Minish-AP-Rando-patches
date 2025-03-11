import os
from pathlib import Path
import subprocess
import argparse
import glob
import hashlib
import shutil

ROM_BUF = 65536
ROM_SHA = "cff199b36ff173fb6faf152653d1bccf87c26fb7"
ROM_LOC = "tmc.eu.gba"
OUT_ROM = "tmc.ap.gba"

def check_rom_file() -> bool:
    sha1 = hashlib.sha1()

    if not Path(ROM_LOC).is_file():
        print(f"Rom not found, please place TMC (EU) at ./{ROM_LOC}")
        return False

    with open(ROM_LOC, "rb") as f:
        while True:
            data = f.read(ROM_BUF)
            if not data:
                break
            sha1.update(data)

    return ROM_SHA == sha1.hexdigest()

def compile_asm(path: str) -> bool:
    for file in glob.glob(path, recursive=True):
        fileBase = os.path.splitext(file)[0]
        fileElf = f"{fileBase}.elf"
        fileSym = f"{fileBase}.symbols.log"
        fileDmp = f"{fileBase}.dmp"
        try:
            subprocess.call([
                "arm-none-eabi-as",
                "-g",
                "-mcpu=arm7tdmi",
                "-mthumb-interwork",
                file,
                "-o",
                fileElf,
            ])

            f = open(fileSym, "w")
            subprocess.call([
                "arm-none-eabi-readelf",
                "-s",
                fileElf,
            ], stdout=f)

            subprocess.call([
                "arm-none-eabi-objcopy",
                "-S",
                fileElf,
                "-O",
                "binary",
                fileDmp,
            ])

            Path.unlink(fileElf)
            Path.unlink(fileSym)
        except:
            print("Error while compiling asm: %s" % file)
            return False
        else:
            print(f"Successfully compiled asm: {file}")
    return True

def compile_rom() -> bool:
    if not check_rom_file():
        return False

    current_directory = Path(__file__).parent.resolve()
    shutil.copyfile(ROM_LOC, OUT_ROM)

    try:
        subprocess.call([
            "ColorzCore.exe",
            "A",
            "FE8",
            f"-output:{OUT_ROM}",
            "-input:src/ROM Buildfile.event",
            "--nocash-sym:tmc.ap.sym",
        ])
    except:
        print("Rom compilation failed, ensure ColorzCore is installed in local path")
        return False
    return True


def compile_diff() -> bool:
    if not Path(OUT_ROM).is_file():
        print(f"Compiled rom not found, please compile with the -r flag")
        return False

    try:
        subprocess.call([
            "bsdiff",
            ROM_LOC,
            OUT_ROM,
            "basepatch.bsdiff",
        ])
    except:
        print("Diff calculation failed, how did that happen?")
        return False
    return True

def main():
    parser = argparse.ArgumentParser(description="All-in-one compiler for the asm, rom, and bsdiff")

    parser.add_argument("-r", "--rom", action="store_true",
                        help="Whether to compile all the dmp & ea files into a rom")

    parser.add_argument("-d", "--diff", action="store_true",
                        help="Whether to compute the bsdiff between the built rom and original")

    parser.add_argument("-a", "--asm", type=str, nargs="?", const="**/*.s",
                        help="A list of asm files to compile into dmp files.")

    args = parser.parse_args()

    if args.asm == None and not args.rom and not args.diff:
        print("No options passed, nothing to compile!")
        parser.print_help()

    if args.asm != None:
        if not compile_asm(args.asm):
            print("ASM compilation failed")
            return
    if args.rom:
        if not compile_rom():
            print("Rom compilation failed!")
            print(f"Please ensure there's a copy of TMC (EU) at {ROM_LOC} with the following SHA1: {ROM_SHA}")
            return
    if args.diff:
        if not compile_diff():
            print("Diff calculation failed")
            return

if __name__ == "__main__":
    main()
