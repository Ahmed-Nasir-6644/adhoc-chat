import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: settingsPopup
    width: 320
    height: 500
    anchors.centerIn: parent
    modal: true
    
    property color bgColor: "#151a1f"
    property color bgSecondary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accentColor: "#2dd4bf"
    
    property bool notificationsEnabled: true
    property bool soundEnabled: true
    property bool darkMode: true
    
    background: Rectangle {
        color: bgColor
        border.width: 1
        border.color: borderColor
        radius: 12
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16
        
        Label {
            text: "Settings"
            color: textPrimary
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Label {
                text: "Notifications"
                color: textSecondary
                font.pixelSize: 12
                font.bold: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Switch {
                    checked: settingsPopup.notificationsEnabled
                    onCheckedChanged: settingsPopup.notificationsEnabled = checked
                }
                
                Label {
                    text: "Enable notifications"
                    color: textPrimary
                    font.pixelSize: 13
                    Layout.fillWidth: true
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                spacing: 10
                
                Switch {
                    checked: settingsPopup.soundEnabled
                    enabled: settingsPopup.notificationsEnabled
                    onCheckedChanged: settingsPopup.soundEnabled = checked
                }
                
                Label {
                    text: "Enable sound"
                    color: settingsPopup.notificationsEnabled ? textPrimary : textSecondary
                    font.pixelSize: 13
                    Layout.fillWidth: true
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Label {
                text: "Appearance"
                color: textSecondary
                font.pixelSize: 12
                font.bold: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Switch {
                    checked: settingsPopup.darkMode
                    onCheckedChanged: settingsPopup.darkMode = checked
                }
                
                Label {
                    text: "Dark mode"
                    color: textPrimary
                    font.pixelSize: 13
                    Layout.fillWidth: true
                }
            }
        }
        
        Item {
            Layout.fillHeight: true
        }
        
        Button {
            Layout.fillWidth: true
            text: "Close"
            
            background: Rectangle {
                radius: 8
                color: accentColor
            }
            
            contentItem: Label {
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#0b1217"
                font.bold: true
            }
            
            onClicked: settingsPopup.close()
        }
    }
}
