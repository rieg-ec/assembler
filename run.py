#!/usr/bin/env python3

import sys
import os
from iic2343 import Basys3

if len(sys.argv) != 2:
    print("Usage: ./run.py <filename.asm>")
    sys.exit(1)


def read_opcodes(filename):
    with open(filename, "r") as f:
        return f.read().split("\n")


def generate_opcodes(asm_filename: str):
    os.system(f"ruby assembler.rb {asm_filename} {asm_filename}.opcode")
    opcodes = read_opcodes(f"{asm_filename}.opcode")
    os.system(f"rm {asm_filename}.opcode")
    return opcodes


def opcodes_to_bytearray(opcode: str) -> bytearray:
    return bytearray(int(opcode, 2).to_bytes(5, byteorder="big"))


instance = Basys3()

filename = sys.argv[1]
opcodes = generate_opcodes(filename)

instance.begin(port_number=2)  # port_number is optional

for (address, opcode) in enumerate(opcodes):
    instance.write(address, opcodes_to_bytearray(opcode))

instance.end()
