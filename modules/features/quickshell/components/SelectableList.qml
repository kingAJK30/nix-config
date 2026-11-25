import QtQuick
import "../services"

// Repeats `model`, highlighting the current selection and calling
// `activate(item)` on click or activateSelected(). Shared row look +
// keyboard-nav behavior for any pinned-mode list (Launcher's filtered
// desktop entries, SessionMenu's fixed actions, ControlCenter's toggles,
// ...) — callers only supply the model, how to label an item, an optional
// right-aligned status string, and what activating one does. Owning
// `selected` and its up/down clamp here means a caller can never key the
// clamp bound off the wrong length or forget to reset it when the model
// changes.
Column {
    id: root
    required property var model
    required property var labelFor
    required property var activate
    property var statusFor: null
    property int selected: 0

    onModelChanged: root.selected = 0

    function moveUp() { root.selected = Math.max(root.selected - 1, 0) }
    function moveDown() { root.selected = Math.min(root.selected + 1, root.model.length - 1) }
    function activateSelected() {
        const item = root.model[root.selected]
        if (item !== undefined) root.activate(item)
    }

    Repeater {
        model: root.model

        Rectangle {
            required property var modelData
            required property int index

            width: root.width
            height: 28
            color: index === root.selected ? Theme.surface : "transparent"

            Behavior on color { ColorAnimation { duration: Theme.motionMicro; easing.type: Theme.snapEasing } }

            ThemedText {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                // Fixed-width status column (not statusLabel.left) so this
                // anchor target never moves when the status text itself
                // changes — e.g. "ON" -> "OFF" while the row stays mounted.
                // Anchoring to a sibling whose own width tracks its text
                // content made both texts re-layout/re-elide together on
                // every status change, which could visibly glitch mid-frame.
                anchors.right: root.statusFor ? statusLabel.left : parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: root.labelFor(modelData)
                color: Theme.fg
                elide: Text.ElideRight
            }

            ThemedText {
                id: statusLabel
                visible: !!root.statusFor
                width: 70
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: visible ? root.statusFor(modelData) : ""
                color: Theme.dim
                elide: Text.ElideRight
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.activate(modelData)
            }
        }
    }
}
