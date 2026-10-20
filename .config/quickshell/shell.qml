import Quickshell
import qs.bar
import qs.notifications
import qs.polkit
import qs.osd
import qs.power

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }
    NotificationPopups {}
    PolkitPrompt {}
    Osd {}
    PowerMenu {}
}
