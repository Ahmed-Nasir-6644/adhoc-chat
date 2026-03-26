import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: sidebar
    width: 330
    color: "#151a1f"
    border.width: 1
    border.color: "#28313a"

    required property int selectedRoomIndex
    required property var rooms
    signal roomSelected(int index)

    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        // Search bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            radius: 10
            color: bgTertiary
            border.width: 1
            border.color: borderColor

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Label {
                    text: "Search"
                    color: textSecondary
                    font.pixelSize: 14
                }
            }
        }

        Label {
            text: "Active Rooms"
            color: textSecondary
            font.pixelSize: 13
            font.bold: true
        }

        // Room list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            model: sidebar.rooms

            delegate: Rectangle {
                width: ListView.view.width
                height: 62
                radius: 10
                color: sidebar.selectedRoomIndex === index ? "#20323a" : bgTertiary
                border.width: 2
                border.color: sidebar.selectedRoomIndex === index ? accent : borderColor
                Behavior on border.color { ColorAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sidebar.roomSelected(index)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        radius: 17
                        color: "#22303a"

                        Label {
                            anchors.centerIn: parent
                            text: "#"
                            color: accent
                            font.bold: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Label {
                            text: modelData.name
                            color: textPrimary
                            font.pixelSize: 14
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Label {
                            text: (modelData.type === "public" ? "🌐 Public" : "🔒 Private") + " • Code: " + modelData.code
                            color: textSecondary
                            font.pixelSize: 11
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
