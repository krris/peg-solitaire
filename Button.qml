import QtQuick 1.1

Rectangle {
    id: root

    property string text
    property alias font: btnLabel.font

    width: btnLabel.width + 20
    height: btnLabel.height + 5
    smooth: true
    radius: 5
    color: mouseArea.containsMouse ? activePalette.highlight : activePalette.button

    signal btnClicked

    MouseArea {
        id: mouseArea

        anchors.fill: root
        hoverEnabled: true
        onClicked: root.btnClicked();
    }

    Text {
        id: btnLabel

        smooth: true
        anchors.centerIn: root
        text: root.text
        font.pointSize: 14
    }

    SystemPalette {
        id: activePalette
    }

    onBtnClicked: {
        console.log("Button clicked")
    }
}
