import QtQuick

Island {
    id: root

    property real titleReserve: 80
    naturalWidth: ws.width + titleReserve + 1

    Workspaces { id: ws }
    WindowTitle { width: root.width - 1 - ws.width }
}
