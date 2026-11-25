import Quickshell
import "../components"
import "../services"

BarText {
    id: root

    text: VolumeControl.muted ? "VOL MUTED" : "VOL " + Math.round(VolumeControl.volume * 100) + "%"

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton)
            Quickshell.execDetached(["pavucontrol"])
        else
            VolumeControl.toggleMute()
    }

    onScrolled: delta => VolumeControl.adjustVolume(delta > 0 ? 0.05 : -0.05)
}
