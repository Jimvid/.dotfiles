pragma Singleton
import QtQuick

// rose pine main; the single source for colours, fonts and shape across the shell
QtObject {
    readonly property color base:    "#191724"
    readonly property color surface: "#1f1d2e"
    readonly property color overlay: "#26233a"
    readonly property color muted:   "#6e6a86"
    readonly property color subtle:  "#908caa"
    readonly property color text:    "#e0def4"
    readonly property color love:    "#eb6f92"
    readonly property color gold:    "#f6c177"
    readonly property color rose:    "#ebbcba"
    readonly property color pine:    "#31748f"
    readonly property color foam:    "#9ccfd8"
    readonly property color iris:    "#c4a7e7"

    readonly property color accent:         foam
    readonly property color accentContrast: gold

    readonly property string ui:   "Geist"
    readonly property string mono: "GeistMono Nerd Font Mono"
    readonly property int fontSize:   14
    readonly property int uiFontSize: 13

    readonly property int barHeight:  30
    readonly property int barMargin:  4   // above and below the pills
    readonly property int sideMargin: 8   // left and right of the outer pills
    readonly property int pillRadius: 15
    readonly property int pillPadding: 8  // horizontal padding per module
    readonly property int cardRadius: 8
    readonly property int spacing: 0
}
