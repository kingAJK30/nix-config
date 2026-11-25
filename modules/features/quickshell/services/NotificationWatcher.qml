import QtQuick
import Quickshell.Services.Notifications

// Registers quickshell itself as the org.freedesktop.Notifications DBus
// service and turns each incoming Notification into a toast record for
// Dock. No external daemon involved (previously swaync).
//
// A toast record is: { appName: string, icon: string, summary: string,
// body: string, urgency: NotificationUrgency (Low/Normal/Critical) }.
// NotificationToast.qml is the other side of this contract.
//
// Notifications aren't tracked (root.tracked stays false) since Dock only
// ever shows them as a transient toast — there's no history/control-center
// list to keep them alive for.
Item {
    id: root

    signal notified(var toast)

    NotificationServer {
        id: server

        keepOnReload: false

        onNotification: notification => {
            root.notified({
                appName: notification.appName,
                icon: notification.appIcon,
                summary: notification.summary,
                body: notification.body,
                urgency: notification.urgency
            })
        }
    }
}
