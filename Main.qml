import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 1400
    height: 760
    visible: true
    title: "Adhoc Chat"
    color: "#101316"

    property color bgPrimary: "#101316"
    property color bgSecondary: "#151a1f"
    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"

    // State
    property bool isInChat: false
    property int selectedRoomIndex: 0
    property bool someoneTyping: false
    property var allRooms: []
    property var joinedRooms: []

    // User colors for consistent avatars
    property var userColors: [
        "#264653", "#2a9d8f", "#e9c46a", "#f4a261", "#e76f51",
        "#6b5b95", "#88498f", "#c05c7e", "#d62246", "#f8b400"
    ]

    Component.onCompleted: {
        // Initialize with default rooms
        window.allRooms = [
            { id: 1, name: "General", type: "public", code: "GEN001", members: 4, messages: [
                { sender: "Ahmed", text: "Hey everyone, welcome to General!", isOwn: false, color: userColors[0], initials: "AH" },
                { sender: "You", text: "Thanks! This QML UI looks great.", isOwn: true, color: userColors[9], initials: "YO" }
            ]},
            { id: 2, name: "Development", type: "public", code: "DEV002", members: 3, messages: [
                { sender: "Dev Lead", text: "Let's discuss the API design today.", isOwn: false, color: userColors[4], initials: "DL" }
            ]},
            { id: 3, name: "Design", type: "public", code: "DES003", members: 2, messages: [
                { sender: "Designer", text: "Check out these mockups", isOwn: false, color: userColors[6], initials: "DE" }
            ]}
        ]
        window.joinedRooms = window.allRooms.slice(0, 3)
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: window.isInChat ? 1 : 0
        
        // Index 0: Home Page
        HomePage {
            id: homePage
            allRooms: window.allRooms
            
            onJoinRoom: (roomCode) => {
                const found = findRoomByCode(roomCode)
                if (found) {
                    window.isInChat = true
                    window.selectedRoomIndex = found.index
                } else {
                    console.log("Room not found:", roomCode)
                }
            }
            
            onCreateRoomRequested: createDialog.open()
            
            onJoinPublicRoom: (roomIndex) => {
                if (roomIndex >= 0 && roomIndex < homePage.publicRooms.length) {
                    const room = homePage.publicRooms[roomIndex]
                    const found = findRoomByCode(room.code)
                    if (found) {
                        window.isInChat = true
                        window.selectedRoomIndex = found.index
                    }
                }
            }
        }
        
        // Index 1: Chat View
        RowLayout {
            spacing: 0
            
            // Back to Home Button
            Rectangle {
                Layout.preferredWidth: 60
                Layout.fillHeight: true
                color: "#151a1f"
                border.width: 1
                border.color: "#28313a"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    
                    Button {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        text: "←"
                        palette.buttonText: window.textPrimary
                        font.pixelSize: 18
                        
                        background: Rectangle {
                            color: parent.hovered ? "#28313a" : "#1b2229"
                            radius: 6
                            border.width: 1
                            border.color: "#28313a"
                        }
                        
                        onClicked: window.isInChat = false
                        ToolTip.visible: hovered
                        ToolTip.text: "Back to home"
                    }
                    
                    Rectangle { Layout.fillHeight: true }
                }
            }

            // Left Sidebar
            Sidebar {
                Layout.fillHeight: true
                Layout.preferredWidth: 220
                selectedRoomIndex: window.selectedRoomIndex
                rooms: window.joinedRooms
                onRoomSelected: (index) => {
                    window.selectedRoomIndex = index
                }
            }

            // Main Chat Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: window.bgPrimary

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    // Chat Header
                    ChatHeader {
                        id: chatHeader
                        Layout.fillWidth: true
                        roomName: window.joinedRooms[window.selectedRoomIndex] ? window.joinedRooms[window.selectedRoomIndex].name : "Room"
                        onlineCount: 4
                        someoneTyping: window.someoneTyping
                        onSettingsRequested: settingsPanel.open()
                    }

                    // Message List
                    MessageList {
                        id: messageList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        messages: window.joinedRooms[window.selectedRoomIndex] ? window.joinedRooms[window.selectedRoomIndex].messages : []
                    }

                    // Message Composer
                    MessageComposer {
                        id: composer
                        Layout.fillWidth: true
                        onMessageSent: (text) => {
                            if (window.selectedRoomIndex >= 0 && window.selectedRoomIndex < window.joinedRooms.length) {
                                window.joinedRooms[window.selectedRoomIndex].messages.push({
                                    sender: "You",
                                    text: text,
                                    isOwn: true,
                                    color: window.userColors[9],
                                    initials: "YO"
                                })
                                // Trigger model update
                                var temp = window.joinedRooms[window.selectedRoomIndex].messages
                                window.joinedRooms[window.selectedRoomIndex].messages = []
                                window.joinedRooms[window.selectedRoomIndex].messages = temp
                            }
                        }
                    }
                    
                    Binding {
                        target: window
                        property: "someoneTyping"
                        value: composer.isTyping
                    }
                }
            }

            // Right Members Panel
            MembersPanel {
                Layout.fillHeight: true
                Layout.preferredWidth: 220
                members: []
            }
        }
    }

    // Create Room Dialog
    CreateRoomDialog {
        id: createDialog
        
        onRoomCreated: (name, isPublic) => {
            const code = generateRoomCode()
            const newRoom = {
                id: Date.now(),
                name: name,
                type: isPublic ? "public" : "private",
                code: code,
                members: 1,
                messages: []
            }
            
            // Add to all rooms and joined rooms
            const updatedAllRooms = window.allRooms.concat([newRoom])
            const updatedJoinedRooms = window.joinedRooms.concat([newRoom])
            
            window.allRooms = updatedAllRooms
            window.joinedRooms = updatedJoinedRooms
            window.selectedRoomIndex = updatedJoinedRooms.length - 1
            window.isInChat = true
            
            // Show code popup for private rooms
            if (!isPublic) {
                codeSharePopup.roomCode = code
                codeSharePopup.roomName = name
                codeSharePopup.open()
            }
            
            console.log("Room created:", name, "Code:", code, "Type:", isPublic ? "public" : "private")
        }
    }

    // Code Share Popup for private rooms
    CodeSharePopup {
        id: codeSharePopup
    }

    // Settings Panel
    SettingsPanel {
        id: settingsPanel
        anchors.centerIn: parent
    }

    // Helper functions
    function findRoomByCode(code) {
        for (let i = 0; i < window.allRooms.length; i++) {
            if (window.allRooms[i].code === code.toUpperCase()) {
                return { room: window.allRooms[i], index: i }
            }
        }
        return null
    }

    function generateRoomCode() {
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let code = ""
        for (let i = 0; i < 8; i++) {
            code += chars.charAt(Math.floor(Math.random() * chars.length))
        }
        return code
    }
}
