# awemu
A screen emulator for android devices, written in TCL.

Still in pre-alpha state.

![AWhelper on awemu](https://github.com/dzach/awhelper/blob/master/awhelper.gif)

There is a [larger demo](https://github.com/dzach/awemu/blob/master/LARGE-DEMO.md).

It's based on the small proc ```rotateToplevel```. Usage:
```
rotateToplevel .toplevel degrees -center {X Y} -deg0 degrees
```

Example:
```
toplevel .t
wm geometry .t 240x440+400+300
pack [label .t.l "Testing toplevel rotation"] -side top
rotateToplevel .t 90 -center {520 420}
rotateToplevel .t -90 -center {520 420}
```
Rotation is in 90deg increments, but is not incremental. Last rotation can be supplied as ```-deg0 <last rotation>``` to create an incremental rotation effect. 

Example for clockwise incremental rotation. Frame is kept on top:
```
toplevel .t
wm geometry .t 240x440+400+300
pack [frame .t.f -width 40 -height 40 -background red] -side top -fill x -padx 5 -pady 5
proc rotate {W deg args} {
  rotateToplevel $W $deg -deg0 $::deg0 {*}$args
}
set deg0 0
rotate .t 90 -center {520 420}
rotate .t 90 -center {520 420}
rotate .t 90 -center {520 420}
rotate .t 90 -center {520 420}
```
![rotateToplevel](https://github.com/dzach/awemu/blob/master/rotateToplevel.gif)

Example of a frame keeping the sort side, top or right:
```
# continue from above:

bind .t <<ViewportUpdate>> {
  if {[winfo width .t] > [winfo height .t]} {
    pack .t.f -side right -fill y
  } else {
    pack .t.f -side top -fill x
  }
}
rotate .t 90 -center {520 420}
rotate .t 90 -center {520 420}
```
![rotateToplevel1](https://github.com/dzach/awemu/blob/master/rotateToplevel-1.gif)

More to come...
