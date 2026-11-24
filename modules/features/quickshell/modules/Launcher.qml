import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    function focusInput() { input.forceActiveFocus() }

    readonly property var entries: {
        const all = DesktopEntries.applications.values.filter(e => !e.noDisplay)
        const q = input.text.toLowerCase()
        const filtered = q === "" ? all : all.filter(e =>
            e.name.toLowerCase().includes(q) || e.genericName.toLowerCase().includes(q))
        return filtered.slice(0, 8)
    }

    property int selected: 0
    onEntriesChanged: selected = 0

    readonly property int inset: 6

    implicitWidth: 280
    implicitHeight: inputBox.height + list.height + 8

    Column {
        width: root.width - root.inset * 2
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Item {
            id: inputBox
            width: parent.width
            height: 32

            TextInput {
                id: input
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.fg
                font.family: Theme.font
                font.pointSize: Theme.fontSize
                focus: true
                Component.onCompleted: forceActiveFocus()

                Keys.onDownPressed: root.selected = Math.min(root.selected + 1, root.entries.length - 1)
                Keys.onUpPressed: root.selected = Math.max(root.selected - 1, 0)
                Keys.onReturnPressed: {
                    if (root.entries[root.selected]) {
                        root.entries[root.selected].execute()
                        Dock.closePinned()
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.border
        }

        Column {
            id: list
            width: parent.width

            Repeater {
                model: root.entries

                Rectangle {
                    required property var modelData
                    required property int index

                    width: list.width
                    height: 28
                    color: index === root.selected ? Theme.surface : "transparent"

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        spacing: 8

                        IconImage {
                            implicitSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData.icon, "")
                        }

                        ThemedText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            color: Theme.fg
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            modelData.execute()
                            Dock.closePinned()
                        }
                    }
                }
            }
        }
    }
}
