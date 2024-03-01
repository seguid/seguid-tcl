[![CLI-check](https://github.com/seguid/seguid-tcl/actions/workflows/check-cli.yml/badge.svg)](https://github.com/seguid/seguid-tcl/actions/workflows/check-cli.yml)

# SEGUID v2: Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

This is a Tcl implementation of SEGUID v2 together with the original
SEGUID algorithm.


## Examples

```sh
$ seguid --type=cdseguid <<< "TAAAATT"
input:TAAAATT
cdseguid=tPOOjAPjLqsrTL42W8HaPKlfRsk

$ seguid --type=ldseguid <<< "TAAAATT"
input:TAAAATT
ldseguid=FpPo_uNuqlitTaXv6VEhjkndhE4

$ seguid --type=lsseguid <<< "TAAAATT"
input:TAAAATT
lsseguid=Mx5yV5UCGeiMn1gVbiNiZPF9APM

$ seguid --type=csseguid <<< "TAAAATT"
input:TAAAATT
csseguid=iYbJwDEOVR7AOe-VE0jwVS5gsMc

$ seguid --type=ldseguid <<< "$'ATATGCC\nTATACGG'
input:ATATGCC
ldseguid=UnHLvKWgR_kAuUDz5D5zDYcYA7g
```

It defaults to `--type=ldseguid`;

```sh
$ seguid <<< "TAAAATT"
input:TAAAATT
ldseguid=FpPo_uNuqlitTaXv6VEhjkndhE4
```


## Requirements

This Tcl implementation of SEGUID requires:

* [tclsh]


[tclsh]: https://wiki.tcl-lang.org/page/tclsh
