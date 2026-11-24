pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpu: 0
    property real ramUsedGb: 0
    property int gpu: 0
    property real vramUsedGb: 0
    property real vramTotalGb: 0

    property bool hasGpu: false
    property string gpuPath: ""
    property real prevTotal: 0
    property real prevIdle: 0

    function parseCpu(t) {
        const f = t.split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
        const idle = f[3] + f[4]
        const total = f.slice(0, 8).reduce((a, b) => a + b, 0)
        if (prevTotal > 0) {
            const dt = total - prevTotal
            const di = idle - prevIdle
            cpu = dt > 0 ? Math.round(100 * (dt - di) / dt) : 0
        }
        prevTotal = total
        prevIdle = idle
    }

    function parseMem(t) {
        const m = {}
        for (const line of t.split("\n")) {
            const p = line.split(/:\s+/)
            if (p.length === 2) m[p[0]] = parseInt(p[1])
        }
        ramUsedGb = (m.MemTotal - m.MemAvailable) / 1048576
    }

    Process {
        running: true
        command: ["sh", "-c",
            "for d in /sys/class/drm/card*/device; do [ -r $d/mem_info_vram_total ] || continue; echo \"$(cat $d/mem_info_vram_total) $d\"; done | sort -n | tail -n1 | cut -d' ' -f2"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                root.gpuPath = text.trim()
                root.hasGpu = root.gpuPath !== ""
            }
        }
    }

    FileView { id: statFile; path: "/proc/stat"; blockLoading: true }
    FileView { id: memFile; path: "/proc/meminfo"; blockLoading: true }
    FileView {
        id: busyFile
        path: root.gpuPath ? root.gpuPath + "/gpu_busy_percent" : ""
        blockLoading: true
    }
    FileView {
        id: vramUsedFile
        path: root.gpuPath ? root.gpuPath + "/mem_info_vram_used" : ""
        blockLoading: true
    }
    FileView {
        id: vramTotalFile
        path: root.gpuPath ? root.gpuPath + "/mem_info_vram_total" : ""
        blockLoading: true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statFile.reload()
            root.parseCpu(statFile.text())
            memFile.reload()
            root.parseMem(memFile.text())

            if (root.gpuPath !== "") {
                busyFile.reload()
                vramUsedFile.reload()
                vramTotalFile.reload()
                root.gpu = parseInt(busyFile.text())
                root.vramUsedGb = parseInt(vramUsedFile.text()) / 1073741824
                root.vramTotalGb = parseInt(vramTotalFile.text()) / 1073741824
            }
        }
    }
}
