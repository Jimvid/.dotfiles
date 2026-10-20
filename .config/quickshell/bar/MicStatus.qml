import Quickshell.Services.Pipewire
import qs

// microphone status, only shown when it matters: crossed out while muted, lit while an app is recording; click toggles mute, scroll sets the level
Glyph {
    id: root
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool muted: source?.audio?.muted ?? false
    readonly property bool inUse: Pipewire.nodes.values.some(n => n.isStream && !n.isSink && n.audio !== null)
    PwObjectTracker { objects: [root.source] }

    visible: source !== null && (muted || inUse)
    icon: muted ? "mic-off" : "mic"
    color: muted ? Theme.subtle : Theme.accent
    tip: !source ? "" : (muted ? "Microphone muted" : "Microphone in use") + "\n" + (source.nickname || source.description)
    onClicked: { if (source?.audio) source.audio.muted = !muted; }
    onScrolled: delta => { if (source?.audio) source.audio.volume = Math.max(0, Math.min(1, (source.audio.volume ?? 0) + (delta > 0 ? 0.05 : -0.05))); }
}
