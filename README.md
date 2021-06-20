# YASM_assembly_exercises
This repository contains the solutions of some problems from "x86-64 Assembly Language Programming with Ubuntu" by Ed Jorgensen, Version 1.1.40, January 2020.

Most of the problems require a debugger input file, but I haven't worked on those yet.

Almost all problems have been linked and assembled with:  
  ```console
foo@bar:~$ yasm -g dwarf2 -f elf64 <filename>.asm -l <filename>.lst
foo@bar:~$ ld -g -o <filename> <filename>.o
```
