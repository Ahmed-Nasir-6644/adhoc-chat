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
    property bool isJoiningNetwork: false
    property int selectedRoomIndex: 0
    property bool someoneTyping: false
    property var allRooms: []
    property var joinedRooms: []
    property string currentUsername: ""
    property bool isRegistered: false
    
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

    // Home Page (Network Setup)
    Loader {
        anchors.fill: parent
        active: window.isRegistered && window.isJoiningNetwork
        visible: active
        sourceComponent: HomePage {
            allRooms: window.allRooms
            
            onJoinRoom: (roomCode) => {
                console.log("Joining room with code:", roomCode)
                // Find the room
                const roomInfo = findRoomByCode(roomCode)
                if (roomInfo) {
                    // Start network setup
                    networkSetup.startAdhocSetup()
                } else {
                    errorDialog.errorMessage = "Room not found"
                    errorDialog.open()
                }
            }
            
            onJoinPublicRoom: (roomIndex) => {
                console.log("Joining public room:", roomIndex)
                if (roomIndex >= 0 && roomIndex < window.publicRooms.length) {
                    // Start network setup
                    networkSetup.startAdhocSetup()
                }
            }
            
            onCreateRoomRequested: {
                createDialog.open()
            }
        }
    }

    // Main Chat View (loaded after joining network)
    RowLayout {
        anchors.fill: parent
        spacing: 0
        visible: window.isRegistered && !window.isJoiningNetwork

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
            window.isJoiningNetwork = true
            
            console.log("User registered:", username, "- Now showing network join page")
        }
    }

    // Network Setup Connections
    Connections {
        target: networkSetup
        
        function onSetupSucceeded() {
            console.log("Network setup succeeded, entering chat...")
            // Add user to demo room
            window.joinedRooms = [window.allRooms[0]]
            window.selectedRoomIndex = 0
            window.isJoiningNetwork = false
            window.isInChat = true
        }
        
        function onSetupFailed(errorMessage) {
            console.log("Network setup failed:", errorMessage)
            errorDialog.errorMessage = "Network setup failed: " + errorMessage
            errorDialog.open()
        }
        
        function onSetupProgress(message) {
            console.log("Setup progress:", message)
        }
    }

    // Error Dialog
    Dialog {
        id: errorDialog
        title: "Error"
        modal: true
        
        property string errorMessage: ""
        
        property color bgPrimary: "#101316"
        property color borderColor: "#28313a"
        property color textPrimary: "#e8edf2"
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
            
            Label {
                text: errorDialog.errorMessage
                color: textPrimary
                font.pixelSize: 14
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            
            Button {
                text: "OK"
                Layout.alignment: Qt.AlignHCenter
                onClicked: errorDialog.close()
                
                background: Rectangle {
                    color: accent
                    radius: 8
                }
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
