import Quickshell.Services.UPower
import qs

Glyph {
    id: root
    readonly property int profile: PowerProfiles.profile
    icon: profile === PowerProfile.Performance ? "zap" : profile === PowerProfile.PowerSaver ? "leaf" : "gauge"
    tip: profile === PowerProfile.Performance ? "Performance" : profile === PowerProfile.PowerSaver ? "Power saver" : "Balanced"
    onClicked: popup.visible = !popup.visible
    PowerProfilePopup { id: popup; target: root }
}
