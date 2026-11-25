import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"
import "../services"

// One instance per output, created automatically by Lock.qml's
// WlSessionLock. Root must be a WlSessionLockSurface itself (Quickshell
// requirement) — see services/Lock.qml for the singleton that owns this
// and all auth/password state.
//
// Captures raw key events directly rather than using a TextInput: only
// one of these surfaces ever wins keyboard focus (same single-focus-
// window behavior as any other multi-window Qt app), but since every
// keystroke is forwarded straight to Lock's shared password state, the
// other screen's surface still mirrors it exactly through the same
// property bindings — no local per-surface text buffer to fall out of
// sync.
WlSessionLockSurface {
    id: root
    // Matches the scrim below rather than Theme.bg so there's no flash of
    // a mismatched color while the wallpaper decodes (it's a local file,
    // so loading it synchronously keeps that window imperceptible too).
    color: "black"

    // Same wallpaper Stylix set for the desktop, darkened with a flat
    // scrim so the lock state reads at a glance without a separate asset.
    Image {
        anchors.fill: parent
        source: "file://" + Theme.wallpaper
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.45
    }

    // root is a WlSessionLockSurface, not a QQuickItem (its real Item is
    // the separate contentItem it backs) — Keys and forceActiveFocus only
    // work on an actual Item, so focus/key handling lives on this one.
    Item {
        id: input
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                Lock.submit()
            } else if (event.key === Qt.Key_Backspace) {
                Lock.backspace()
            } else if (event.key === Qt.Key_Escape) {
                Lock.clear()
            } else if (event.text.length === 1) {
                Lock.appendChar(event.text)
            }
            event.accepted = true
        }

        Component.onCompleted: input.forceActiveFocus()
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Theme.fg/dim/border are tuned for Stylix's current polarity against
    // Theme.bg (dark text on a light bg, here) — that assumption breaks
    // against an arbitrary photo + scrim, which is dark regardless of
    // polarity. Everything in this column is pinned to fixed light values
    // instead so it stays readable no matter what the wallpaper is.
    Column {
        anchors.centerIn: parent
        spacing: 24

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: Theme.fontSize * 4
            color: "white"
            text: Qt.formatDateTime(clock.date, "HH:mm")
        }

        Rectangle {
            id: field
            anchors.horizontalCenter: parent.horizontalCenter
            width: 220
            height: Theme.rowHeight
            color: Qt.rgba(1, 1, 1, 0.1)
            border.width: 1
            border.color: Lock.failed ? Theme.red : Qt.rgba(1, 1, 1, 0.6)

            Behavior on border.color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }

            ThemedText {
                anchors.centerIn: parent
                color: Lock.failed ? Theme.red : "white"
                text: "*".repeat(Lock.password.length)

                Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }
            }
        }

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Lock.failed ? Theme.red : Qt.rgba(1, 1, 1, 0.7)
            text: Lock.failed ? "WRONG PASSWORD" : "ENTER TO UNLOCK"
        }
    }
}
