import qs

// coffee cup: lit while an idle inhibitor is held; click to pick a duration, right click toggles the last one
Glyph {
    id: root
    icon: "coffee"
    color: Caffeine.active ? Theme.accent : Theme.fg
    tip: Caffeine.active ? "Caffeine: " + Caffeine.remaining : "Caffeine off"
    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) Caffeine.toggle();
        else popup.visible = !popup.visible;
    }
    CaffeinePopup { id: popup; target: root }
}
