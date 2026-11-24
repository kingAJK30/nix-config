import QtQuick
import Quickshell.Io

// Toggling a Process's `running` straight back to true doesn't reliably
// restart it, so `restart()` stops it and waits a tick before starting
// again - optionally with a new `command`.
Item {
    id: root

    property alias command: proc.command
    property alias stdout: proc.stdout
    property alias running: proc.running

    function restart(newCommand) {
        if (newCommand !== undefined) proc.command = newCommand
        proc.running = false
        restartTimer.start()
    }

    Process {
        id: proc
    }

    Timer {
        id: restartTimer
        interval: 0
        onTriggered: proc.running = true
    }
}
