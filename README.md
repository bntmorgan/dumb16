# Dumb SoC
Dumb SoC with dumb16 processor

![alt text](https://raw.githubusercontent.com/bntmorgan/dumb16/master/dumb16.jpg)

## Initialize vga-text-mode submodule
```
git submodule init
git submodule update
make -C vga-text-mode/fonts/xbm_tools gen
```

## Run simulations
```
make run_simulations
```
open generated vcd files with gtkwave

## Synthesize circuit
```
$ make targets
```

## Load circuit
```
$ sudo djtgcfg prog -f binary/dumb/system.bit -d Nexys3 -i 0
```
