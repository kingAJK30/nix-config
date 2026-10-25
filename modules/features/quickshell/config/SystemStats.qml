pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string cpu: "--%"
    property string ram: "--%"
    property string vram: "--%"
    property string audio: "--%"

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: refreshAll()
    }

    function refreshAll() {
        cpuProc.running = true;
        ramProc.running = true;
        vramProc.running = true;
        audioProc.running = true;
    }

    function adjustVolume(step) {
        setVolProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", step, "-l", "1.0"];
        setVolProc.running = true;
    }

    function toggleMute() {
        muteProc.running = true;
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "vmstat 1 2 | tail -1 | awk '{print 100 - $15 \"%\"}'"]
        stdout: StdioCollector { onStreamFinished: root.cpu = text.trim() }
    }

    Process {
        id: ramProc
        command: ["sh", "-c", "free | grep Mem | awk '{print int($3/$2 * 100)}'"]
        stdout: StdioCollector { onStreamFinished: root.ram = text.trim() + "%" }
    }

    Process {
        id: vramProc
        command: ["sh", "-c", "for c in /sys/class/drm/card*; do if [ -f \"$c/device/mem_info_vram_used\" ]; then u=$(cat \"$c/device/mem_info_vram_used\"); t=$(cat \"$c/device/mem_info_vram_total\"); [ \"$t\" -gt 0 ] && echo $((u * 100 / t))% && exit; fi; done; echo \"--%\""]
        stdout: StdioCollector { onStreamFinished: root.vram = text.trim() }
    }

    Process {
        id: audioProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '/[MUTED]/ {print \"MUTED\"; exit} {vol = int($2 * 100); if (vol <= 0) print \"MUTED\"; else print vol \"%\"}'"]
        stdout: StdioCollector { onStreamFinished: root.audio = text.trim() }
    }

    Process {
        id: setVolProc
        onExited: audioProc.running = true
    }

    Process {
        id: muteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: audioProc.running = true
    }
}
