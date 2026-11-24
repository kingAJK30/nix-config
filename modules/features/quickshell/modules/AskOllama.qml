import QtQuick
import Quickshell.Io

Item {
    id: root

    function focusInput() { input.forceActiveFocus() }

    readonly property int maxResponseHeight: 160

    property string response: ""
    property bool streaming: false

    readonly property bool thinking: streaming && response === ""

    implicitWidth: 320
    implicitHeight: inputBox.height
        + (thinking ? 8 + 16 : 0)
        + (response !== "" ? 8 + Math.min(responseText.implicitHeight, maxResponseHeight) : 0)
        + 16

    function submit(question) {
        root.response = ""
        root.streaming = true
        proc.restart(["curl", "-N", "-s", "-X", "POST", "http://localhost:11434/api/generate",
            "-d", JSON.stringify({ model: OllamaConfig.model, prompt: question, stream: true })])
    }

    RestartableProcess {
        id: proc
        stdout: SplitParser {
            onRead: line => {
                let msg
                try { msg = JSON.parse(line) } catch (e) { return }
                root.response += msg.response ?? ""
                if (msg.done) root.streaming = false
            }
        }
    }

    Column {
        width: root.width
        spacing: 8

        Item {
            id: inputBox
            width: root.width
            height: 32

            TextInput {
                id: input
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.fg
                font.family: Theme.font
                font.pointSize: Theme.fontSize
                focus: true
                Component.onCompleted: forceActiveFocus()

                Keys.onReturnPressed: {
                    if (text !== "") root.submit(text)
                }
            }
        }

        Row {
            id: thinkingRow
            visible: root.thinking
            x: 10
            height: 16
            spacing: 5

            Repeater {
                model: 3

                Rectangle {
                    required property int index

                    width: 6
                    height: 6
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.accent

                    SequentialAnimation on height {
                        loops: Animation.Infinite
                        running: thinkingRow.visible
                        PauseAnimation { duration: index * 120 }
                        NumberAnimation { to: 16; duration: 220; easing.type: Easing.OutQuad }
                        NumberAnimation { to: 6; duration: 220; easing.type: Easing.InQuad }
                        PauseAnimation { duration: (2 - index) * 120 }
                    }
                }
            }
        }

        Flickable {
            visible: root.response !== ""
            width: root.width
            height: Math.min(responseText.implicitHeight, root.maxResponseHeight)
            contentWidth: width
            contentHeight: responseText.implicitHeight
            clip: true

            onContentHeightChanged: contentY = Math.max(0, contentHeight - height)

            ThemedText {
                id: responseText
                x: 10
                width: root.width - 20
                wrapMode: Text.WordWrap
                text: root.response
                color: Theme.fg
            }
        }
    }
}
