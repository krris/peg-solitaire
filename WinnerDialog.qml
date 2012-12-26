import QtQuick 1.1

Item {
    id: root

    property string winnerName: textInput.text
    signal closed

    Column {
        id: column

        anchors.centerIn: root
        spacing: 15

        Image {
            id: image

            anchors.horizontalCenter: column.horizontalCenter
            source: "images/winner.png"
        }

        Text {
            id: dialogText

            anchors.horizontalCenter: column.horizontalCenter
            text: "Please enter your name: "
            font.pixelSize: 20
        }

        Rectangle {
            id: boundingBox

            anchors.horizontalCenter: column.horizontalCenter
            radius: 5
            width: column.width
            height: 50
            color: mouseArea.containsMouse ? activePalette.highlight : activePalette.button

            MouseArea {
                id: mouseArea

                anchors.fill: boundingBox
                hoverEnabled: true
            }

            TextInput {
                id: textInput

                color: "black"
                focus: true
                anchors.centerIn: boundingBox
                width: boundingBox.width
                text: ""
                font.pixelSize: 25
                maximumLength: 20

                onAccepted: {
                    if (textInput.text != "") {
                        closed();
                    }
                }
            }
        }
    }

    SystemPalette {
        id: activePalette
    }
}

