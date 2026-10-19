import Quickshell.Services.UPower
import qs

Glyph {
    readonly property int profile: PowerProfiles.profile
    text: profile === PowerProfile.Performance ? "\uf0e7" : profile === PowerProfile.PowerSaver ? "\uf06c" : "\uf24e"
    tip: profile === PowerProfile.Performance ? "performance" : profile === PowerProfile.PowerSaver ? "power saver" : "balanced"
    onClicked: {
        if (profile === PowerProfile.PowerSaver) PowerProfiles.profile = PowerProfile.Balanced;
        else if (profile === PowerProfile.Balanced && PowerProfiles.hasPerformanceProfile) PowerProfiles.profile = PowerProfile.Performance;
        else PowerProfiles.profile = PowerProfile.PowerSaver;
    }
}
