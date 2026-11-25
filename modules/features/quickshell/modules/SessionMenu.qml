import QtQuick
import Quickshell
import "../components"
import "../services"

// Loaded into Center's island as the "session" mode — same row-list +
// keyboard-nav shape as Launcher.qml, just a fixed action list instead of
// a filtered DesktopEntries search.
Item {
    id: root

    readonly property var actions: [
        { label: "Lock", run: () => { Lock.locked = true } },
        { label: "Logout", run: () => Quickshell.execDetached(["swaymsg", "exit"]) },
        { label: "Suspend", run: () => Quickshell.execDetached(["systemctl", "suspend"]) },
        { label: "Reboot", run: () => Quickshell.execDetached(["systemctl", "reboot"]) },
        { label: "Shutdown", run: () => Quickshell.execDetached(["systemctl", "poweroff"]) }
    ]

    function focusInput() { root.forceActiveFocus() }

    function runAction(action) {
        action.run()
        Dock.closePinned()
    }

    implicitWidth: 180
    implicitHeight: list.implicitHeight + 12

    Keys.onUpPressed: list.moveUp()
    Keys.onDownPressed: list.moveDown()
    Keys.onReturnPressed: list.activateSelected()

    SelectableList {
        id: list
        y: 6
        width: parent.width
        model: root.actions
        labelFor: a => a.label
        activate: a => root.runAction(a)
    }
}
