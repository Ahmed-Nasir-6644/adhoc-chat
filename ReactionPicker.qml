import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: reactionPicker
    width: reactionRow.width + 12
    height: 36
    radius: 12
    color: "#1b2229"
    border.width: 1
    border.color: "#28313a"

    signal reactionSelected(string emoji)

    property var emojis: ["👍", "❤️", "😂", "😮", "😢", "🔥"]

    Row {
        id: reactionRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: reactionPicker.emojis

            Button {
                text: modelData
                flat: true
                font.pixelSize: 18
                padding: 4
                width: 28
                height: 28
                hoverEnabled: true

                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? "#28313a" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                onClicked: reactionPicker.reactionSelected(modelData)
            }
        }
    }
}
