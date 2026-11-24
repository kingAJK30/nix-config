import QtQuick
import Quickshell
import Quickshell.Io

// Idle-state hint: a real audio equalizer driven by cava, reacting to
// whatever's actually playing. Sharp-edged bars only, no curves.
Item {
    id: root

    property bool paused: false

    readonly property int count: 16
    readonly property int barWidth: 6
    readonly property int spacing: 2
    readonly property int baseHeight: 2
    readonly property int amplitude: 24

    property var levels: new Array(count).fill(0)

    x: (parent ? parent.width : 0) / 2 - width / 2
    width: count * barWidth + (count - 1) * spacing
    height: baseHeight + amplitude

    visible: !paused

    Row {
        anchors.bottom: parent.bottom
        spacing: root.spacing

        Repeater {
            model: root.count

            Rectangle {
                required property int index

                width: root.barWidth
                height: root.baseHeight + root.amplitude * (root.levels[index] ?? 0) / 100
                anchors.bottom: parent.bottom
                color: Theme.accent

                Behavior on height { NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }
            }
        }
    }

    Process {
        running: !root.paused
        command: ["cava", "-p", Quickshell.shellPath("modules/cava.conf")]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(";").filter(s => s !== "")
                if (parts.length === root.count) root.levels = parts.map(Number)
            }
        }
    }
}
