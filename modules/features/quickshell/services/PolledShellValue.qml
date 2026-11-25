import QtQuick
import Quickshell.Io

// Shared idiom for "poll a shell command on an interval, parse its stdout
// into state" — Bluetooth, DoNotDisturb, and Keyboard each need exactly
// this, so it lives once here rather than being re-copied per singleton.
// mutate() runs a side-effecting command and waits for it to exit before
// re-polling, so a caller never races the daemon it just told to change
// state (see Bluetooth.qml's power toggle for why that matters).
Item {
    id: root

    property alias pollCommand: statusQuery.command
    property int interval: 2000

    signal parsed(string text)

    function repoll() {
        statusQuery.restart()
    }

    function mutate(command) {
        mutateProc.restart(command)
    }

    RestartableProcess {
        id: mutateProc
        onExited: statusQuery.restart()
    }

    RestartableProcess {
        id: statusQuery
        stdout: StdioCollector {
            onStreamFinished: root.parsed(text)
        }
    }

    Timer {
        interval: root.interval
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: statusQuery.restart()
    }
}
