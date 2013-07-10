// How many balls are needed to win a game
var ballsToWin = 1;

var databaseIdentifier = "PegSolitaire"

var timeCounter = 0;
var maxColumn = 7;
var maxRow = 7;

var board;
var boardStyles = ["EUROPEAN", "ENGLISH"];
var european = 0;
var english = 1;
var selectedBoardStyle = boardStyles[english];
var europeanHoleX = 2;
var europeanHoleY = 0;


function startNewGame() {
    console.log("Start new game");
    board = new Array(maxRow);

    for (var i = 0; i < maxColumn; i++){
        board[i] = new Array(maxColumn)
    }

    for (var row = 0; row < maxRow; row++){
        for (var column = 0; column < maxColumn; column++){
            board[row][column] = null;

            if (row == Math.floor(maxRow / 2) && column == Math.floor(maxColumn / 2))
                createBallOrHole(row, column, "hole");
            else
                createBallOrHole(row, column, "ball");

            switch(selectedBoardStyle) {
            case "EUROPEAN":
                if (europeanBoardCoords(column, row)) {
                    board[row][column].visible = true;
                }
                else {
                    board[row][column].visible = false;
                }

                break;
            case "ENGLISH":
                if (englishBoardCoords(column, row)) {
                    board[row][column].visible = true;
                }
                else {
                    board[row][column].visible = false;
                }
                break;

            }
        }
    }
}

function destroyBoard() {
    console.log("Let's destroy the board!")
    for (var i = 0; i < maxColumn; i++){
        for (var j = 0 ; j < maxRow; j++) {
            if (board[j][j] != null) {
                board[j][j].destroy();
                console.log("Destroying: (" + i + ", " + j + ")");
            }
            delete board [j][i];
        }
    }
    delete board;
}

function restartBoard() {
    console.log("restart board: " + selectedBoardStyle)
    for (var row = 0; row < maxRow; row++){
        for (var column = 0; column < maxColumn; column++){

            if (board[row][column] != null){

                switch(selectedBoardStyle) {
                case "EUROPEAN":
                    if (europeanBoardCoords(column, row)) {
                        board[row][column].visible = true;
                    }

                    if (europeanBoardCoords(column, row)) {
                        if (row == europeanHoleY && column == europeanHoleX)
                            board[row][column].currentState = "HOLE";
                        else
                            board[row][column].currentState = "BALL";
                    }
                    break;

                case "ENGLISH":
                    if (europeanBoardCoords(column, row) && (englishBoardCoords(column, row) == false)) {
                        board[row][column].visible = false;
                    }

                    if (englishBoardCoords(column, row)) {

                        if (row == Math.floor(maxRow / 2) && column == Math.floor(maxColumn / 2))
                            board[row][column].currentState = "HOLE";
                        else
                            board[row][column].currentState = "BALL";
                    }
                    break;

                }
            }
        }
    }
}

var ballComponent
function createBallOrHole(row, column, ballOrHole){

    if (ballComponent == null)
        ballComponent = Qt.createComponent("Ball.qml");

    if (ballComponent.status == Component.Ready) {
        var dynamicObject;

        if (ballOrHole == "hole")
            dynamicObject = ballComponent.createObject(gameCanvas, { "currentState": "HOLE" });
        else if (ballOrHole == "ball")
            dynamicObject = ballComponent.createObject(gameCanvas, { "currentState": "BALL" });

        if (dynamicObject == null) {
            console.log("error creating ball component");
            console.log(ball.errorString());
            return false;
        }

        dynamicObject.x = column * gameCanvas.ballSize;
        dynamicObject.y = row * gameCanvas.ballSize;
        dynamicObject.width = gameCanvas.ballSize;
        dynamicObject.height = gameCanvas.ballSize;

        board[row][column] = dynamicObject;
    } else {
        console.log("error loading ball component");
        console.log(ballComponent.errorString());
        return false;
    }
}

function englishBoardCoords(column, row) {
    // check coords for English board
    //    0 1 2 3 4 5 6
    //  0     o o o
    //  1     o o o
    //  2 o o o o o o o
    //  3 o o o x o o o
    //  4 o o o o o o o
    //  5     o o o
    //  6     o o o

    if (row < 2 || row > 4) {
        if (column  >=2 && column <= 4)
            return true;
    }
    if (row >= 2 && row <= 4 ) {
        return true;
    }

    return false;
}

function europeanBoardCoords(column, row) {
    // check coords for English board
    //    0 1 2 3 4 5 6
    //  0     o o o
    //  1   o o o o o
    //  2 o o o o o o o
    //  3 o o o x o o o
    //  4 o o o o o o o
    //  5   o o o o o
    //  6     o o o

    if (row < 2 || row > 4) {
        if (column  >=2 && column <= 4)
            return true;
    }

    if ( (row == 1 && column == 1) ||
         (row == 5 && column == 5) ||
         (row == 1 && column == 5) ||
         (row == 5 && column == 1) )
        return true;

    if (row >= 2 && row <= 4 ) {
        return true;
    }

    return false;
}

