import QtQuick
import "../services"

BarItem {
    id: root
    property alias text: label.text
    property color textColor: Theme.fg

    signal clicked(var mouse)
    signal scrolled(int delta)

    width: label.implicitWidth + 24

    ThemedText {
        id: label
        anchors.centerIn: parent
        color: root.textColor
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.scrolled(wheel.angleDelta.y)
    }
}
