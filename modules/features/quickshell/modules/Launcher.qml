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

            onDownPressed: list.moveDown()
            onUpPressed: list.moveUp()
            onAccepted: list.activateSelected()
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.border
        }

        SelectableList {
            id: list
            width: parent.width
            model: root.entries
            labelFor: e => e.name
            activate: e => { e.execute(); Dock.closePinned() }
        }
    }
}
