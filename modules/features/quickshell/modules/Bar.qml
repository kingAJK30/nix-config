import QtQuick
import Quickshell
import Quickshell.Wayland
import "../services"

PanelWindow {
    id: win

    required property var modelData
    screen: modelData

    readonly property real sideWidth: Math.max(left.naturalWidth, right.naturalWidth)
    readonly property int rowHeight: Theme.rowHeight

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

    // The window's visible height grows to fit the dock's expanded content,
    // but exclusiveZone stays pinned to the slim row height, so windows
    // below never get pushed down by the expansion - it just floats over
    // them.
    implicitHeight: Math.max(rowHeight, center.height)
    exclusiveZone: rowHeight
    color: "transparent"

    WlrLayershell.keyboardFocus: center.isActiveForScreen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    mask: Region {
        Region { item: left }
        Region { item: center }
        Region { item: right }
    }

    Left {
        id: left
        height: win.rowHeight
        anchors.top: parent.top
        anchors.left: parent.left
        minWidth: win.sideWidth
    }

    Center {
        id: center
        hostWindow: win
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Right {
        id: right
        hostWindow: win
        height: win.rowHeight
        anchors.top: parent.top
        anchors.right: parent.right
        minWidth: win.sideWidth
    }
}
