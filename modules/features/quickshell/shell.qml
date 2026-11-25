//@ pragma UseQApplication
import QtQuick
import Quickshell
import "modules"
import "services"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}
    }

    // Keyboard's capslock poll and Lock's WlSessionLock are both
    // singletons with their own lifecycle — referencing them here just
    // forces them to load at startup instead of lazily on first use.
    Component.onCompleted: {
        Keyboard.capsLock
        Lock.locked
    }
}
