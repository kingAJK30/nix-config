import QtQuick
import Quickshell.Wayland
import "../components"
import "../services"

BarItem {
    id: root

    readonly property string title: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""

    ThemedText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        width: root.width - 24
        text: root.title
        elide: Text.ElideRight
        color: Theme.fg
    }
}
