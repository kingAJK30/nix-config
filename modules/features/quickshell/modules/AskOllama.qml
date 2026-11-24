import QtQuick
import Quickshell.Io
import "../components"
import "../services"

Item {
    id: root

    function focusInput() { search.focusInput() }

    readonly property int maxResponseHeight: 160

    property string response: ""
    property bool streaming: false

    readonly property bool thinking: streaming && response === ""

    implicitWidth: 320
    implicitHeight: search.implicitHeight
        + (thinking ? 8 + thinkingRow.implicitHeight : 0)
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

        SearchInput {
            id: search
            width: root.width
            onAccepted: if (text !== "") root.submit(text)
        }

        Row {
            id: thinkingRow
            visible: root.thinking
            x: 10
            spacing: 4

            Repeater {
                model: 3

                ThemedText {
                    id: dot
                    required property int index
                    property real level: 0

                    text: Theme.rampChar(level)
                    color: Theme.fg

                    SequentialAnimation on level {
                        loops: Animation.Infinite
                        running: thinkingRow.visible
                        PauseAnimation { duration: dot.index * 120 }
                        NumberAnimation { to: 1; duration: Theme.motionMacro; easing.type: Theme.snapEasing }
                        NumberAnimation { to: 0; duration: Theme.motionMacro; easing.type: Theme.snapEasing }
                        PauseAnimation { duration: (2 - dot.index) * 120 }
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
