import "pegsolitaire.js" as Logic
import QtQuick 1.1

Column {
    id: highscoresColumn

    spacing: 5

    Text {
        id: highscoreLabel
        anchors.horizontalCenter: highscoresColumn.horizontalCenter
        text: "Highscores"
        font.pixelSize: 35
    }

    Item {
        id: root

        width: row.width + 20
        height: row.height + 20

        Row {
            id: row

            spacing: 10
            Text {
                id: firstColumnTxt
                font.pixelSize: 15
            }

            Text {
                id: secondColumnTxt
                font.pixelSize: 15
            }
        }
    }

    Button {
        anchors.horizontalCenter: highscoresColumn.horizontalCenter
        text: "Menu"
        font.pixelSize: 20
        onBtnClicked: {
            console.log("Main Menu");
            view.state = "MENU"
        }
    }

    function setFirstColumnTxt(txt) {
        if (txt == null)
            firstColumnTxt.text = "None"
        firstColumnTxt.text = txt;
    }

    function setSecondColumnTxt(txt) {
        if (txt == null)
            secondColumnTxt.text = "None"
        secondColumnTxt.text = txt;
    }
}


