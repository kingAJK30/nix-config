import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias content: row.data

    property int padding: 12
    property bool dividerLeft: false
    property bool dividerRight: true
    property bool inverted: false

    readonly property color ink: inverted ? Colors.base00 : Colors.base05

    color: inverted ? Colors.base05 : "transparent"
    implicitWidth: row.implicitWidth + padding * 2
    Layout.fillHeight: true

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
    }

    Rectangle {
        visible: root.dividerLeft
        anchors.left: parent.left
        width: 1
        height: parent.height
        color: Colors.base05
    }

    Rectangle {
        visible: root.dividerRight
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: Colors.base05
    }
    signal scrolled(string direction)
    signal clicked()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: cell.clicked()

        onWheel: (wheel) => {
            let direction = wheel.angleDelta.y > 0 ? "prev" : "next";
            cell.scrolled(direction);
        }
    }
}