var lastSelectedBall;
function handleClickedBall(mouseX, mouseY) {
    console.log("handleClickedBall");

    var column = Math.floor(mouseX/gameCanvas.ballSize);
    var row = Math.floor(mouseY/gameCanvas.ballSize);
    var ball = board[row][column];

    if(column >= maxColumn || column < 0 || row >= maxRow || row < 0)
        return;
    if(board[column][row] == null)
        return;

    console.log("ball at (" + column + ", " + row + ")");

    if (lastSelectedBall == null) {
        if (ball.currentState == "BALL") {
            lastSelectedBall = ball;
            lastSelectedBall.currentState = "SELECTED_BALL";
        }
        return;
    }

    // if there is lastSelectedBall
    if (ball.currentState == "BALL") {
        lastSelectedBall.currentState = "BALL";
        lastSelectedBall = ball;
        lastSelectedBall.currentState = "SELECTED_BALL";
    }

    if (ball.currentState == "HOLE"){
        capture(ball)
    }
}

function capture(currentBall) {
    console.log("let's capture!")

    var capturedBall = getCapturedBall(lastSelectedBall, currentBall);
    if (capturedBall != null) {
        capturedBall.currentState = "HOLE";
        lastSelectedBall.currentState = "HOLE";
        currentBall.currentState = "BALL";
        lastSelectedBall = null;
    }
    victoryCheck();
}

function getCapturedBall(ballBefore, ballAfter) {
    var beforeX;
    var beforeY;
    var afterX;
    var afterY;

    if (ballBefore.currentState == "SELECTED_BALL") {
        if (ballAfter.currentState == "HOLE" ) {
            beforeX = ballBefore.x / gameCanvas.ballSize;
            afterX = ballAfter.x / gameCanvas.ballSize;
            beforeY = ballBefore.y / gameCanvas.ballSize;
            afterY = ballAfter.y / gameCanvas.ballSize;

            var targetDistance = 2;
            if ((Math.abs(beforeX - afterX) != targetDistance) &&
                    (Math.abs(beforeY - afterY) != targetDistance))
                return;

            if (afterX != beforeX && afterY !=beforeY)
                return

            var capturedBallX;
            var capturedBallY;

            if (afterX > beforeX)
                capturedBallX = beforeX + 1;
            else if (afterX < beforeX)
                capturedBallX = afterX + 1;
            else
                capturedBallX = afterX;

            if (afterY > beforeY)
                capturedBallY = beforeY + 1;
            else if (afterY < beforeY)
                capturedBallY = afterY + 1;
            else
                capturedBallY = afterY;

            var capturedBall = board[capturedBallY][capturedBallX];
            if (capturedBall.currentState == "HOLE")
                return;

            console.log("Captured ball at: (" + capturedBallX + ", " + capturedBallY + ")");
            return capturedBall;
        }
    }
}

function saveHighScore(name) {
    var db = openDatabaseSync(databaseIdentifier, "1.0", "Local PegSolitaire High Scores",100);
    var dataStr = "INSERT INTO Scores VALUES(?, ?, ?)";
    var data = [name, timer.seconds, selectedBoardStyle];
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(name TEXT, time NUMBER, boardStyle TEXT)');
            tx.executeSql(dataStr, data);
        }
    );
}

function showHighscores() {
    var db = openDatabaseSync(databaseIdentifier, "1.0", "Local PegSolitaire High Scores",100);
    db.transaction(
        function(tx) {
            var englishBoard = boardStyles[english];
            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(name TEXT, time NUMBER, boardStyle TEXT)');

            var rs = tx.executeSql('SELECT * FROM Scores WHERE boardStyle = "'+englishBoard+'" ORDER BY time asc LIMIT 10');
            var r = "\nEnglish board \n\n";

            if (rs.rows.length == 0){
                r += "None!";
            } else {
                for(var i = 0; i < rs.rows.length; i++){
                    r += (i+1)+". " + rs.rows.item(i).name +': '
                            + rs.rows.item(i).time + ' seconds ' + "\n"
                }
            }
            highscoresView.setFirstColumnTxt(r);

            var europeanBoard = boardStyles[european];
            rs = tx.executeSql('SELECT * FROM Scores WHERE boardStyle = "'+europeanBoard+'" ORDER BY time asc LIMIT 10');
            r = "\nEuropean board \n\n"

            if (rs.rows.length == 0){
                r += "None!";
            } else {
                for(var i = 0; i < rs.rows.length; i++){
                    r += (i+1)+". " + rs.rows.item(i).name +': '
                            + rs.rows.item(i).time + ' seconds ' + "\n"
                }
            }
            highscoresView.setSecondColumnTxt(r);
        }
    );
}

function victoryCheck() {
    var ballCounter = 0;
    for (var row = 0; row < maxRow; row++){
        for (var column = 0; column < maxColumn; column++){
            var ball = board[row][column];
            if (ball.currentState == "BALL" && ball.visible == true ) {
                ballCounter++;
            }
        }
    }
    if (ballsToWin == ballCounter) {
        timer.enabled = false;
        view.state = "WINNER_DIALOG";
    }
}
