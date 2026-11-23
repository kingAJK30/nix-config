import QtQuick

Item {
    id: root
    property alias text: label.text
    property color textColor: Theme.fg

    signal clicked(var mouse)
    signal scrolled(int delta)

    width: label.implicitWidth + 24
    height: parent ? parent.height : 0

    // left divider
    Rectangle {
        width: 1
        height: parent.height
        color: Theme.border
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: root.textColor
        font.family: Theme.font
        font.pointSize: Theme.fontSize
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.scrolled(wheel.angleDelta.y)
    }
}
