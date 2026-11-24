pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string mode: "idle" // idle | toast | launcher | ask
    readonly property bool pinned: mode === "launcher" || mode === "ask"

    // Name of the sway output that was focused at the moment a pinned mode
    // was requested, so only that monitor's Center expands to show it.
    property string activeScreenName: ""
    property string pendingMode: ""

    property var toastQueue: []
    property var currentToast: null

    function openMode(m) {
        root.pendingMode = m
        focusQuery.restart()
    }

    RestartableProcess {
        id: focusQuery
        command: ["swaymsg", "-t", "get_outputs"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const outputs = JSON.parse(text)
                    const focused = outputs.find(o => o.focused)
                    root.activeScreenName = focused ? focused.name : ""
                } catch (e) {
                    root.activeScreenName = ""
                }
                root.mode = root.pendingMode
            }
        }
    }

    function pushToast(toast) {
        toastQueue = toastQueue.concat([toast])
        drain()
    }

    function drain() {
        if (root.pinned) return
        if (root.currentToast) return
        if (toastQueue.length === 0) {
            root.mode = "idle"
            return
        }
        root.currentToast = toastQueue[0]
        toastQueue = toastQueue.slice(1)
        root.mode = "toast"
        toastTimer.restart()
    }

    function closePinned() {
        if (!root.pinned) return
        root.currentToast = null
        root.mode = "idle"
        drain()
    }

    Timer {
        id: toastTimer
        interval: 3000
        onTriggered: {
            root.currentToast = null
            root.drain()
        }
    }

    Process {
        running: true
        command: ["busctl", "--user", "monitor", "--json=short", "org.freedesktop.Notifications"]
        stdout: SplitParser {
            onRead: line => {
                let msg
                try { msg = JSON.parse(line) } catch (e) { return }
                if (msg.type !== "method_call") return
                if (msg.interface !== "org.freedesktop.Notifications") return
                if (msg.member !== "Notify") return

                const d = msg.payload.data
                const hints = d[6] || {}
                const urgency = hints.urgency ? hints.urgency.data : 1

                Quickshell.execDetached(["swaync-client", "--hide-all"])
                root.pushToast({
                    appName: d[0],
                    icon: d[2],
                    summary: d[3],
                    body: d[4],
                    urgency: urgency
                })
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function open(): void { root.openMode("launcher") }
        function close(): void { root.closePinned() }
    }

    IpcHandler {
        target: "ask"
        function open(): void { root.openMode("ask") }
        function close(): void { root.closePinned() }
    }
}
