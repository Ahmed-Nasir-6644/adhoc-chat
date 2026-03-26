import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: membersPanel
    width: 280
    color: "#151a1f"
    border.width: 1
    border.color: "#28313a"

    required property var members

    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Label {
            text: "Members (" + membersPanel.members.length + ")"
            color: textSecondary
            font.pixelSize: 13
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: borderColor
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            model: membersPanel.members

            delegate: Rectangle {
                width: ListView.view.width
                height: 48
                radius: 8
                color: bgTertiary
                border.width: 1
                border.color: borderColor

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: 16
                        color: modelData.color

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Label {
                                Layout.fillWidth: true
                                text: modelData.initials
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: "#f4f7fa"
                                font.bold: true
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: modelData.online ? accent : "#6b7582"
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: -2
                            anchors.bottomMargin: -2
                            border.width: 2
                            border.color: "#151a1f"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Label {
                            text: modelData.name
                            color: textPrimary
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        Label {
                            text: modelData.online ? "Online" : "Away"
                            color: modelData.online ? accent : textSecondary
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
