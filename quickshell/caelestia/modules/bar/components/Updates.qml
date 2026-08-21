import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    property int count: 0
    property bool baselined: false

    visible: count > 0
    implicitWidth: row.implicitWidth + Tokens.padding.small
    implicitHeight: row.implicitHeight

    function refresh() {
        if (!checkProc.running)
            checkProc.running = true;
    }

    StateLayer {
        anchors.fill: parent
        radius: Tokens.rounding.full
        onClicked: {
            Quickshell.execDetached(["omarchy-launch-floating-terminal-with-presentation", "yay", "-Syu"]);
            delayedRefresh.restart();
        }
    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: Tokens.spacing.extraSmall / 2

        MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter

            text: "system_update_alt"
            color: Colours.palette.m3tertiary
            fontStyle: Tokens.font.icon.builders.small.weight(Font.Bold).build()
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter

            text: root.count
            color: Colours.palette.m3tertiary
            font: Tokens.font.body.builders.small.scale(1.05).build()
        }
    }

    Timer {
        interval: 21600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Timer {
        id: delayedRefresh

        interval: 120000
        onTriggered: root.refresh()
    }

    Process {
        id: checkProc

        command: ["bash", "-c", "echo $(( $(checkupdates 2>/dev/null | wc -l) + $(yay -Qua 2>/dev/null | wc -l) ))"]
        stdout: StdioCollector {
            onStreamFinished: {
                const n = parseInt(text.trim()) || 0;
                if (root.baselined && n > root.count)
                    Quickshell.execDetached(["notify-send", "-u", "normal", `${n} updates available`, "Repo + AUR"]);
                else if (root.baselined && n === 0 && root.count > 0)
                    Quickshell.execDetached(["notify-send", "-u", "normal", "System up to date"]);
                root.baselined = true;
                root.count = n;
            }
        }
    }
}
