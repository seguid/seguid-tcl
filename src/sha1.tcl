##############
## sha1 hashing from tcllib
##############
namespace eval ::sha1 {
	variable K

	proc initK {} {
	    variable K {}
	    foreach t {
		0x5A827999
		0x6ED9EBA1
		0x8F1BBCDC
		0xCA62C1D6
	    } {
		for {set i 0} {$i < 20} {incr i} {
		    lappend K [expr {int($t)}]
		}
	    }
	}
	initK
}

 

    proc ::sha1::sha1 {msg} {
	variable K

	#
	# 4. MESSAGE PADDING
	#

	# pad to 512 bits (512/8 = 64 bytes)

	set msgLen [string length $msg]

	# last 8 bytes are reserved for msgLen
	# plus 1 for "1"

	set padLen [expr {56 - $msgLen%64}]
	if {$msgLen % 64 >= 56} {
	    incr padLen 64
	}

	# 4a. and b. append single 1b followed by 0b's
	append msg [binary format "a$padLen" \200]

	# 4c. append 64-bit length
	# Our implementation obviously limits string length to 32bits.
	append msg \0\0\0\0[binary format "I" [expr {8*$msgLen}]]
    
	#
	# 7. COMPUTING THE MESSAGE DIGEST
	#

	# initial H buffer

	set H0 [expr {int(0x67452301)}]
	set H1 [expr {int(0xEFCDAB89)}]
	set H2 [expr {int(0x98BADCFE)}]
	set H3 [expr {int(0x10325476)}]
	set H4 [expr {int(0xC3D2E1F0)}]

	#
	# process message in 16-word blocks (64-byte blocks)
	#

	# convert message to array of 32-bit integers
	# each block of 16-words is stored in M($i,0-16)

	binary scan $msg I* words
	set blockLen [llength $words]

	for {set i 0} {$i < $blockLen} {incr i 16} {
	    # 7a. Divide M[i] into 16 words W[0], W[1], ...
	    set W [lrange $words $i [expr {$i+15}]]

	    # 7b. For t = 16 to 79 let W[t] = ....
	    set t   16
	    set t3  12
	    set t8   7
	    set t14  1
	    set t16 -1
	    for {} {$t < 80} {incr t} {
		set x [expr {[lindex $W [incr t3]] ^ [lindex $W [incr t8]] ^ \
			[lindex $W [incr t14]] ^ [lindex $W [incr t16]]}]
		lappend W [expr {($x << 1) | (($x >> 31) & 1)}]
	    }

	    # 7c. Let A = H[0] ....
	    set A $H0
	    set B $H1
	    set C $H2
	    set D $H3
	    set E $H4

	    # 7d. For t = 0 to 79 do
	    for {set t 0} {$t < 20} {incr t} {
		set TEMP [expr {(($A << 5) | (($A >> 27) & 0x1f)) + \
			(($B & $C) | ((~$B) & $D)) \
			+ $E + [lindex $W $t] + [lindex $K $t]}]
		set E $D
		set D $C
		set C [expr {($B << 30) | (($B >> 2) & 0x3fffffff)}]
		set B $A
		set A $TEMP
	    }
	    for {} {$t<40} {incr t} {
		set TEMP [expr {(($A << 5) | (($A >> 27) & 0x1f)) + \
			($B ^ $C ^ $D) \
			+ $E + [lindex $W $t] + [lindex $K $t]}]
		set E $D
		set D $C
		set C [expr {($B << 30) | (($B >> 2) & 0x3fffffff)}]
		set B $A
		set A $TEMP
	    }
	    for {} {$t<60} {incr t} {
		set TEMP [expr {(($A << 5) | (($A >> 27) & 0x1f)) + \
			(($B & $C) | ($B & $D) | ($C & $D)) \
			+ $E + [lindex $W $t] + [lindex $K $t]}]
		set E $D
		set D $C
		set C [expr {($B << 30) | (($B >> 2) & 0x3fffffff)}]
		set B $A
		set A $TEMP
	    }
	    for {} {$t<80} {incr t} {
		set TEMP [expr {(($A << 5) | (($A >> 27) & 0x1f)) + \
			($B ^ $C ^ $D) \
			+ $E + [lindex $W $t] + [lindex $K $t]}]
		set E $D
		set D $C
		set C [expr {($B << 30) | (($B >> 2) & 0x3fffffff)}]
		set B $A
		set A $TEMP
	    }

	    set H0 [expr {int(($H0 + $A) & 0xffffffff)}]
	    set H1 [expr {int(($H1 + $B) & 0xffffffff)}]
	    set H2 [expr {int(($H2 + $C) & 0xffffffff)}]
	    set H3 [expr {int(($H3 + $D) & 0xffffffff)}]
	    set H4 [expr {int(($H4 + $E) & 0xffffffff)}]
	}

	return [format %0.8x%0.8x%0.8x%0.8x%0.8x $H0 $H1 $H2 $H3 $H4]
    }
