import Quickshell
import qs.bar
import qs.notifications

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }
    NotificationPopups {}
}
