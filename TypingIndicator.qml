import QtQuick

Row {
    id: typingIndicator
    spacing: 3
    
    property color dotColor: "#2dd4bf"
    property bool isPulsing: true
    
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: typingIndicator.dotColor
        opacity: typingIndicator.isPulsing ? 1.0 : 0.5
        
        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
    }
    
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: typingIndicator.dotColor
        opacity: typingIndicator.isPulsing ? 1.0 : 0.5
        
        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
    }
    
    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: typingIndicator.dotColor
        opacity: typingIndicator.isPulsing ? 1.0 : 0.5
        
        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
    }
    
    Timer {
        interval: 600
        running: true
        repeat: true
        onTriggered: typingIndicator.isPulsing = !typingIndicator.isPulsing
    }
}
