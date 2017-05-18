# hello-world
Atari Lynx programming tutorial Hello World

## Requirements

cc65<br>
gcc

## Environment

export CC65_HOME={cc65 home dir}

http://cc65.github.io/cc65

## Build

make all

load the resultant hello.lyx file into your emulator


## Manual Building

You can manually build the lynx rom with the following commands.  Ensure that the cc65 binaries are in your $PATH.
```
export CC65_HOME=/Users/kate/Applications/cc65

cc65 -t lynx hello.c
cp $CC65_HOME/target/lynx/drv/tgi/lynx-160-102-16.tgi .
co65 --code-label _lynxtgi lynx-160-102-16.tgi
ca65 -t lynx -o lynx-160-102-16.o lynx-160-102-16.s
cc65 --code-name CODE --rodata-name RODATA --bss-name BBS --data-name DATA -I . -t lynx --add-source -O -Or -Cl -Os hello.c
ca65 -o hello.o hello.s
cl65 -t lynx -o hello.lnx lynx-160-102-16.o hello.o $CC65_HOME/lib/lynx.lib 

```