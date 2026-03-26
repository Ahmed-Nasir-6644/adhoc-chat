import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Popup {
    id: createDialog
    modal: true
    anchors.centerIn: parent
    width: 400
    height: 320
    
    signal roomCreated(string name, bool isPublic)
    
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
            text: "Create New Room"
            font.pixelSize: 18
            font.bold: true
            color: textPrimary
        }
        
        // Room Name Input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            
            Label {
                text: "Room Name"
                font.pixelSize: 12
                color: textSecondary
            }
            
            TextField {
                id: roomNameInput
                Layout.fillWidth: true
                placeholderText: "Enter room name..."
                color: textPrimary
                placeholderTextColor: textSecondary
                font.pixelSize: 13
                
                background: Rectangle {
                    color: bgTertiary
                    border.width: 1
                    border.color: borderColor
                    radius: 6
                }
                
                padding: 10
            }
        }
        
        // Room Type Toggle
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Label {
                text: "Room Type"
                font.pixelSize: 12
                color: textSecondary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    id: publicBtn
                    Layout.fillWidth: true
                    text: "🌐 Public"
                    checked: true
                    checkable: true
                    palette.buttonText: textPrimary
                    
                    background: Rectangle {
                        color: publicBtn.checked ? accent : bgTertiary
                        border.width: 1
                        border.color: borderColor
                        radius: 6
                    }
                    
                    onClicked: {
                        publicBtn.checked = true
                        privateBtn.checked = false
                    }
                }
                
                Button {
                    id: privateBtn
                    Layout.fillWidth: true
                    text: "🔒 Private"
                    checkable: true
                    palette.buttonText: textPrimary
                    
                    background: Rectangle {
                        color: privateBtn.checked ? accent : bgTertiary
                        border.width: 1
                        border.color: borderColor
                        radius: 6
                    }
                    
                    onClicked: {
                        privateBtn.checked = true
                        publicBtn.checked = false
                    }
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        // Action Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Button {
                Layout.fillWidth: true
                text: "Cancel"
                palette.buttonText: textPrimary
                
                background: Rectangle {
                    color: parent.pressed ? "#235547" : bgTertiary
                    border.width: 1
                    border.color: borderColor
                    radius: 6
                }
                
                onClicked: createDialog.close()
            }
            
            Button {
                Layout.fillWidth: true
                text: "Create"
                palette.buttonText: textPrimary
                enabled: roomNameInput.text.length > 0
                
                background: Rectangle {
                    color: parent.pressed ? "#1a9b7d" : (parent.enabled ? accent : "#666666")
                    border.width: 1
                    border.color: borderColor
                    radius: 6
                }
                
                onClicked: {
                    if (roomNameInput.text.length > 0) {
                        createDialog.roomCreated(roomNameInput.text, publicBtn.checked)
                        roomNameInput.text = ""
                        publicBtn.checked = true
                        privateBtn.checked = false
                        createDialog.close()
                    }
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
