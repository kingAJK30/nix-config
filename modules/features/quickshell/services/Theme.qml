pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property color bg: adapter.colors.bg
    readonly property color surface: adapter.colors.surface
    readonly property color dim: adapter.colors.dim
    readonly property color fg: adapter.colors.fg
    readonly property color border: adapter.colors.border
    readonly property color accent: adapter.colors.accent
    readonly property color red: adapter.colors.red
    readonly property color yellow: adapter.colors.yellow
    readonly property color green: adapter.colors.green
    readonly property string font: adapter.fonts.mono
    readonly property int fontSize: adapter.fonts.size
    readonly property int rowHeight: 32
    readonly property string wallpaper: adapter.wallpaper

    // Shared motion profile: one mechanical "robot" language for every
    // animation in the bar. micro = color/toggle snaps, macro = size/position
    // moves. Sharp, no overshoot everywhere — anything here can fire
    // repeatedly in quick succession (bars, typing, streaming text), and
    // overshoot compounding across rapid changes reads as shaking.
    readonly property int motionMicro: 140
    readonly property int motionMacro: 220
    readonly property int snapEasing: Easing.OutExpo

    // ASCII density ramp shared by every text-based visual accent (cava
    // equalizer, AskOllama's thinking indicator) so they read as one
    // consistent typographic language and can be retuned in one place.
    readonly property string asciiRamp: " .:-=+*#%@"
    function rampChar(fraction) {
        const idx = Math.min(asciiRamp.length - 1, Math.max(0, Math.floor(fraction * (asciiRamp.length - 1))))
        return asciiRamp[idx]
    }

    FileView {
        path: Qt.resolvedUrl("../theme.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter
            property string wallpaper: ""
            property JsonObject colors: JsonObject {
                property string bg: "#ff00ff"
                property string surface: "#ff00ff"
                property string dim: "#ff00ff"
                property string fg: "#ff00ff"
                property string border: "#ff00ff"
                property string accent: "#ff00ff"
                property string red: "#ff00ff"
                property string yellow: "#ff00ff"
                property string green: "#ff00ff"
            }
            property JsonObject fonts: JsonObject {
                property string mono: "monospace"
                property int size: 12
            }
        }
    }
}
