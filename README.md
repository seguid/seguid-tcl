[![seguid-tests](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml/badge.svg)](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml)

# SEGUID v2: Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

This is a Tool Command Language (Tcl) implementation of SEGUID v2
together with the original SEGUID algorithm.


## Examples

### Command-line interface

```sh
## Linear single-stranded DNA
$ tclsh seguid --type=lsseguid <<< "TATGCCAA"
lsseguid=EevrucUNYjqlsxrTEK8JJxPYllk

## Circular single-stranded DNA
$ tclsh seguid --type=csseguid <<< "TATGCCAA"
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw

## Same rotating two basepairs
$ tclsh seguid --type=csseguid <<< "GCCAATAT"
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw

## Linear double-stranded DNA
$ tclsh seguid --type=ldseguid <<< "AATATGCC;GGCATATT"
ldseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same swapping Watson and Crick 
$ tclsh seguid --type=ldseguid <<< "GGCATATT;AATATGCC"
ldseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same but rotated
$ tclsh seguid --type=ldseguid <<< "AATATGCC;GGCATATT"
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A
```


## Requirements

This Tcl implementation of SEGUID requires:

* [tclsh]



## Build from source

The `seguid` Tcl script is built from the Tcl scripts in the `src/`
folder.  To build it from source, do:

```sh
$ make seguid
Building seguid from src/seguid-cli.tcl src/base64.tcl src/sha1.tcl src/seguid.tcl ...
-rwxrwxr-x 1 alice alice 15025 May  4 16:13 seguid
Building seguid from src/seguid-cli.tcl src/base64.tcl src/sha1.tcl src/seguid.tcl ... done
```

To verify it was built correctly, call:

```sh
$ tclsh seguid --version
0.1
```


[tclsh]: https://wiki.tcl-lang.org/page/tclsh
