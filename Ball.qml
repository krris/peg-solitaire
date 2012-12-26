import QtQuick 1.1

Rectangle {
    id: root

    property string currentState

//    width: 50
//    height: 50
    radius: width *0.5
    color: "transparent"

    state: currentState
    states: [
        State {
            name: "HOLE"
            PropertyChanges {
                target: image; source: "images/hole2.png"
            }
        },
        State {
            name: "BALL"
            PropertyChanges {
                target: image; source: "images/coloredspheres/sphere-14.png";
            }
        },
        State {
            name: "SELECTED_BALL"
            PropertyChanges {
                target: image; source: "images/coloredspheres/sphere-14.png"
            }
            PropertyChanges {
                target: image; y: 0
            }

        }
    ]

    transitions: Transition {
        from: "BALL"
        to: "SELECTED_BALL"
        SequentialAnimation {
            loops: Animation.Infinite

            NumberAnimation {
                target: image
                property: "y"
                from: image.maxHeight; to: image.minHeight
                easing.type: Easing.InOutQuad; duration: 300
            }

            NumberAnimation {
                target: image
                property: "y"
                from: image.minHeight; to: image.maxHeight
                easing.type: Easing.InOutQuad; duration: 300
            }
        }
    }

    Image {
        id: shadow

        anchors.horizontalCenter: image.horizontalCenter
        y: image.width - 3
        source: "images/shadow.png"
        visible: {
            if (currentState == "HOLE")
                return false;
            else
                return true;
        }

        scale: 0.14 * ( image.y - image.maxHeight )
    }

    Image {
        id: image
        anchors.horizontalCenter: parent.horizontalCenter

        property int maxHeight: -7
        property int minHeight: 0
    }





}
