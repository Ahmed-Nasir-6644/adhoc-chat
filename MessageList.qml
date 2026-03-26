import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: messageArea
    color: "#151a1f"
    radius: 12
    border.width: 1
    border.color: "#28313a"

    required property var messages

    property color bgTertiary: "#1b2229"
    property color borderColor: "#28313a"
    property color textPrimary: "#e8edf2"
    property color textSecondary: "#97a6b5"
    property color accent: "#2dd4bf"



    function getTimeString(index) {
        return "10:" + (10 + index).toString().padStart(2, '0')
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 14
        clip: true
        spacing: 12
        model: messageArea.messages

        delegate: Column {
            width: ListView.view.width
            spacing: 4
            property int msgIndex: index

            RowLayout {
                width: parent.width
                spacing: 8

                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    radius: 17
                    color: modelData.color
                    visible: index === 0 || messageArea.messages[index - 1].sender !== modelData.sender

                    Label {
                        anchors.centerIn: parent
                        text: modelData.initials
                        color: "#f4f7fa"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 34
                    visible: !(index === 0 || messageArea.messages[index - 1].sender !== modelData.sender)
                }

                Column {
                    Layout.fillWidth: true
                    spacing: 4

                    RowLayout {
                        width: parent.width
                        spacing: 8
                        visible: index === 0 || messageArea.messages[index - 1].sender !== modelData.sender

                        Label {
                            text: modelData.sender
                            color: accent
                            font.pixelSize: 13
                            font.bold: true
                        }

                        Label {
                            text: getTimeString(index)
                            color: textSecondary
                            font.pixelSize: 11
                        }
                    }

                    Item {
                        width: parent.width
                        height: msgCol.height













                        Column {
                            id: msgCol
                            width: Math.min(msgContent.implicitWidth + 18, parent.width - 40)
                            spacing: 4

                            Rectangle {
                                id: msgBubble
                                width: parent.width
                                height: msgContent.implicitHeight + 12
                                radius: 10
                                color: modelData.isOwn ? "#1d2a31" : "#212b33"
                                border.width: 1
                                border.color: borderColor

                                Label {
                                    id: msgContent
                                    anchors.fill: parent
                                    anchors.margins: 9
                                    wrapMode: Text.WordWrap
                                    text: modelData.text
                                    color: textPrimary
                                    font.pixelSize: 14
                                }
                                

                            }


                        }


                    }
                }
            }
        }

        onCountChanged: {
            positionViewAtEnd()
        }
    }
}
