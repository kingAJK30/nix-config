pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string mode: "idle" // idle | toast | launcher | ask

    // The one explicit list of which modes pin to the focused screen and
    // suppress toast draining while open (see isActiveForScreen in
    // Center.qml) — toast is the only mode left out, since it's ambient
    // and shows on every screen.
    readonly property var pinnedModes: ["launcher", "ask"]
    readonly property bool pinned: pinnedModes.includes(mode)

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
            // mode flips first, which unmounts Center's Loader-held Toast
            // item; only then clear currentToast. Toast.qml's `toast` is a
            // live binding to currentToast, not a one-time snapshot — null
            // it while the item is still mounted and its own property
            // bindings (urgency, appName, ...) read through a null toast
            // for the instant before mode change unmounts it.
            root.mode = "idle"
            root.currentToast = null
            root.drain()
        }
    }

    NotificationWatcher {
        onNotified: toast => root.pushToast(toast)
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
