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

    FileView {
        path: Qt.resolvedUrl("../theme.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter
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
