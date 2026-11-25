pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// The one Pipewire adapter for system volume and mic mute, so every caller
// (the bar's Volume widget, ControlCenter) shares the same sink/source
// tracking and the same Osd feedback path — see Osd.showVolume.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.audio ? sink.audio.volume : 0
    readonly property bool muted: sink?.audio ? sink.audio.muted : false
    readonly property bool micMuted: source?.audio ? source.audio.muted : false

    onVolumeChanged: Osd.showVolume(volume, muted)
    onMutedChanged: Osd.showVolume(volume, muted)

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    function toggleMute() {
        if (root.sink?.audio) root.sink.audio.muted = !root.sink.audio.muted
    }

    function toggleMicMute() {
        if (root.source?.audio) root.source.audio.muted = !root.source.audio.muted
    }

    function adjustVolume(delta) {
        if (!root.sink?.audio) return
        root.sink.audio.muted = false
        root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + delta))
    }
}
