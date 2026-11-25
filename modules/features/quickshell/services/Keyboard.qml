pragma Singleton
import QtQuick
import Quickshell

// Polls the caps-lock LED state via sysfs rather than hooking a
// compositor-level key event (Quickshell has no such API, and sway/I3
// don't expose LED state over swaymsg). Globs /sys/class/leds instead of
// a fixed device path, since USB keyboards enumerate under a different
// input* index each time they're plugged in — same reasoning as the
// card*-globbing GPU lookup in Stats.qml.
Singleton {
    id: root

    property bool capsLock: false

    PolledShellValue {
        interval: 300
        pollCommand: ["sh", "-c",
            "for f in /sys/class/leds/*::capslock/brightness; do [ -r \"$f\" ] && cat \"$f\"; done | grep -q '^1$' && echo 1 || echo 0"
        ]
        onParsed: text => {
            const on = text.trim() === "1"
            if (on !== root.capsLock) {
                root.capsLock = on
                Osd.showCaps(on)
            }
        }
    }
}
