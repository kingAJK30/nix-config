import QtQuick
import Quickshell
import Quickshell.Io
import "../components"
import "../services"

// Idle-state hint: a real audio equalizer driven by cava, reacting to
// whatever's actually playing — rendered as a single line of ASCII density
// characters rather than shapes, so the whole bar stays purely typographic.
//
// cava can exit immediately if pipewire isn't up yet (e.g. right after
// login/reboot); when a Process dies, Quickshell clears its `running`
// property from the native side, which silently breaks a declarative
// `running: !paused` binding and leaves the visualizer dead forever. So
// cava is driven imperatively via RestartableProcess and retried on exit.
Item {
    id: root

    property bool paused: false

    readonly property int count: 16

    property var levels: new Array(count).fill(0)

    readonly property string display: {
        let s = ""
        for (let i = 0; i < count; i++) s += Theme.rampChar((levels[i] ?? 0) / 100)
        return s
    }

    x: (parent ? parent.width : 0) / 2 - width / 2
    width: label.implicitWidth
    height: label.implicitHeight

    visible: !paused

    onPausedChanged: {
        if (paused) cava.running = false
        else cava.restart()
    }

    Component.onCompleted: if (!paused) cava.restart()

    ThemedText {
        id: label
        text: root.display
        color: Theme.fg
    }

    RestartableProcess {
        id: cava
        command: ["cava", "-p", Quickshell.shellPath("modules/cava.conf")]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(";").filter(s => s !== "")
                if (parts.length === root.count) root.levels = parts.map(Number)
            }
        }
        onExited: retryTimer.restart()
    }

    Timer {
        id: retryTimer
        interval: 1000
        onTriggered: if (!root.paused) cava.restart()
    }
}
