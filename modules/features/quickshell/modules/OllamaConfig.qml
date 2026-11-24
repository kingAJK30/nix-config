pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property string model: adapter.model

    FileView {
        path: Qt.resolvedUrl("../ask.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter
            property string model: "qwen3:8b"
        }
    }
}
