import QtQuick
import "../services"

// The dock itself: idle state shows the Equalizer in a slim row-height box;
// opening a mode grows this same Rectangle (one continuous border) to fit
// the loaded content, rather than a separate box appearing below it.
//
// This file carries two concerns at once — the tween/clip/pixel-snap
// geometry below, and the mode-resolution logic (isActiveForScreen,
// modeComponents) further down. They don't share much surface area; if a
// 5th/6th mode makes this file harder to scan, split geometry out first.
Rectangle {
    id: root
    required property var hostWindow

    readonly property int rowHeight: Theme.rowHeight

    // Pinned modes (launcher/ask) only expand on the monitor that was
    // focused when the IPC call came in; toasts are ambient and show on
    // every screen.
    readonly property bool isActiveForScreen: Dock.isActiveFor(hostWindow.screen.name)
    readonly property bool active: Dock.mode === "toast" || isActiveForScreen

    // width/height are routed through animWidth/animHeight (continuous,
    // can be fractional mid-tween) and rounded on the way out, so the
    // rectangle is always drawn at a whole-pixel size. Border rendering
    // pixel-snaps against the rectangle's current geometry every frame;
    // leaving that geometry fractional for the whole animation is what
    // made the bottom border edge flicker during a resize.
    property real animWidth: active && loader.item ? loader.item.implicitWidth + border.width * 2 : equalizer.width + 16
    property real animHeight: active && loader.item ? loader.item.implicitHeight + border.width * 2 : rowHeight
    width: Math.round(animWidth)
    height: Math.round(animHeight)

    antialiasing: true

    color: Theme.bg
    border.width: 1
    border.color: active && loader.item && loader.item.borderColor ? loader.item.borderColor : Theme.border

    // No overshoot here: unlike a one-shot open/close, this resizes
    // continuously while active (every keystroke in the launcher, every
    // streamed token in AskOllama), and overshoot compounding across rapid
    // small resizes is what reads as shaking rather than settling.
    Behavior on animWidth { NumberAnimation { duration: Theme.motionMacro; easing.type: Theme.snapEasing } }
    Behavior on animHeight { NumberAnimation { duration: Theme.motionMacro; easing.type: Theme.snapEasing } }
    Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }
    Behavior on border.color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }

    // Clipping lives on this inner wrapper, not on root: clip on a
    // Rectangle with a border clips right at the item edge, and the 1px
    // border stroke straddles that edge — so at non-integer intermediate
    // sizes mid-animation, the bottom border pixel gets clipped away and
    // flickers back once the animation lands on an integer size.
    Item {
        anchors.fill: parent
        anchors.margins: root.border.width
        clip: true

        Equalizer {
            id: equalizer
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 2
            paused: root.active
        }

        // Whatever this Loader holds is a "mode item": it must expose
        // implicitWidth/implicitHeight (read above for animWidth/
        // animHeight), may expose borderColor (read above for
        // border.color), and may expose focusInput() (called below on
        // load). Every mode component — NotificationToast, OsdToast,
        // Launcher, AskOllama, SessionMenu — satisfies this by convention;
        // nothing enforces it, so a new mode that forgets a member just
        // renders at size 0 with no error (see this folder's CLAUDE.md,
        // "Verifying").
        Loader {
            id: loader
            // Pinned to a fixed corner rather than anchors.centerIn: the
            // box's width/height already track this content's size almost
            // exactly, so centering gained nothing — and because the box
            // animates its size smoothly while content resizes in a step
            // (one more line, one more token), centerIn was recomputing
            // against the parent's still-mid-animation size every frame,
            // making content visibly jump before the border caught up.
            anchors.top: parent.top
            anchors.left: parent.left
            active: root.active
            sourceComponent: root.modeComponents[Dock.mode] ?? null
            onLoaded: if (item.focusInput) item.focusInput()
        }
    }

    Keys.onEscapePressed: Dock.closePinned()

    // One lookup table instead of a ternary chain, so a new mode is one
    // entry here (plus one in Dock.pinnedModes if it's pinned, not
    // ambient) rather than a new branch to remember to add. toast's entry
    // dispatches on Dock.currentToast.kind directly — notifications
    // (NotificationToast, see services/NotificationWatcher.qml) and
    // hardware OSD feedback (OsdToast, see services/Osd.qml) render as
    // unrelated shapes with unrelated record fields, so each is its own
    // component rather than one component branching on an isOsd flag.
    readonly property var modeComponents: ({
        toast: Dock.currentToast && Dock.currentToast.kind === Dock.toastKinds.osd ? osdToastComponent : notificationToastComponent,
        launcher: launcherComponent,
        ask: askComponent,
        session: sessionComponent,
        control: controlComponent
    })

    Component {
        id: notificationToastComponent
        NotificationToast { toast: Dock.currentToast }
    }

    Component {
        id: osdToastComponent
        OsdToast { toast: Dock.currentToast }
    }

    Component {
        id: launcherComponent
        Launcher {}
    }

    Component {
        id: askComponent
        AskOllama {}
    }

    Component {
        id: sessionComponent
        SessionMenu {}
    }

    Component {
        id: controlComponent
        ControlCenter {}
    }
}
