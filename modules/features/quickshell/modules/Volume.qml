import Quickshell
import Quickshell.Services.Pipewire

BarText {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio ? sink.audio.volume : 0
    readonly property bool muted: sink?.audio ? sink.audio.muted : false

    PwObjectTracker {
        objects: [root.sink]
    }

    text: muted ? "VOL MUTED" : "VOL " + Math.round(volume * 100) + "%"

    onClicked: mouse => {
        if (!sink?.audio) return
        if (mouse.button === Qt.RightButton)
            Quickshell.execDetached(["pavucontrol"])
        else
            sink.audio.muted = !sink.audio.muted
    }

    onScrolled: delta => {
        if (!sink?.audio) return
        sink.audio.muted = false
        sink.audio.volume = Math.max(0, Math.min(1, volume + (delta > 0 ? 0.05 : -0.05)))
    }
}
