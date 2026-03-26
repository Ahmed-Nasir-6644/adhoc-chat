import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: homePage
    color: "#101316"
    
    signal joinRoom(string roomCode)
    signal createRoomRequested()
    signal joinPublicRoom(int roomIndex)
    
    required property var allRooms
    
    // Filter to only show public rooms
    property var publicRooms: {
        const publicOnly = []
        for (let i = 0; i < allRooms.length; i++) {
            if (allRooms[i].type === "public") {
                publicOnly.push(allRooms[i])
            }
        }
        return publicOnly
    }
    
    property color bgPrimary: "#101316"
    property color bgSecondary: "#151a1f"
    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"
    
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(500, parent.width - 40)
        spacing: 32
        
        // Title
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "Adhoc Chat"
            font.pixelSize: 48
            font.bold: true
            color: textPrimary
        }
        
        // Join Room Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Label {
                text: "Join a Room"
                font.pixelSize: 18
                font.bold: true
                color: textPrimary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                TextField {
                    id: codeInput
                    Layout.fillWidth: true
                    placeholderText: "Enter room code..."
                    color: textPrimary
                    placeholderTextColor: textSecondary
                    font.pixelSize: 14
                    
                    background: Rectangle {
                        color: bgTertiary
                        border.width: 1
                        border.color: borderColor
                        radius: 8
                    }
                    
                    padding: 12
                    
                    Keys.onReturnPressed: {
                        if (codeInput.text.length > 0) {
                            homePage.joinRoom(codeInput.text.toUpperCase())
                            codeInput.text = ""
                        }
                    }
                }
                
                Button {
                    text: "Join"
                    palette.buttonText: textPrimary
                    font.pixelSize: 13
                    
                    background: Rectangle {
                        color: parent.pressed ? "#235547" : accent
                        radius: 8
                        border.width: 1
                        border.color: borderColor
                    }
                    
                    onClicked: {
                        if (codeInput.text.length > 0) {
                            homePage.joinRoom(codeInput.text.toUpperCase())
                            codeInput.text = ""
                        }
                    }
                }
            }
        }
        
        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        // Public Rooms Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Label {
                    text: "Public Rooms"
                    font.pixelSize: 18
                    font.bold: true
                    color: textPrimary
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: borderColor
                }
            }
            
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                clip: true
                
                ColumnLayout {
                    width: parent.width - 20
                    spacing: 10
                    
                    Repeater {
                        model: homePage.publicRooms.length
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 70
                            color: bgTertiary
                            radius: 8
                            border.width: 1
                            border.color: borderColor
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: homePage.joinPublicRoom(index)
                                
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 4
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8
                                        
                                        Label {
                                            text: homePage.publicRooms[index].name
                                            font.pixelSize: 14
                                            font.bold: true
                                            color: textPrimary
                                        }
                                        
                                        Label {
                                            text: "🌐 Public"
                                            font.pixelSize: 11
                                            color: accent
                                        }
                                        
                                        Rectangle {
                                            Layout.fillWidth: true
                                        }
                                    }
                                    
                                    Label {
                                        text: homePage.publicRooms[index].members + " members • Code: " + homePage.publicRooms[index].code
                                        font.pixelSize: 12
                                        color: textSecondary
                                    }
                                    
                                    Rectangle {
                                        Layout.fillWidth: true
                                    }
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
        }
        
        // Action Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Button {
                Layout.fillWidth: true
                text: "Create Room"
                palette.buttonText: textPrimary
                font.pixelSize: 13
                
                background: Rectangle {
                    color: parent.pressed ? "#235547" : bgTertiary
                    radius: 8
                    border.width: 1
                    border.color: accent
                }
                
                onClicked: homePage.createRoomRequested()
            }
        }
    }
}
