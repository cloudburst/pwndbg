#!/bin/sh

appline=$(head -c 1000 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)"BkP{This is the flag.}"

tmux splitw -- qemu-system-arm -s -M versatilepb -cpu cortex-a15 -m 128M -nographic -kernel boot.bin -monitor /dev/null -append "$appline" 2>/dev/null
gdb-multiarch -ex 'set arch arm' -ex 'target remote localhost:1234'
