# Dumb SoC
Dumb SoC with dumb16 processor

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
