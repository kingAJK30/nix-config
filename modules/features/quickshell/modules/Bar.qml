import QtQuick
import Quickshell

PanelWindow {
    id: win

    readonly property real sideWidth: Math.max(left.naturalWidth, right.naturalWidth)

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 2
        left: 2
        right: 2
    }
    implicitHeight: 32
    color: "transparent"

    mask: Region {
        Region { item: left }
        Region { item: center }
        Region { item: right }
    }

    Left {
        id: left
        anchors.left: parent.left
        minWidth: win.sideWidth
    }

    Center {
        id: center
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Right {
        id: right
        hostWindow: win
        anchors.right: parent.right
        minWidth: win.sideWidth
    }
}
