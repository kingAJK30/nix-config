import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: root
    required property var toast

    // Read by CenterOverlay to tint the island's border for notification urgency.
    readonly property color borderColor: toast.urgency === 2 ? Theme.red
        : toast.urgency === 0 ? Theme.dim
        : Theme.border

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
                text: root.toast.appName + ": " + root.toast.summary
                color: Theme.fg
            }
            ThemedText {
                visible: root.toast.body !== ""
                text: root.toast.body
                color: Theme.dim
            }
        }
    }
}
