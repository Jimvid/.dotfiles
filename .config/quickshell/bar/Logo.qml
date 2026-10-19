import Quickshell
import qs

Glyph {
    text: ""
    onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
}
