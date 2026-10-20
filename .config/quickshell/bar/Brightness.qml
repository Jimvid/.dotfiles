import qs

// panel brightness: scroll to change, click for the slider
Glyph {
    id: root
    visible: Backlight.available
    icon: "sun"
    tip: "Brightness " + Backlight.percent + "%"
    onClicked: popup.visible = !popup.visible
    onScrolled: delta => Backlight.step(delta > 0 ? 5 : -5)
    BrightnessPopup { id: popup; target: root }
}
