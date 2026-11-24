import Quickshell
import "../components"

BarText {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "HH:mm")
}
