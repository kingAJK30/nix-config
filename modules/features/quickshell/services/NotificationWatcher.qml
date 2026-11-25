import QtQuick
import Quickshell
import Quickshell.Io

// Translates the DBus notification wire format into toast records for
// Dock. swaync stays the real notification daemon/control-center; this
// only listens in via `busctl --user monitor` to mirror notifications
// into the dock's own toast style, suppressing swaync's own popup each
// time via swaync-client.
//
// A toast record is: { appName: string, icon: string, summary: string,
// body: string, urgency: int (0 low, 1 normal, 2 critical) }.
// NotificationToast.qml is the other side of this contract.
Item {
    id: root

    signal notified(var toast)

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
                root.notified({
                    appName: d[0],
                    icon: d[2],
                    summary: d[3],
                    body: d[4],
                    urgency: urgency
                })
            }
        }
    }
}
