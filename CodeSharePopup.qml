import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: codePopup
    modal: true
    anchors.centerIn: parent
    width: 380
    height: 280
    
    property string roomCode: ""
    property string roomName: ""
    
    property color bgSecondary: "#151a1f"
    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"
    
    background: Rectangle {
        color: bgSecondary
        border.width: 1
        border.color: borderColor
        radius: 12
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16
        
        // Title
        Label {
            text: "Private Room Created"
            font.pixelSize: 18
            font.bold: true
            color: textPrimary
        }
        
        // Description
        Label {
            text: "Share this code with others to let them join your private room"
            wrapMode: Text.WordWrap
            font.pixelSize: 12
            color: textSecondary
        }
        
        // Room Info
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Label {
                text: "Room: " + codePopup.roomName
                font.pixelSize: 13
                color: textPrimary
                font.bold: true
            }
            
            // Code Display
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: bgTertiary
                radius: 8
                border.width: 1
                border.color: borderColor
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    
                    TextEdit {
                        id: codeText
                        Layout.fillWidth: true
                        text: codePopup.roomCode
                        font.pixelSize: 24
                        font.bold: true
                        color: codePopup.accent
                        font.family: "Courier"
                        readOnly: true
                        selectByMouse: true
                        
                        onFocusChanged: {
                            if (focus) {
                                selectAll()
                            }
                        }
                    }
                    
                    Button {
                        text: "Copy"
                        palette.buttonText: textPrimary
                        
                        background: Rectangle {
                            color: parent.pressed ? "#235547" : codePopup.accent
                            radius: 6
                            border.width: 1
                            border.color: borderColor
                        }
                        
                        onClicked: {
                            codeText.selectAll()
                            codeText.copy()
                            console.log("Code copied:", codePopup.roomCode)
                            copyNotification.visible = true
                            copyTimer.start()
                        }
                    }
                }
            }
            
            Label {
                id: copyNotification
                text: "✓ Copied to clipboard"
                font.pixelSize: 12
                color: codePopup.accent
                visible: false
            }
            
            Timer {
                id: copyTimer
                interval: 2000
                onTriggered: copyNotification.visible = false
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        // Action Button
        Button {
            Layout.fillWidth: true
            text: "Got it, continue"
            palette.buttonText: textPrimary
            
            background: Rectangle {
                color: parent.pressed ? "#1a9b7d" : codePopup.accent
                radius: 6
                border.width: 1
                border.color: borderColor
            }
            
            onClicked: codePopup.close()
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
