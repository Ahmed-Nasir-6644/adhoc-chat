import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Menu {
    id: contextMenu
    
    signal actionTriggered(string action)
    
    background: Rectangle {
        color: "#1b2229"
        border.width: 1
        border.color: "#28313a"
        radius: 8
    }
    
    MenuItem {
        text: "Copy"
        onTriggered: contextMenu.actionTriggered("Copy")
    }
    
    MenuSeparator { }
    
    MenuItem {
        text: "Edit"
        onTriggered: contextMenu.actionTriggered("Edit")
    }
    
    MenuItem {
        text: "Pin"
        onTriggered: contextMenu.actionTriggered("Pin")
    }
    
    MenuSeparator { }
    
    MenuItem {
        text: "Delete"
        onTriggered: contextMenu.actionTriggered("Delete")
    }
}
