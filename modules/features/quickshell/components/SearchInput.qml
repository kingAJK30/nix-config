import QtQuick
import "../services"

// Shared text-entry row for dock panels (Launcher, AskOllama): same
// styling and focus-stealing behavior, exposed as accepted/upPressed/
// downPressed signals so each caller wires only the keys it needs.
Item {
    id: root

    property alias text: input.text

    signal accepted()
    signal upPressed()
    signal downPressed()

    function focusInput() { input.forceActiveFocus() }

    implicitHeight: Math.max(32, input.implicitHeight)

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 7
        // AlignTop, not AlignVCenter: vertical centering re-centers around
        // the box's current height, so the first line visibly shifts up
        // the moment a second line appears. Anchoring to a fixed top
        // margin keeps the first line pinned and lets wrapped lines grow
        // downward only.
        verticalAlignment: TextInput.AlignTop
        wrapMode: TextInput.Wrap
        // autoScroll keeps the cursor in view by panning internally, which
        // does a one-time jump the first time a line wraps. Nothing here
        // ever clips this field (its container grows to fit), so there's
        // never anything to scroll to reveal.
        autoScroll: false
        color: Theme.fg
        font.family: Theme.font
        font.pointSize: Theme.fontSize
        focus: true
        Component.onCompleted: forceActiveFocus()

        Keys.onReturnPressed: root.accepted()
        Keys.onUpPressed: root.upPressed()
        Keys.onDownPressed: root.downPressed()
    }
}
