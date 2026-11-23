import Quickshell
import QtQuick

FloatingWindow {
  visible: true
  width: 200
  height: 100

  Text {
    anchors.centerIn: parent
    text: "Hello, World!"
    font.pixelSize: 18
  }
}
