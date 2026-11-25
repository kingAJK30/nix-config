pragma Singleton
import QtQuick
import Quickshell

// Translates transient hardware feedback (volume, caps lock) into toast
// records for Dock, so this feedback comes out of the dynamic island like
// every other toast instead of a separate floating overlay. Dock.pushOsd
// stamps the kind (Dock.toastKinds.osd) — OsdToast.qml is the other side
// of that contract.
//
// Full trace for "why did/didn't a volume or caps toast show up", since it
// otherwise takes bouncing through 5 files to answer: a trigger
// (Volume.qml's onVolumeChanged, or Keyboard.qml's capsLock poll) calls
// showVolume/showCaps here -> here builds the record and calls
// Dock.pushOsd -> Dock sets currentToast/mode="toast" and (re)starts
// toastTimer unless a pinned mode is open -> Center.qml's Loader picks up
// Dock.mode === "toast" and loads OsdToast with that record. There's no
// test harness for any of this — verify by running `pkill quickshell; qs`
// and watching the bar (see this folder's CLAUDE.md, "Verifying").
Singleton {
    function showVolume(v, muted) {
        Dock.pushOsd({ osdType: "volume", value: v, muted: muted })
    }

    function showCaps(on) {
        Dock.pushOsd({ osdType: "caps", value: on ? 1 : 0 })
    }
}
