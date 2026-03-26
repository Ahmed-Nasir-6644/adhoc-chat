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
    property string currentUsername: ""
    property bool isRegistered: false

    // User colors for consistent avatars
    property var userColors: [
        "#264653", "#2a9d8f", "#e9c46a", "#f4a261", "#e76f51",
        "#6b5b95", "#88498f", "#c05c7e", "#d62246", "#f8b400"
    ]

    Component.onCompleted: {
        // Initialize with a single demo room
        window.allRooms = [
            { id: 1, name: "Demo Room", type: "public", code: "DEMO001", members: 1, messages: [
                { sender: "System", text: "Welcome to Adhoc Chat! Start sending messages.", isOwn: false, color: userColors[5], initials: "SY" }
            ]}
        ]
        window.joinedRooms = []
        
        // Show registration dialog
        registrationDialog.open()
    }

    // Main Chat View (loaded after registration)
    RowLayout {
        anchors.fill: parent
        spacing: 0
        visible: window.isRegistered

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
                            // Get first two letters of username for initials
                            const initials = window.currentUsername.substring(0, 2).toUpperCase()
                            
                            window.joinedRooms[window.selectedRoomIndex].messages.push({
                                sender: window.currentUsername,
                                text: text,
                                isOwn: true,
                                color: window.userColors[9],
                                initials: initials
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

    // Registration Dialog
    RegistrationDialog {
        id: registrationDialog
        
        onRegistrationCompleted: (username) => {
            window.currentUsername = username
            window.isRegistered = true
            
            // Add user to demo room
            window.joinedRooms = [window.allRooms[0]]
            window.selectedRoomIndex = 0
            window.isInChat = true
            
            console.log("User registered:", username)
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
