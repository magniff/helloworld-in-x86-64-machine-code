# Writing Helloworld in Raw x86_64 Machine Code

_A byte-by-byte ELF64 adventure_

Our grandparents used to write programs **directly in machine code** -- absolute gigachads. I started wondering: _how hard is it really?_  
So this repo is my take on writing a complete **helloworld** program entirely from scratch, **byte by byte**, using pure x86_64 machine code and manual ELF64 packaging.

The dump I ended up with contains:

- an ELF64 file header
- a single executable program header
- and the machine code for the helloworld logic itself

All of that fits into **166 bytes** of final binary (which is actually... kinda a lot).

## Things I’ve learned

x86-64 machine code is basically a museum of hacks. As new instruction sets, addressing modes, and 64-bit support piled on top of the old 32-bit world, the ISA became... let’s say _character-rich_. Not exactly a fan.

## Recommended reading

To make sense of what’s going on in the code:

### • Endianness

x86 is **little-endian**.  
So the literal value `0xbacd` is stored as `cd ba` in memory.

### • ELF format

Run `man elf` and check out `/usr/include/elf.h` — most of it is paperwork,  
but **program-header → memory-segment mapping** is fascinating and worth digging into.

### • Linux syscall table

You’ll need it. I used this cheat sheet:  
https://filippo.io/linux-syscall-table/

### • x86_64 opcode representation

You _can_ try Intel’s official docs (vol. 2), but honestly I had way more luck with this:  
https://shell-storm.org/x86doc/

A few notes:

- Some opcodes are just plain bytes — e.g. the `syscall` instruction is always `0F 05`.
- But many instructions use prefixes and postfixes.

For example, `XOR r64, r/m64` is encoded as `REX.W + 33 /r`, which should be read like:

1. Emit the `REX.W` byte (more here: https://en.wikipedia.org/wiki/REX_prefix)
2. Emit byte `0x33`
3. Then emit the `/r` byte (that’s the ModR/M byte — see https://en.wikipedia.org/wiki/ModR/M)

There are other modifiers too — leaving those as homework. 😄
