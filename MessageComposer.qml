import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: composer
    height: 84
    radius: 12
    color: "#151a1f"
    border.width: 1
    border.color: "#28313a"

    signal messageSent(string text)

    property color bgSecondary: "#151a1f"
    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"
    property bool isTyping: false

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        TextArea {
            id: messageInput
            Layout.fillWidth: true
            Layout.fillHeight: true
            placeholderText: "Type a message"
            color: textPrimary
            placeholderTextColor: textSecondary
            font.pixelSize: 14
            wrapMode: TextEdit.Wrap
            
            onTextChanged: {
                // Emit typing state signal
                if (text.trim() !== "" && !composer.isTyping) {
                    composer.isTyping = true
                    typingTimer.start()
                } else if (text.trim() === "") {
                    composer.isTyping = false
                    typingTimer.stop()
                }
            }
            
            Keys.onReturnPressed: (event) => {
                if (event.modifiers & Qt.ControlModifier) {
                    if (messageInput.text.trim() !== "") {
                        composer.messageSent(messageInput.text)
                        messageInput.clear()
                        composer.isTyping = false
                        typingTimer.stop()
                    }
                    event.accepted = true
                }
            }

            background: Rectangle {
                radius: 9
                color: bgTertiary
                border.width: 1
                border.color: borderColor
            }
        }
        
        Timer {
            id: typingTimer
            interval: 2000
            onTriggered: composer.isTyping = false
        }

        Button {
            id: sendBtn
            text: "Send"
            Layout.preferredWidth: 92
            Layout.fillHeight: true
            font.bold: true
            enabled: messageInput.text.trim() !== ""

            background: Rectangle {
                radius: 9
                color: sendBtn.enabled ? accent : "#6b7582"
                Behavior on color { ColorAnimation { duration: 100 } }
            }

            contentItem: Label {
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: sendBtn.enabled ? "#0b1217" : "#8894a1"
                font.bold: true
            }

            onClicked: {
                if (messageInput.text.trim() !== "") {
                    composer.messageSent(messageInput.text)
                    messageInput.clear()
                    composer.isTyping = false
                    typingTimer.stop()
                }
            }
        }
    }
}
