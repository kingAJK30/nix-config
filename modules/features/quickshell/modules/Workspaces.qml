import QtQuick
import Quickshell
import Quickshell.I3
import "../components"
import "../services"

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

            Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }

            ThemedText {
                id: label
                anchors.centerIn: parent
                text: ws.modelData.name
                font.bold: ws.modelData.active
                color: ws.modelData.focused ? Theme.bg
                     : ws.modelData.urgent ? Theme.accent
                     : Theme.fg

                Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: ws.modelData.activate()
            }
        }
    }
}
