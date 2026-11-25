import QtQuick
import "../components"
import "../services"

// Loaded into Center's island as the "control" mode. Bluetooth, DoNotDisturb,
// and VolumeControl each own their own state (services/*.qml) — this file
// only renders a row per toggle and dispatches its action.
//
// rows is a fixed array of row descriptors, not a per-row data array
// rebuilt on every singleton tick: SelectableList's Repeater keys its
// delegates off model identity, so swapping in a whole new array of
// objects every time any one service polls (every ~1.5s, more with rapid
// toggles) would tear down and recreate all 4 delegates at once — visible
// as a garbled, slow-to-settle repaint. This array's identity is stable
// across polls (its own binding has no polled dependency — only the
// closures it holds read live state when called), so only the one Text
// binding that actually changed re-evaluates. Each row also carries its
// own optional left/right handlers, so which row responds to Left/Right
// is never a positional assumption (e.g. "volume is last").
Item {
    id: root

    readonly property var rows: [
        {
            label: "Bluetooth",
            status: () => Bluetooth.powered ? (Bluetooth.connectedDevice || "ON") : "OFF",
            activate: () => Bluetooth.toggle()
        },
        {
            label: "Mic",
            status: () => VolumeControl.micMuted ? "MUTED" : "ON",
            activate: () => VolumeControl.toggleMicMute()
        },
        {
            label: "Do Not Disturb",
            status: () => DoNotDisturb.enabled ? "ON" : "OFF",
            activate: () => DoNotDisturb.toggle()
        },
        {
            label: "Volume",
            status: () => VolumeControl.muted ? "MUTED" : Math.round(VolumeControl.volume * 100) + "%",
            activate: () => VolumeControl.toggleMute(),
            left: () => VolumeControl.adjustVolume(-0.05),
            right: () => VolumeControl.adjustVolume(0.05)
        }
    ]

    function focusInput() { root.forceActiveFocus() }

    implicitWidth: 240
    implicitHeight: list.implicitHeight + 12

    Keys.onUpPressed: list.moveUp()
    Keys.onDownPressed: list.moveDown()
    Keys.onReturnPressed: list.activateSelected()
    Keys.onLeftPressed: root.rows[list.selected].left?.()
    Keys.onRightPressed: root.rows[list.selected].right?.()

    SelectableList {
        id: list
        y: 6
        width: parent.width
        model: root.rows
        labelFor: r => r.label
        statusFor: r => r.status()
        activate: r => r.activate()
    }
}
