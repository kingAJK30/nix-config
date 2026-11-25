pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import "../modules"

// Owns the Wayland session lock and all auth state. `locked` is the one
// source of truth — swayidle's idle/before-sleep/suspend hooks and the
// sway lock keybind all just flip it via the IpcHandler below, same
// convention as launcher/ask. `password` lives here too (not in
// LockSurface) so every screen's surface mirrors the same typed-length
// and failure state regardless of which one actually holds keyboard
// focus — only one surface gets real key events, but all of them read
// from this singleton to render. WlSessionLock creates one LockSurface
// per connected output itself; this singleton never touches per-screen
// instancing directly.
Singleton {
    id: root

    property bool locked: false
    property string password: ""
    property bool failed: false

    function appendChar(ch) {
        root.failed = false
        root.password += ch
    }

    function backspace() {
        root.password = root.password.slice(0, -1)
    }

    function clear() {
        root.password = ""
        root.failed = false
    }

    function submit() {
        if (root.password === "") return
        pam.start()
    }

    PamContext {
        id: pam
        config: "quickshell-lock"

        onPamMessage: {
            if (responseRequired) pam.respond(root.password)
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.password = ""
                root.locked = false
            } else {
                root.password = ""
                root.failed = true
            }
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: root.locked
        surface: Component { LockSurface {} }
    }

    IpcHandler {
        target: "lock"
        function lock(): void { root.locked = true }
        function unlock(): void { root.locked = false }
    }
}
