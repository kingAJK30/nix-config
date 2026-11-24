import QtQuick
import Quickshell
import "../components"
import "../services"

Item {
    id: root

    function focusInput() { search.focusInput() }

    readonly property var entries: {
        const all = DesktopEntries.applications.values.filter(e => !e.noDisplay)
        const q = search.text.toLowerCase()
        const filtered = q === "" ? all : all.filter(e =>
            e.name.toLowerCase().includes(q) || e.genericName.toLowerCase().includes(q))
        return filtered.slice(0, 8)
    }

    property int selected: 0
    onEntriesChanged: selected = 0

    readonly property int inset: 6

    implicitWidth: 280
    implicitHeight: column.implicitHeight + root.inset * 2

    Column {
        id: column
        width: root.width - root.inset * 2
        anchors.top: parent.top
        anchors.topMargin: root.inset
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        SearchInput {
            id: search
            width: parent.width

            onDownPressed: root.selected = Math.min(root.selected + 1, root.entries.length - 1)
            onUpPressed: root.selected = Math.max(root.selected - 1, 0)
            onAccepted: {
                if (root.entries[root.selected]) {
                    root.entries[root.selected].execute()
                    Dock.closePinned()
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

                    Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }

                    ThemedText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        text: modelData.name
                        color: Theme.fg
                        elide: Text.ElideRight
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
