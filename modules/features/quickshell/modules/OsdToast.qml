import QtQuick
import "../components"
import "../services"

// OSD record shape: see services/Osd.qml.
Item {
    id: root
    required property var toast

    // Read by Center.qml to tint the island's border. OSD feedback has no
    // urgency concept, so this is just the neutral default.
    readonly property color borderColor: Theme.border

    implicitWidth: label.implicitWidth + 24
    implicitHeight: label.implicitHeight + 16

    function volumeBar(v) {
        let s = ""
        for (let i = 0; i < 10; i++) s += Theme.rampChar(v > i / 10 ? 1 : 0)
        return s
    }

    ThemedText {
        id: label
        anchors.centerIn: parent
        color: Theme.fg
        text: root.toast.osdType === "volume"
            ? (root.toast.muted ? "VOL MUTED" : "VOL " + root.volumeBar(root.toast.value) + " " + Math.round(root.toast.value * 100) + "%")
            : "CAPS LOCK " + (root.toast.value > 0 ? "ON" : "OFF")
    }
}
