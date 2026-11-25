pragma Singleton
import QtQuick
import QtQml.Models
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string mode: "idle" // idle | toast | launcher | ask | session | control

    // The one registry of which modes exist, whether they pin to the
    // focused screen and suppress toast draining while open (see
    // isActiveFor below), and — via pinnedModes — which IPC targets get
    // wired up below. toast is deliberately absent: it's ambient, shows on
    // every screen, and is pushed internally rather than opened over IPC.
    readonly property var modes: ({
        launcher: { pinned: true },
        ask: { pinned: true },
        session: { pinned: true },
        control: { pinned: true }
    })
    readonly property var pinnedModes: Object.keys(root.modes).filter(m => root.modes[m].pinned)
    readonly property bool pinned: pinnedModes.includes(mode)

    // Name of the sway output that was focused at the moment a pinned mode
    // was requested, so only that monitor's Center expands to show it.
    property string activeScreenName: ""
    property string pendingMode: ""

    // Whether a pinned mode should render on the given screen — the one
    // place that combines pinned + activeScreenName, so callers (Center)
    // never have to know those two fields exist, let alone how they combine.
    function isActiveFor(screenName) {
        return root.pinned && root.activeScreenName === screenName
    }

    // The only two toast kinds that exist. Producers (Osd,
    // NotificationWatcher) never set this themselves — pushOsd/
    // pushNotification stamp it here, so there's one place defining what a
    // toast's kind can be instead of each producer and Center.qml agreeing
    // on a string by convention.
    readonly property var toastKinds: ({ osd: "osd", notification: "notification" })

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

    function pushNotification(toast) {
        toastQueue = toastQueue.concat([Object.assign({}, toast, { kind: root.toastKinds.notification })])
        drain()
    }

    // Hardware feedback (volume, caps lock) bypasses the queue entirely:
    // it replaces whatever toast is showing right now and restarts the
    // hide timer, so rapid repeats (scrolling volume) update live in place
    // instead of backing up a queue of 3-second toasts.
    function pushOsd(toast) {
        if (root.pinned) return
        showToast(Object.assign({}, toast, { kind: root.toastKinds.osd }))
    }

    function showToast(toast) {
        root.currentToast = toast
        root.mode = "toast"
        toastTimer.restart()
    }

    function drain() {
        if (root.pinned) return
        if (root.currentToast) return
        if (toastQueue.length === 0) {
            root.mode = "idle"
            return
        }
        const next = toastQueue[0]
        toastQueue = toastQueue.slice(1)
        showToast(next)
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
            // mode flips first, which unmounts Center's Loader-held toast
            // item; only then clear currentToast. NotificationToast/
            // OsdToast's `toast` is a live binding to currentToast, not a
            // one-time snapshot — null it while the item is still mounted
            // and its own property bindings (urgency, appName, ...) read
            // through a null toast for the instant before mode change
            // unmounts it.
            root.mode = "idle"
            root.currentToast = null
            root.drain()
        }
    }

    NotificationWatcher {
        onNotified: toast => root.pushNotification(toast)
    }

    // One IpcHandler per pinned mode, generated from the modes registry
    // above instead of hand-written per mode — a mode's IPC target is
    // always its own name, so adding a mode here means one new entry in
    // `modes`, not a new IpcHandler block to copy and rename.
    Instantiator {
        model: root.pinnedModes
        IpcHandler {
            target: modelData
            function open(): void { root.openMode(modelData) }
            function close(): void { root.closePinned() }
        }
    }
}
