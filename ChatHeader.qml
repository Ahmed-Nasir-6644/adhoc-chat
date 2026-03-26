import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: header
    height: 66
    color: "#151a1f"
    border.width: 1
    border.color: "#28313a"
    radius: 12

    required property string roomName
    required property int onlineCount
    property bool someoneTyping: false

    signal settingsRequested()

    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Label {
                text: "# " + header.roomName
                color: textPrimary
                font.pixelSize: 18
                font.bold: true
            }

            RowLayout {
                spacing: 8

                Label {
                    text: header.onlineCount + " online"
                    color: textSecondary
                    font.pixelSize: 12
                }

                TypingIndicator {
                    visible: header.someoneTyping
                    dotColor: accent
                }

                Label {
                    text: "typing..."
                    color: accent
                    font.pixelSize: 12
                    visible: header.someoneTyping
                }
            }
        }

        RowLayout {
            spacing: 8

            Button {
                id: callBtn
                width: 40
                height: 40
                flat: true
                hoverEnabled: true

                background: Rectangle {
                    radius: 8
                    color: callBtn.hovered ? "#28313a" : "#1b2229"
                    border.width: 1
                    border.color: "#28313a"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                contentItem: Label {
                    text: "☎️"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                ToolTip.visible: hovered
                ToolTip.text: "Start voice call"
            }

            Button {
                id: videoBtn
                width: 40
                height: 40
                flat: true
                hoverEnabled: true

                background: Rectangle {
                    radius: 8
                    color: videoBtn.hovered ? "#28313a" : "#1b2229"
                    border.width: 1
                    border.color: "#28313a"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                contentItem: Label {
                    text: "📹"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                ToolTip.visible: hovered
                ToolTip.text: "Start video call"
            }

            Rectangle {
                width: 1
                height: 30
                color: "#28313a"
            }

            Button {
                id: infoBtn
                width: 40
                height: 40
                flat: true
                hoverEnabled: true
                onClicked: header.settingsRequested()

                background: Rectangle {
                    radius: 8
                    color: infoBtn.hovered ? "#28313a" : "#1b2229"
                    border.width: 1
                    border.color: "#28313a"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                contentItem: Label {
                    text: "ℹ️"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                ToolTip.visible: hovered
                ToolTip.text: "Room info"
            }
        }
    }
}
