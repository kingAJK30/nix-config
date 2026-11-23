import QtQuick
import Quickshell.Wayland

Item {
    id: root

    readonly property string title: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""

    height: parent ? parent.height : 0

    Rectangle {
        width: 1
        height: parent.height
        color: Theme.border
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        width: root.width - 24
        text: root.title
        elide: Text.ElideRight
        color: Theme.fg
        font.family: Theme.font
        font.pointSize: Theme.fontSize
    }
}
