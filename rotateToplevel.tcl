proc rotateToplevel {W deg args} {
	# rotate a toplevel window around a center point
	#	x' = x cos(a) - y sin(a), y' = x sin(a) + y cos(a)
	if {$deg == 0} return
	# set default values. -deg0 is the previous rotation value.
	array set o {-deg0 0 -center {}}
	# merge defaults with user options
	array set o $args
	# make sure we have the toplevel
	set W [winfo toplevel $W]
	# limit degrees to 0 - 360
	set deg [expr {$deg % 360}]
	set a [expr {$deg / 45.0 * atan(1)}]; # angle in radians
	# width, height and NW corner
	lassign [split [wm geometry $W] x+] w h X Y
	# if -center was not provided, make up one
	if {![llength $o(-center)]} {
		# find shortest side
		if {$w > $h} {
			set min $h; set max $w
		} else {
			set min $w; set max $h
		}
		# calculate the corner coords at the origin
		if {$o(-deg0) < 180} {
			# in upper rect
			set cx [expr {$X + $min / 2}]
			set cy [expr {$Y + $min / 2}]
		} else {
			# in lower rect
			set cx [expr {$X + $w - $min / 2}]
			set cy [expr {$Y + $h - $min / 2}]
		}
	} else {
		# account for window border
		set geom [split [winfo geometry $W] x+]
		set cx [expr {[lindex $o(-center) 0] - [lindex $geom 2] + $X}]
		set cy [expr {[lindex $o(-center) 1] - [lindex $geom 3] + $Y}]
	}
	# move rect to the origin, in geometrical coords
	# 	i.e. y in screen coords grows downwards
	set x0 [expr {$X - $cx}]; set y0 [expr {$cy - $Y}]
	set x1 [expr {$x0 + $w}]; set y1 [expr {$y0 - $h}]
	set orig [list $x0 $y0 $x0 $y1 $x1 $y1 $x1 $y0]
	set sina [expr {sin($a)}]
	set cosa [expr {cos($a)}]
	foreach {x y} $orig {
		lappend xs [expr {round($x * $cosa - $y * $sina)}] 
		lappend ys [expr {round($x * $sina + $y * $cosa)}]
	}
	# find new extents
	set xmin [tcl::mathfunc::min {*}$xs]; set ymin [tcl::mathfunc::min {*}$ys]
	set xmax [tcl::mathfunc::max {*}$xs]; set ymax [tcl::mathfunc::max {*}$ys]
	set w [expr {$xmax - $xmin}]; set h [expr {$ymax - $ymin}]
	set X [expr {$cx + $xmin}]; set Y [expr {$cy - $ymax}]
	wm geometry $W ${w}x${h}+$X+$Y
	update
	event generate $W <<ViewportUpdate>>
}
