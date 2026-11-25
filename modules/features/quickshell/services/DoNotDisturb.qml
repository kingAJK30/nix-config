pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// DND is quickshell's own local flag now (previously mirrored from
// swaync's). The IpcHandler lets sway's mod+n bind it directly, since
// there's no Dock-pinned mode to piggyback on (DND is a toggle, not a
// dynamic-island mode).
Singleton {
    id: root

    property bool enabled: false

    function toggle() {
        root.enabled = !root.enabled
    }

    IpcHandler {
        target: "dnd"
        function toggle(): void {
            root.toggle()
        }
    }
}
