import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root
    required property var hostWindow

    visible: SystemTray.items.values.length > 0
    width: visible ? row.implicitWidth + 24 : 0
    height: parent ? parent.height : 0

    // left divider
    Rectangle {
        width: 1
        height: parent.height
        color: Theme.border
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: SystemTray.items

            Image {
                id: icon
                required property var modelData

                width: 18
                height: 18
                source: modelData.icon
                sourceSize: Qt.size(36, 36)
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.MiddleButton) {
                            icon.modelData.secondaryActivate()
                        } else if (mouse.button === Qt.RightButton || icon.modelData.onlyMenu) {
                            if (icon.modelData.hasMenu) {
                                const p = icon.mapToItem(null, 0, icon.height)
                                icon.modelData.display(root.hostWindow, p.x, p.y)
                            }
                        } else {
                            icon.modelData.activate()
                        }
                    }
                }
            }
        }
    }
}
