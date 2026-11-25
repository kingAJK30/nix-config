import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../components"
import "../services"

// Notification record shape: see services/NotificationWatcher.qml.
Item {
    id: root
    required property var toast

    // Read by Center.qml to tint the island's border for notification urgency.
    readonly property color borderColor: toast.urgency === NotificationUrgency.Critical ? Theme.red
        : toast.urgency === NotificationUrgency.Low ? Theme.dim
        : Theme.border

    readonly property int maxTextWidth: 360

    implicitWidth: row.implicitWidth + 24
    implicitHeight: row.implicitHeight + 16

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        IconImage {
            visible: root.toast.icon !== ""
            implicitSize: 20
            source: root.toast.icon ? Quickshell.iconPath(root.toast.icon, "") : ""
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            ThemedText {
                width: Math.min(implicitWidth, root.maxTextWidth)
                wrapMode: Text.WordWrap
                text: root.toast.appName + ": " + root.toast.summary
                color: Theme.fg
            }
            ThemedText {
                visible: root.toast.body !== ""
                width: Math.min(implicitWidth, root.maxTextWidth)
                wrapMode: Text.WordWrap
                text: root.toast.body
                color: Theme.dim
            }
        }
    }
}
