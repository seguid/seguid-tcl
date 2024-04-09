[![seguid-tests](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml/badge.svg)](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml)

# SEGUID v2: Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

This is a Tool Command Language (Tcl) implementation of SEGUID v2
together with the original SEGUID algorithm.


## Examples

```sh
## Linear single-stranded DNA
$ seguid --type=lsseguid <<< "TATGCCAA"
lsseguid=EevrucUNYjqlsxrTEK8JJxPYllk

## Circular single-stranded DNA
$ seguid --type=csseguid <<< "TATGCCAA"
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw

## Same rotating two basepairs
$ seguid --type=csseguid <<< "GCCAATAT"
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw

## Linear double-stranded DNA
$ seguid --type=ldseguid <<< "AATATGCC;GGCATATT"
ldseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same swapping Watson and Crick 
$ seguid --type=ldseguid <<< "GGCATATT;AATATGCC"
ldseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same but rotated
$ seguid --type=ldseguid <<< "AATATGCC;GGCATATT"
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A
```


## Requirements

This Tcl implementation of SEGUID requires:

* [tclsh]


[tclsh]: https://wiki.tcl-lang.org/page/tclsh
