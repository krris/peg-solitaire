import QtQuick 1.1
import "pegsolitaire.js" as Logic

Rectangle {
    id: view

    width: 620
    height: 620

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "DeepSkyBlue"
        }
        GradientStop {
            position: 0.7
            color: "lightskyblue"
        }
    }

    Image {
        id: pegSolitaireLabel

        source: "images/pegsolitaire.png"
        anchors.horizontalCenter: menuColumn.horizontalCenter
    }

    Column {
        id: menuColumn

        anchors.centerIn: view
        spacing: 5

        Button {
            anchors.horizontalCenter: menuColumn.horizontalCenter
            text: "New Game"
            font.pixelSize: 35
            onBtnClicked: {
                view.state = "GAMEPLAY"
                timer.seconds = Logic.timeCounter
                timer.enabled = true
                console.log("[new game] selected board: " + Logic.selectedBoardStyle)
                if (Logic.board == null)
                    Logic.startNewGame();
                else
                    Logic.restartBoard();
            }
        }

        Button {
            anchors.horizontalCenter: menuColumn.horizontalCenter
            text: "Highscores"
            font.pixelSize: 35
            onBtnClicked: {
                console.log("Highscores!");
                Logic.showHighscores();
                view.state = "HIGHSCORES"
            }
        }

        Button {
            anchors.horizontalCenter: menuColumn.horizontalCenter
            text: "Settings"
            font.pixelSize: 35
            onBtnClicked: {
                console.log("Settings")
                view.state = "SETTINGS"
            }
        }

        Button {
            anchors.horizontalCenter: menuColumn.horizontalCenter
            text: "Exit"
            font.pixelSize: 35
            onBtnClicked: {
                Qt.quit();
            }
        }
    }

    Item {
        id: gameplay

        anchors.fill: view

        Row {
            id: row

            anchors.bottom: gameplay.bottom
            width: view.width
            spacing: 3

            Button {
                text: "Restart"
                font.pixelSize: 18
                width: row.width / 3
                onBtnClicked: {
                    view.state = "GAMEPLAY"
                    timer.seconds = Logic.timeCounter
                    Logic.restartBoard()
                }
            }

            Button {
                text: "Menu"
                font.pixelSize: 18
                width: row.width / 3
                onBtnClicked: {
                    view.state = "MENU"
                }
            }

            Button {
                text: "Exit"
                font.pixelSize: 18
                width: row.width / 3
                onBtnClicked: {
                    Qt.quit();
                }
            }
        }

        Item {
            id: timer

            property int seconds: Logic.timeCounter
            property bool enabled: false

            x: (view.width / 2) - time.width / 2
            anchors.top: gameplay.top
            anchors.topMargin: 30

            Timer {
                interval: 1000; running: true; repeat: true;
                onTriggered: {
                    if(timer.enabled)
                        timer.seconds++
                }
            }

             Text {
                 id: time
                 text: "Time: " + timer.seconds
                 font.pixelSize: 20
                 font.bold: true
             }
         }

        Rectangle {
            id: gameCanvasBackground

            color: "transparent"
            height: gameCanvas.height + 100
            width: gameCanvas.width + 100
            anchors.centerIn: gameplay

            Rectangle {
                id: gameCanvas
                color: "transparent"

                property int ballSize: 55
                anchors.centerIn: gameCanvasBackground
                height: Logic.maxRow * ballSize
                width: Logic.maxColumn * ballSize
            }

            MouseArea {
                id: gameCanvasMouseArea

                anchors.fill: gameCanvas

                onClicked: {
                    console.log("gameCanvasMouseArea clicked");
                    Logic.handleClickedBall(mouse.x, mouse.y)
                }
            }
        }
    }

    Column {
        id: settingsColumn
        anchors.centerIn: view
        spacing: 5

        Text {
            anchors.horizontalCenter: settingsColumn.horizontalCenter
            text: "Board variant"
            font.pixelSize: 35
        }

        Row {
            spacing: 5

            Button {
                text: "English"
                font.pixelSize: 35
                onBtnClicked: {
                    Logic.selectedBoardStyle = Logic.boardStyles[Logic.english];
                    console.log("[settings] selected board: " + Logic.selectedBoardStyle);
                    view.state = "MENU";
                }
            }

            Button {
                text: "European"
                font.pixelSize: 35
                onBtnClicked: {
                    Logic.selectedBoardStyle = Logic.boardStyles[Logic.european];
                    console.log("[settings] selected board: " + Logic.selectedBoardStyle);
                    view.state = "MENU";
                }
            }
        }

        Button {
            anchors.horizontalCenter: settingsColumn.horizontalCenter
            text: "Menu"
            font.pixelSize: 20
            onBtnClicked: {
                console.log("Menu");
                view.state = "MENU"
            }
        }
    }

    Highscores {
        id: highscoresView
        anchors.centerIn: view
    }

    WinnerDialog {
        id: winnerDialog
        anchors.centerIn: view
        width: view.width / 2
        height: view.height/ 2
        onClosed: {
            Logic.saveHighScore(winnerDialog.winnerName);
            view.state = "HIGHSCORES";
            Logic.showHighscores();
        }
    }

    state: "MENU"
    states: [
        State {
            name: "MENU"
            PropertyChanges { target: menuColumn; visible: true }
            PropertyChanges { target: pegSolitaireLabel; visible: true }
            PropertyChanges { target: gameplay; visible: false }
            PropertyChanges { target: settingsColumn; visible: false }
            PropertyChanges { target: highscoresView; visible: false}
            PropertyChanges { target: winnerDialog; visible: false }

        },
        State {
            name: "GAMEPLAY"
            PropertyChanges { target: gameplay; visible: true }
            PropertyChanges { target: pegSolitaireLabel; visible: false }
            PropertyChanges { target: menuColumn; visible: false }
            PropertyChanges { target: settingsColumn; visible: false }
            PropertyChanges { target: highscoresView; visible: false}
            PropertyChanges { target: winnerDialog; visible: false }

        },
        State {
            name: "SETTINGS"
            PropertyChanges { target: settingsColumn; visible: true }
            PropertyChanges { target: pegSolitaireLabel; visible: true }
            PropertyChanges { target: gameplay; visible: false }
            PropertyChanges { target: menuColumn; visible: false }
            PropertyChanges { target: highscoresView; visible: false}
            PropertyChanges { target: winnerDialog; visible: false }
        },
        State {
            name: "HIGHSCORES"
            PropertyChanges { target: highscoresView; visible: true}
            PropertyChanges { target: settingsColumn; visible: false }
            PropertyChanges { target: pegSolitaireLabel; visible: true }
            PropertyChanges { target: gameplay; visible: false }
            PropertyChanges { target: menuColumn; visible: false }
            PropertyChanges { target: winnerDialog; visible: false }
        },
        State {
            name: "WINNER_DIALOG"
            PropertyChanges { target: highscoresView; visible: false}
            PropertyChanges { target: settingsColumn; visible: false }
            PropertyChanges { target: pegSolitaireLabel; visible: true }
            PropertyChanges { target: gameplay; visible: false }
            PropertyChanges { target: menuColumn; visible: false }
            PropertyChanges { target: winnerDialog; visible: true }
        }
    ]
}
