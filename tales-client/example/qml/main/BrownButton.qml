import QtQuick 2.0
import QtQuick.Controls 2.7

/**
 * A brown button suitable for use on scrolls.
 */
Button {
    id: control

    implicitHeight: Math.max(sizeLabel.height + 2 * 5, 20)+ 15

    property bool keepPressed: false
    property var iconSource
    background: BorderImage {
        source: {
            if (control.pressed || control.keepPressed)
                "images/scroll_button_pressed.png"
            else if (control.focus)
                "images/scroll_button_focused.png"
            else
                "images/scroll_button.png"
        }

        smooth: false

        border.bottom: 5
        border.top: 5
        border.right: 5
        border.left: 5
    }
    contentItem: Item {
        Text {
            id: label
            text: control.text
            color: "#3f2b25"
            font.pixelSize: 14
            wrapMode: Text.WordWrap

            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 7
            anchors.leftMargin: 7
        }

        Image {
            id: icon
            source: control.iconSource
            anchors.centerIn: parent
            smooth: false
        }

        states: [
            State {
                name: "pressed"
                when: control.pressed || control.keepPressed
                PropertyChanges {
                    target: label
                    anchors.verticalCenterOffset: 1
                }
                PropertyChanges {
                    target: icon
                    anchors.verticalCenterOffset: 1
                }
            },
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: label
                    opacity: 0.7
                }
            }
        ]
    }
   /*
    style: ButtonStyle {
        background: BorderImage {
            source: {
                if (control.pressed || button.keepPressed)
                    "images/scroll_button_pressed.png"
                else if (button.focus)
                    "images/scroll_button_focused.png"
                else
                    "images/scroll_button.png"
            }

            smooth: false

            border.bottom: 5
            border.top: 5
            border.right: 5
            border.left: 5
        }

        label: Item {
            Text {
                id: label
                text: control.text
                color: "#3f2b25"
                font.pixelSize: 14
                wrapMode: Text.WordWrap

                anchors.right: parent.right
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 7
                anchors.leftMargin: 7
            }

            Image {
                id: icon
                source: control.iconSource
                anchors.centerIn: parent
                smooth: false
            }

            states: [
                State {
                    name: "pressed"
                    when: control.pressed || button.keepPressed
                    PropertyChanges {
                        target: label
                        anchors.verticalCenterOffset: 1
                    }
                    PropertyChanges {
                        target: icon
                        anchors.verticalCenterOffset: 1
                    }
                },
                State {
                    name: "disabled"
                    when: !control.enabled
                    PropertyChanges {
                        target: label
                        opacity: 0.7
                    }
                }
            ]
        }
    }
    */

    Text {
        id: sizeLabel
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 7
        anchors.leftMargin: 7
        visible: false
        text: control.text
        font.pixelSize: 14
        wrapMode: Text.WordWrap
    }
}
