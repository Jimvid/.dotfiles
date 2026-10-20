pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

// which mpris player the bar follows: the one playing, else the first that has a track loaded
Singleton {
    id: root
    readonly property var all: Mpris.players.values
    readonly property MprisPlayer active: all.find(p => p.isPlaying) ?? all.find(p => p.trackTitle !== "") ?? null
    function title(p) { return p?.trackTitle || "Unknown"; }
    function artist(p) { return p?.trackArtist || ""; }
    function fmt(s) { s = Math.max(0, Math.floor(s)); return Math.floor(s / 60) + ":" + (s % 60 < 10 ? "0" : "") + s % 60; }
}
