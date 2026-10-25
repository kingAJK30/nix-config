import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    anchors { top: true; left: true; right: true }
    implicitHeight: 28
    color: Colors.base00

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    property var activePlayer: {
        for (let i = 0; i < Mpris.players.values.length; i++) {
            let p = Mpris.players.values[i];
            if (p.playbackState === MprisPlaybackState.Playing || p.trackTitle)
                return p;
        }
        return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
    }

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: 1
        spacing: 0

        Repeater {
            model: I3.workspaces

            delegate: Cell {
                id: cell
                required property var modelData

                visible: modelData.monitor.name === root.screen.name
                inverted: modelData.focused
                color: modelData.urgent ? Colors.base08
                       : inverted ? Colors.base05
                       : "transparent"

                onClicked: modelData.activate()

                Text {
                    text: cell.modelData.number > 0 ? cell.modelData.number : cell.modelData.name
                    color: cell.ink
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        // Media
        Cell {
            id: mediaCell
            visible: root.activePlayer && root.activePlayer.trackTitle.length > 0
            dividerLeft: false 
            dividerRight: true
            
            onClicked: {
                if (root.activePlayer) root.activePlayer.togglePlaying();
            }
            
            Text {
                text: root.activePlayer && root.activePlayer.playbackState === MprisPlaybackState.Playing ? "PLAYING" : "PAUSED"
                font.family: "JetBrainsMono Nerd Font"
            }
            
            Text {
                text: "·"
                color: Colors.base03
                font.family: "JetBrainsMono Nerd Font"
            }
            
            Text {
                text: root.activePlayer ? (root.activePlayer.trackArtist + " - " + root.activePlayer.trackTitle) : ""
                font.family: "JetBrainsMono Nerd Font"
                elide: Text.ElideRight
                Layout.maximumWidth: 250
            }
        }

        Item { Layout.fillWidth: true }

        // CPU
        Cell {
            id: cpuCell
            dividerLeft: true

            Text { text: "CPU"; color: cpuCell.ink; font.family: "JetBrainsMono Nerd Font" }
            Text { text: SystemStats.cpu; color: cpuCell.ink; font.family: "JetBrainsMono Nerd Font" }
        }

        // RAM
        Cell {
            id: ramCell

            Text { text: "RAM"; color: ramCell.ink; font.family: "JetBrainsMono Nerd Font" }
            Text { text: SystemStats.ram; color: ramCell.ink; font.family: "JetBrainsMono Nerd Font" }
        }

        // VRAM
        Cell {
            id: vramCell
            dividerLeft: false

            Text { text: "VRAM"; color: vramCell.ink; font.family: "JetBrainsMono Nerd Font" }
            Text { text: SystemStats.vram; color: vramCell.ink; font.family: "JetBrainsMono Nerd Font" }
        }

        // Audio
        Cell {
            id: audioCell
            dividerLeft: false
            dividerRight: false

            onClicked: SystemStats.toggleMute()

            MouseArea {
                anchors.fill: parent
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) {
                        SystemStats.adjustVolume("2%+");
                    } else if (wheel.angleDelta.y < 0) {
                        SystemStats.adjustVolume("2%-");
                    }
                }
            }

            Text { text: "VOL"; color: audioCell.ink; font.family: "JetBrainsMono Nerd Font" }
            Text { text: SystemStats.audio; color: audioCell.ink; font.family: "JetBrainsMono Nerd Font" }
        }

        // Clock
        Cell {
            id: clockCell
            dividerLeft: true
            dividerRight: false

            Text {
                text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm").toUpperCase()
                color: clockCell.ink
                font.family: "JetBrainsMono Nerd Font"
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Colors.base05
    }
}
