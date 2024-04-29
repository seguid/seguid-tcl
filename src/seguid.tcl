proc seguid {text form} {
  calculate_seguid $text s $form
}

proc lsseguid {text form} {
  calculate_seguid $text lss $form
}

proc csseguid {text form} {
  calculate_seguid $text css $form
}

proc ldseguid {text form} {
  calculate_seguid $text lds $form
}

proc cdseguid {text form} {
  calculate_seguid $text cds $form
}

##################
## Find ldseguid for linear or cdseguid for circular
##################
proc calculate_seguid {text mode form} {
  global info

  if {[regexp {(.*)\n(.*)} $text -- top bottom]} {
    set bottom [string reverse $bottom]
    set text "$top;$bottom"
  } elseif {[regexp {(.*);(.*)} $text -- top bottom]} {
  }
  switch $mode {
    "lss" {
      set prefix "lsseguid="
    }
    "css" {
      lassign [short_rot $text] text --
      set prefix "csseguid="
    }
    "lds" {
      if {$top > $bottom} {
        set text "$bottom;$top"
      } 
      set prefix "ldseguid="
    }
    "cds" {
      set prefix "cdseguid="
      lassign [short_rot $top $bottom] t t1
      lassign [short_rot $bottom $top] b b1

      if {[string compare $t $b] < 0} {
        set text "$t;$t1"
      } else {
        set text "$b;$b1"
      }
    }
    "s" -
     default {
      set prefix "seguid="
     }
  }
  if {$mode ne "s"} {
    set base [string range [string map {+ -  / _} [::base64::encode [binary format H* [::sha1::sha1 $text]]]] 0 26]
  } else {
    set base [string range [::base64::encode [binary format H* [::sha1::sha1 $text]]] 0 26]
  }
  switch $form {
    "short" {
      return "[string range $base 0 5]"
    }
    "both" {
      return "[string range $base 0 5] $prefix$base"
     }
    "long" -
    default {
      return "$prefix$base"
    }
  }

}

##################
## Find the shortest rotation of a string
##################
proc short_rot {s {d ""}} {

  set b [string reverse $d]
  set bsf_b $b

  set bsf $s ;#best so far
  set len [string length $s]; # length of string
  set end $len
  append s $s; # duplicate string - makes rotations easier
  append b $b

  for {set i 1} {$i < $len} {incr i} {
    if {[string compare [string range $s $i $end] $bsf] < 0} { 
      set bsf [string range $s $i $end]
      set bsf_b [string range $b $i $end]
    } 
    incr end
  }
  # return best-so-far
    return [list $bsf [string reverse $bsf_b]]
}


##########
## returns the reverse complement of the input
##########
proc revcom {pattern} {
  set temp ""
  set length [string length $pattern]
  for {set i [expr {$length-1}]} {$i >= 0} {incr i -1} {
    append temp [string map {A T B V C G D H G C H D K M M K N N * * R Y S S T A V B W W Y R a t b v c g d h g c h d k m m k n n r y s s t a v b w w y r} [string index $pattern $i]]
  }
  return $temp
}

##########
## returns the reverse of the input
##########
proc rev {args} {
  set temp ""
  set pattern [join $args " "]
  foreach char [split $pattern ""] {
    set temp "$char$temp"
  }
  return $temp
}

##########
## returns the complement of the input
##########
proc com {args} {
   return [string map {A T B V C G D H G C H D K M M K N N * * R Y S S T A V B W W Y R a t b v c g d h g c h d k m m k n n r y s s t a v b w w y r} [join $args " "]]
}


proc sputs {args} {
    puts stdout "$args"
}

proc validate {text alphabet} {
  regsub {\{DNA\}} $alphabet "CG,AT" alphabet
  regsub {\{RNA\}} $alphabet "CG,AU" alphabet
  regsub {\{protein\}} $alphabet "A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,O,U" alphabet
  regsub {\{DNA-IUPAC\}} $alphabet "CG,AT,WW,SS,MK,RY,BV,DH,VB,NN" alphabet
  regsub {\{RNA-IUPAC\}} $alphabet "CG,AU,WW,SS,MK,RY,BV,DH,VB,NN" alphabet
  regsub {\{protein-IUPAC\}} $alphabet "A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,B,O,U,J,Z,X" alphabet

  regsub {\{DNA-extended\}} $alphabet "CG,AT,WW,SS,MK,RY,BV,DH,VB,NN" alphabet
  regsub {\{RNA-extended\}} $alphabet "CG,AU,WW,SS,MK,RY,BV,DH,VB,NN" alphabet
  regsub {\{protein-extended\}} $alphabet "A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,B,O,U,J,Z,X" alphabet

  if {[regexp {(\{[^\,]*\}?)} $alphabet -- spec] || [regexp {([^\,]*\})} $alphabet -- spec]} {
    return "Unknown alphabet specification: $spec in alphabet: $alphabet" 
  }
  if {![regexp {[^\s]} $alphabet -- spec]} {
    return "Empty alphabet specification: $alphabet" 
  }

  regsub -all "," $alphabet "" allowed
  set allowed_list [lsort -unique [split $allowed ""]]
  set bottom_r {}
  if {[regexp {(.*)\n(.*)} $text -- top bottom] || [regexp {(.*);(.*)} $text -- top bottom_r] } {
    if {![regexp {^[[:alnum:]][[:alnum:]](\,[[:alnum:]][[:alnum:]])+$}  $alphabet]  } {
      return "Improperly formatted alphabet specification: $alphabet" 
    }
    lappend allowed_list "-"
    if {$bottom_r ne {}} {
      set bottom [string reverse $bottom_r]
    }
    set pairs_list [split $alphabet ","]
    foreach t [split $top ""] b [split $bottom ""] {
      if {$t eq {} || $b eq {}} {
        return "unbalanced lengths" 
      }
      if {$t ni $allowed_list } {
        return "invalid symbol: $t Allowed symbols: $allowed_list"
      }
      if { $b ni $allowed_list} {
        return "invalid symbol: $b. Allowed symbols: $allowed_list"
      }
      if {$t ne "-" && $b ne "-" && "$t$b" ni $pairs_list && "$b$t" ni $pairs_list} {
        return "incompatible sequences"
      }
    }
  } else {
    if { ![regexp {^[[:alnum:]](\,[[:alnum:]])+$}  $alphabet] && ![regexp {^[[:alnum:]][[:alnum:]](\,[[:alnum:]][[:alnum:]])+$}  $alphabet] } {
      return "Improperly formatted alphabet specification: $alphabet" 
    }
    foreach t [split $text ""] {
      if {$t ni $allowed_list} {
        return "invalid symbol: $t. Allowed symbols: $allowed_list"
      }
    }
  }
  return "ok"
}
