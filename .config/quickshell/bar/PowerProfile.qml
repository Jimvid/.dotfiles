import Quickshell.Services.UPower
import qs

Glyph {
    readonly property int profile: PowerProfiles.profile
    icon: profile === PowerProfile.Performance ? "zap" : profile === PowerProfile.PowerSaver ? "leaf" : "gauge"
    tip: profile === PowerProfile.Performance ? "performance" : profile === PowerProfile.PowerSaver ? "power saver" : "balanced"
    onClicked: {
        if (profile === PowerProfile.PowerSaver) PowerProfiles.profile = PowerProfile.Balanced;
        else if (profile === PowerProfile.Balanced && PowerProfiles.hasPerformanceProfile) PowerProfiles.profile = PowerProfile.Performance;
        else PowerProfiles.profile = PowerProfile.PowerSaver;
    }
}
