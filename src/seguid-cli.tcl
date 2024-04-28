#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

set script_path [file dirname [info script]]
source [file join $script_path base64.tcl]
source [file join $script_path sha1.tcl]
source [file join $script_path seguid.tcl]


##################
## Main
##################
set version 0.1

if {[regexp -- {-version} $argv]} {
    puts stdout "$version"
    exit
}
if {[regexp -- {-help} $argv]} {
    puts stdout "--version"
    puts stdout "--help"
    puts stdout "Usage: seguid --type=(lds|cds|lss|css|s)eguid  --form=(long|short|both) --version --alphabet=({DNA}{RNA}{protein}{DNA-extended}{RNA-extended}{protein-extended},alphanumeric csv "
    exit
}

set mode "s"
set form "long"
set alphabet {{DNA}}

  regexp -- {type=(lds|cds|lss|css|s)eguid} $argv -- mode
  regexp -- {form=(long|short|both)} $argv -- form
  regexp -- {alphabet=([^\s\=]+)} $argv -- alphabet



set text_list ""
while {[gets stdin line] >= 0} {
    lappend text_list $line
}
set text [join $text_list \n]

if {[regexp {(\n.*\n)} $text] || ($mode in [list "lss" "css" "s"] && [regexp {[\n]} $text]) } {
  puts stderr "sguid error: too many lines"
  exit 1
}
if {[regexp {(;.*;)} $text] || ($mode in [list "lss" "css" "s"] && [regexp {[;]} $text]) } {
  puts stderr  "sguid error: too many strands"
  exit 1
}
if {[regexp {([;\n].*[;\n])} $text]} {
  puts stderr "sguid error: both semicolon and return in input text"
  exit 1
}
if {$mode in [list "lds" "cds"] && ![regexp {[;\n]} $text]} {
  puts stderr  "sguid error: only one strand specified for double stranded type"
  exit 1
}

if {$text eq {}} {
  puts stderr "sguid error: empty input"
  exit 1
}

if { ($mode ne "lds" && [regexp {([^[:alnum:];\n])} $text -- sym]) || [regexp {([^[:alnum:];\-\n])} $text -- sym]} {
  puts stderr "sguid error: invalid symbol: $sym"
  exit 1
}

if {[set err [validate $text $alphabet]] ne "ok"} {
  puts stderr "sguid error: $err"
  exit 1
}

puts stdout [calculate_seguid $text $mode $form]






