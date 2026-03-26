import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: registrationDialog
    title: "Register"
    modal: true
    
    signal registrationCompleted(string username)
    
    property color bgPrimary: "#101316"
    property color bgSecondary: "#151a1f"
    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"
    
    width: 400
    anchors.centerIn: parent
    
    background: Rectangle {
        color: bgPrimary
        border.width: 1
        border.color: borderColor
        radius: 12
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20
        
        // Title
        Label {
            text: "Welcome to Adhoc Chat"
            font.pixelSize: 24
            font.bold: true
            color: textPrimary
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Subtitle
        Label {
            text: "Enter your username to get started"
            font.pixelSize: 14
            color: textSecondary
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Username Input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Label {
                text: "Username"
                font.pixelSize: 13
                color: textPrimary
                font.bold: true
            }
            
            TextField {
                id: usernameInput
                Layout.fillWidth: true
                placeholderText: "Enter your username..."
                color: textPrimary
                placeholderTextColor: textSecondary
                font.pixelSize: 14
                
                background: Rectangle {
                    color: bgTertiary
                    border.width: 1
                    border.color: registrationDialog.borderColor
                    radius: 8
                }
                
                padding: 12
                
                Keys.onReturnPressed: {
                    if (usernameInput.text.length > 0) {
                        registrationDialog.registrationCompleted(usernameInput.text)
                        registrationDialog.close()
                    }
                }
            }
        }
        
        // Join Button
        Button {
            id: joinButton
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            text: "Join Chat"
            font.pixelSize: 14
            font.bold: true
            palette.buttonText: bgPrimary
            enabled: usernameInput.text.length > 0
            
            background: Rectangle {
                color: joinButton.enabled ? registrationDialog.accent : "#556b7a"
                radius: 8
                border.width: 1
                border.color: registrationDialog.borderColor
            }
            
            onClicked: {
                if (usernameInput.text.length > 0) {
                    registrationDialog.registrationCompleted(usernameInput.text)
                    registrationDialog.close()
                }
            }
        }
    }
}
