import QtQuick

// The dock itself: idle state shows the Equalizer in a slim row-height box;
// opening a mode grows this same Rectangle (one continuous border) to fit
// the loaded content, rather than a separate box appearing below it.
Rectangle {
    id: root
    required property var hostWindow

    readonly property int rowHeight: 32

    // Pinned modes (launcher/ask) only expand on the monitor that was
    // focused when the IPC call came in (Dock.activeScreenName); toasts are
    // ambient and show on every screen.
    readonly property bool isActiveForScreen: Dock.pinned && Dock.activeScreenName === hostWindow.screen.name
    readonly property bool active: Dock.mode === "toast" || isActiveForScreen

    width: active && loader.item ? loader.item.implicitWidth + 2 : equalizer.width + 16
    height: active && loader.item ? loader.item.implicitHeight + 2 : rowHeight

    color: Theme.bg
    border.width: 1
    border.color: active && loader.item && loader.item.borderColor ? loader.item.borderColor : Theme.border

    Behavior on width { NumberAnimation { duration: 120 } }
    Behavior on height { NumberAnimation { duration: 120 } }

    Equalizer {
        id: equalizer
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 2
        paused: root.active
    }

    Loader {
        id: loader
        anchors.centerIn: parent
        active: root.active
        sourceComponent: Dock.mode === "toast" ? toastComponent
                        : Dock.mode === "launcher" ? launcherComponent
                        : Dock.mode === "ask" ? askComponent
                        : null
        onLoaded: if (item.focusInput) item.focusInput()
    }

    Keys.onEscapePressed: Dock.closePinned()

    Component {
        id: toastComponent
        Toast { toast: Dock.currentToast }
    }

    Component {
        id: launcherComponent
        Launcher {}
    }

    Component {
        id: askComponent
        AskOllama {}
    }
}
