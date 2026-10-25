pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias base00: adapter.base00
    property alias base01: adapter.base01
    property alias base02: adapter.base02
    property alias base03: adapter.base03
    property alias base04: adapter.base04
    property alias base05: adapter.base05
    property alias base06: adapter.base06
    property alias base07: adapter.base07
    property alias base08: adapter.base08
    property alias base09: adapter.base09
    property alias base0A: adapter.base0A
    property alias base0B: adapter.base0B
    property alias base0C: adapter.base0C
    property alias base0D: adapter.base0D
    property alias base0E: adapter.base0E
    property alias base0F: adapter.base0F

    FileView {
        path: Quickshell.env("HOME") + "/.config/base16/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property string base00: "#282828"
            property string base01: "#3c3836"
            property string base02: "#504945"
            property string base03: "#665c54"
            property string base04: "#bdae93"
            property string base05: "#d5c4a1"
            property string base06: "#ebdbb2"
            property string base07: "#fbf1c7"
            property string base08: "#fb4934"
            property string base09: "#fe8019"
            property string base0A: "#fabd2f"
            property string base0B: "#b8bb26"
            property string base0C: "#8ec07c"
            property string base0D: "#83a598"
            property string base0E: "#d3869b"
            property string base0F: "#d65d0e"
        }
    }
}
