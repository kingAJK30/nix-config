import QtQuick

Island {
    id: root

    naturalWidth: ws.width + 80 + 1

    Workspaces { id: ws }
    WindowTitle { width: root.width - 1 - ws.width }
}
