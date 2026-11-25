pragma Singleton
import QtQuick
import Quickshell

// swaync's do-not-disturb flag, polled via `swaync-client` — swaync stays
// the real notification daemon (see NotificationWatcher.qml), this only
// mirrors and toggles its dnd state.
Singleton {
    id: root

    property bool enabled: false

    function toggle() {
        poller.mutate(["swaync-client", "--toggle-dnd"])
    }

    PolledShellValue {
        id: poller
        interval: 1500
        pollCommand: ["swaync-client", "--get-dnd"]
        onParsed: text => root.enabled = text.trim() === "true"
    }
}
