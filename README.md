[![seguid-tests](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml/badge.svg)](https://github.com/seguid/seguid-tcl/actions/workflows/seguid-tests.yml)

# SEGUID v2: Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

This is a Tool Command Language (Tcl) implementation of SEGUID v2
together with the original SEGUID algorithm.


## Examples

### API

```tcl
$ tclsh
% source src/seguid.tcl

## Linear double-stranded DNA
% puts [seguid::ldseguid "AATATGCC" "GGCATATT"]
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same swapping Watson and Crick 
% puts [seguid::ldseguid "GGCATATT" "AATATGCC"]
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Circular double-stranded DNA
% puts [seguid::cdseguid "TATGCCAA" "TTGGCATA"]
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same swapping Watson and Crick 
% puts [seguid::cdseguid "TTGGCATA" "TATGCCAA"]
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A

## Same rotating two basepairs  = minimal rotation by Watson)
% puts [seguid::cdseguid "AATATGCC" "GGCATATT"]
cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A

% puts [seguid::lsseguid "TATGCCAA"]
lsseguid=EevrucUNYjqlsxrTEK8JJxPYllk

% puts [seguid::csseguid "TATGCCAA"]
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw

% puts [seguid::csseguid "GCCAATAT"]
csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw
```


### CLI

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

The standalone `seguid` Tcl script is built from the Tcl scripts in
the `src/` folder.  To build it from source, do:

```sh
$ make seguid
Building seguid from src/seguid.tcl src/base64.tcl src/sha1.tcl ...
-rwxrwxr-x 1 henrik henrik 17827 Oct 23 16:28 seguid
Version built: 0.0.2
Building seguid from src/seguid.tcl src/base64.tcl src/sha1.tcl ... done
```

To verify it was built correctly, call:

```sh
$ tclsh seguid --version
0.0.2
```


[tclsh]: https://wiki.tcl-lang.org/page/tclsh
