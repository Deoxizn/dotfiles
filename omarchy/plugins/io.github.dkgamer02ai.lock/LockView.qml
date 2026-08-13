import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Item {
  id: root

  property string backgroundPath: ""
  property int backgroundVersion: 0
  property bool fingerprintConfigured: false
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""
  property bool syncingPasswordText: false

  // Dynamic script output properties
  property string scriptSong: ""
  property string scriptWeather: ""
  property string scriptUptime: ""
  property string scriptUptimehm: ""

  // Resolve specific screen wallpaper based on monitor name
  readonly property string screenName: Screen.name || ""
  readonly property bool isPrimaryScreen: screenName === "DP-1" || screenName === ""
  readonly property string staticWallpaper: {
    if (screenName === "DP-1") {
      return "file://" + Quickshell.env("HOME") + "/Pictures/wallpaper/wallhaven-mlzzx8.png"
    } else if (screenName === "HDMI-A-1") {
      return "file://" + Quickshell.env("HOME") + "/Pictures/wallpaper/11.png"
    }
    return root.fileUrl(root.backgroundPath)
  }

  readonly property real centerScale: Math.min(1, height > 0 ? height / 1440 : 1)
  readonly property int centerWidth: Math.round(560 * centerScale)
  readonly property int clockFontSize: Math.round(centerWidth / 2.9)
  readonly property int fieldHeight: Math.round(64 * Math.max(0.8, centerScale))
  readonly property int dotSize: Math.round(fieldHeight * 0.22)

  readonly property bool errorState: failureMessage.length > 0
  readonly property string statusText: authenticatingPassword
    ? "Checking…"
    : (fingerprintConfigured ? "Enter password or touch sensor" : "Enter your password")

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  function fileUrl(path) {
    if (!path) return ""
    var encoded = String(path).split("/").map(encodeURIComponent).join("/")
    return "file://" + encoded + "?v=" + backgroundVersion
  }

  function forcePasswordFocus() {
    passwordInput.forceActiveFocus()
  }

  function clearPassword() {
    passwordTextEdited("")
  }

  function syncPasswordText() {
    if (passwordInput.text === passwordText) return
    syncingPasswordText = true
    passwordInput.text = passwordText
    syncingPasswordText = false
  }

  function submitCurrent() {
    var submitted = root.passwordText
    if (submitted.length === 0) return
    root.passwordTextEdited("")
    root.submitPassword(submitted)
  }

  onPasswordTextChanged: syncPasswordText()
  onInputEnabledChanged: {
    if (inputEnabled && isPrimaryScreen) Qt.callLater(forcePasswordFocus)
  }
  Component.onCompleted: {
    syncPasswordText()
    if (inputEnabled && isPrimaryScreen) Qt.callLater(forcePasswordFocus)
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  // --- External Hyprlock Scripts Execution ---
  Process {
    id: songProc
    command: ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/song.sh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.scriptSong = String(text || "").trim()
    }
  }

  Timer {
    interval: 1000
    running: root.loadBackground && root.isPrimaryScreen
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!songProc.running) songProc.running = true
  }

  Process {
    id: weatherProc
    command: ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/weather.sh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.scriptWeather = String(text || "").trim()
    }
  }

  Timer {
    interval: 1800000
    running: root.loadBackground && root.isPrimaryScreen
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!weatherProc.running) weatherProc.running = true
  }

  Process {
    id: uptimeProc
    command: ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/Uptime.sh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.scriptUptime = String(text || "").trim()
    }
  }

  Process {
    id: uptimehmProc
    command: ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/Uptimehm.sh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.scriptUptimehm = String(text || "").trim()
    }
  }

  Timer {
    interval: 60000
    running: root.loadBackground && root.isPrimaryScreen
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!uptimeProc.running) uptimeProc.running = true
      if (!uptimehmProc.running) uptimehmProc.running = true
    }
  }

  // --- UI Structure ---
  Rectangle {
    anchors.fill: parent
    color: Color.background

    Image {
      id: wallpaper
      anchors.fill: parent
      source: root.loadBackground ? root.staticWallpaper : ""
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
    }

    MultiEffect {
      anchors.fill: wallpaper
      source: wallpaper
      autoPaddingEnabled: false
      blurEnabled: false
      contrast: -0.08
    }

    Rectangle {
      anchors.fill: parent
      color: Color.background
      opacity: root.isPrimaryScreen ? 0.15 : 0.0
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: { root.wakeRequested(); if (root.isPrimaryScreen) root.forcePasswordFocus() }
      onPositionChanged: root.wakeRequested()
    }

    // ==========================================
    // TOP SECTION: Time, Date, User
    // ==========================================
    ColumnLayout {
      id: topSection
      visible: root.isPrimaryScreen
      anchors.top: parent.top
      anchors.topMargin: Math.round(40 * root.centerScale)
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.centerWidth
      spacing: Math.round(6 * root.centerScale)

      // Time
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "h:mm ap")
        color: "#C1C1C1"
        font.family: Style.font.family
        font.pixelSize: 84
        font.italic: true
        font.weight: Font.ExtraBold
      }

      // Date
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
        color: "#F1F1F1"
        font.family: Style.font.family
        font.pixelSize: 20
        font.italic: true
        font.weight: Font.ExtraBold
      }

      // User Label
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: "👤 " + Quickshell.env("USER")
        color: "#888888"
        font.family: Style.font.family
        font.pixelSize: 14
        font.weight: Font.ExtraBold
      }
    }

    // ==========================================
    // BOTTOM SECTION: Music, Weather & Uptime
    // ==========================================
    ColumnLayout {
      id: bottomSection
      visible: root.isPrimaryScreen
      anchors.bottom: parent.bottom
      anchors.bottomMargin: Math.round(24 * root.centerScale)
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.centerWidth
      spacing: Math.round(4 * root.centerScale)

      // Song Info
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.scriptSong
        color: "#C1C1C1"
        font.family: Style.font.family
        font.pixelSize: 15
        font.italic: true
        font.weight: Font.ExtraBold
        visible: text.length > 0
      }

      // Weather Script Output
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.scriptWeather
        color: "#C1C1C1"
        font.family: Style.font.family
        font.pixelSize: 16
        font.italic: true
        font.weight: Font.ExtraBold
        visible: text.length > 0
      }

      // Uptime Days Script Output
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.scriptUptime
        color: "#C1C1C1"
        font.family: Style.font.family
        font.pixelSize: 15
        font.italic: true
        font.weight: Font.ExtraBold
        visible: text.length > 0
      }

      // Uptime Hours/Minutes Script Output
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.scriptUptimehm
        color: "#C1C1C1"
        font.family: Style.font.family
        font.pixelSize: 15
        font.italic: true
        font.weight: Font.ExtraBold
        visible: text.length > 0
      }
    }

    // ==========================================
    // LOWER SECTION: Password Box
    // ==========================================
    Item {
      id: centerSection
      visible: root.isPrimaryScreen
      anchors.bottom: bottomSection.top
      anchors.bottomMargin: Math.round(120 * root.centerScale) // Lifted another ~50px
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.centerWidth
      height: root.fieldHeight + 20

      Rectangle {
        id: field
        anchors.centerIn: parent
        implicitWidth: Math.round(root.centerWidth * 0.86)
        implicitHeight: root.fieldHeight
        radius: height / 2
        color: "#C1C1C1"
        border.width: 3
        border.color: root.errorState
          ? "#A06666"
          : Util.alpha("#888888", passwordInput.activeFocus ? 0.9 : 0.35)

        Behavior on border.color { ColorAnimation { duration: 140 } }

        Text {
          id: leadIcon
          anchors.left: parent.left
          anchors.leftMargin: Math.round(root.fieldHeight * 0.32)
          anchors.verticalCenter: parent.verticalCenter
          text: root.fingerprintConfigured ? "🔒" : "🔑"
          color: root.errorState ? "#A06666" : "#888888"
          font.family: Style.font.family
          font.pixelSize: Math.round(root.fieldHeight * 0.36)
        }

        TextInput {
          id: passwordInput
          anchors.fill: parent
          opacity: 0
          activeFocusOnPress: true
          enabled: root.inputEnabled && !root.authenticatingPassword && root.isPrimaryScreen
          readOnly: root.authenticatingPassword
          echoMode: TextInput.Password
          passwordMaskDelay: 0

          onTextChanged: {
            if (!root.syncingPasswordText) root.passwordTextEdited(text)
            if (text.length > 0) {
              root.wakeRequested()
              if (root.failureMessage.length > 0) root.clearFailureRequested()
            }
          }

          onAccepted: root.submitCurrent()

          Keys.onPressed: function(event) {
            root.wakeRequested()
            if (event.key === Qt.Key_Escape || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_U)) {
              root.passwordTextEdited("")
              event.accepted = true
            }
          }
        }

        Text {
          anchors.centerIn: parent
          visible: root.passwordText.length === 0
          text: root.errorState ? root.failureMessage : "Input Password..."
          color: root.errorState ? "#A06666" : "#888888"
          font.family: Style.font.family
          font.pixelSize: Style.font.subtitle
          font.italic: true
          elide: Text.ElideRight
        }

        Item {
          id: dotsClip
          anchors.centerIn: parent
          width: field.width - leadIcon.width - enterButton.width - root.fieldHeight
          height: field.height
          clip: true
          visible: root.passwordText.length > 0

          Row {
            id: dots
            anchors.verticalCenter: parent.verticalCenter
            spacing: Math.round(root.dotSize * 0.75)
            x: width <= dotsClip.width ? (dotsClip.width - width) / 2 : dotsClip.width - width

            Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

            Repeater {
              model: root.passwordText.length

              Rectangle {
                id: dot
                required property int index

                width: root.dotSize
                height: root.dotSize
                radius: width / 2
                color: "#888888"

                Component.onCompleted: {
                  if (index === root.passwordText.length - 1) popIn.start()
                }

                NumberAnimation {
                  id: popIn
                  target: dot
                  property: "scale"
                  from: 0
                  to: 1
                  duration: 180
                  easing.type: Easing.OutBack
                }
              }
            }
          }
        }

        Rectangle {
          id: enterButton
          anchors.right: parent.right
          anchors.rightMargin: Math.round(root.fieldHeight * 0.14)
          anchors.verticalCenter: parent.verticalCenter
          width: Math.round(root.fieldHeight * 0.72)
          height: width
          radius: width / 2
          color: root.passwordText.length > 0 ? Color.accent : Util.alpha(Color.foreground, 0.12)

          Behavior on color { ColorAnimation { duration: 140 } }

          Text {
            anchors.centerIn: parent
            text: "➔"
            color: root.passwordText.length > 0 ? Color.lock.background : Util.alpha(Color.foreground, 0.5)
            font.family: Style.font.family
            font.pixelSize: Math.round(root.fieldHeight * 0.34)
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: root.passwordText.length > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.submitCurrent()
          }
        }
      }

      // Attempt Counter
      Text {
        anchors.top: field.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        visible: root.failedAttempts > 0
        text: root.failedAttempts + (root.failedAttempts === 1 ? " failed attempt" : " failed attempts")
        color: Util.alpha("#A06666", 0.85)
        font.family: Style.font.family
        font.pixelSize: Style.font.bodySmall
      }
    }
  }
}