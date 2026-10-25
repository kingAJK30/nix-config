import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3

PanelWindow {
    id: root

    anchors { top: true; left: true; right: true }
    implicitHeight: 28
    color: Colors.base00

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: 1
        spacing: 0

        Repeater {
            model: I3.workspaces

            delegate: Cell {
                id: cell
                required property var modelData

                visible: modelData.monitor.name === root.screen.name

                inverted: modelData.focused
                color: modelData.urgent ? Colors.base08
                     : inverted ? Colors.base05
                     : "transparent"

                onClicked: modelData.activate()

                Text {
                    text: cell.modelData.number > 0 ? cell.modelData.number : cell.modelData.name
                    color: cell.ink
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        Item { Layout.fillWidth: true }

        Cell {
            id: clockCell
            dividerLeft: true
            dividerRight: false

            Text {
                text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm").toUpperCase()
                color: clockCell.ink
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Colors.base05
    }
}
