import QtQuick

Island {
    id: root
    required property var hostWindow

    Tray { hostWindow: root.hostWindow }
    Volume {}
    BarText { text: "CPU " + Stats.cpu + "%" }
    BarText { text: "RAM " + Stats.ramUsedGb.toFixed(1) + "G" }
    BarText {
        visible: Stats.hasGpu
        text: "GPU " + Stats.gpu + "% " + Stats.vramUsedGb.toFixed(1) + "/" + Math.round(Stats.vramTotalGb) + "G"
    }
    Clock {}
}
