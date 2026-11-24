import QtQuick
import Quickshell
import Quickshell.I3

Row {
    height: parent ? parent.height : 0

    Repeater {
        model: ScriptModel {
            values: I3.workspaces.values.slice().sort((a, b) => a.number - b.number)
        }

        Rectangle {
            id: ws
            required property var modelData

            width: label.implicitWidth + parent.height
            height: parent.height
            color: modelData.focused ? Theme.fg : "transparent"

            ThemedText {
                id: label
                anchors.centerIn: parent
                text: ws.modelData.name
                font.bold: ws.modelData.active
                color: ws.modelData.focused ? Theme.bg
                     : ws.modelData.urgent ? Theme.accent
                     : Theme.fg
            }

            MouseArea {
                anchors.fill: parent
                onClicked: ws.modelData.activate()
            }
        }
    }
}
