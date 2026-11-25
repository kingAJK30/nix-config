pragma Singleton
import QtQuick
import Quickshell

// Bluetooth radio power + a connected device's name, polled via
// `bluetoothctl` since Quickshell has no native BlueZ binding.
Singleton {
    id: root

    property bool powered: false
    property string connectedDevice: ""

    function toggle() {
        poller.mutate(["bluetoothctl", "power", root.powered ? "off" : "on"])
    }

    PolledShellValue {
        id: poller
        interval: 2000
        pollCommand: ["sh", "-c", "bluetoothctl show; echo ---; bluetoothctl devices Connected"]
        onParsed: text => {
            const [status, devices] = text.split("---\n")
            root.powered = /Powered: yes/.test(status)
            const match = devices && devices.match(/^Device \S+ (.+)$/m)
            root.connectedDevice = match ? match[1] : ""
        }
    }
}
