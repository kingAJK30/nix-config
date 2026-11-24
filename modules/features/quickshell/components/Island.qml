import QtQuick
import "../services"

Rectangle {
    id: root
    default property alias content: row.data

    property real naturalWidth: row.implicitWidth + 1
    property real minWidth: 0

    visible: row.implicitWidth > 0
    width: Math.max(naturalWidth, minWidth)
    height: parent ? parent.height : 0
    color: Theme.bg
    border.width: 1
    border.color: Theme.border

    Row {
        id: row
        y: 1
        height: root.height - 2
    }
}
