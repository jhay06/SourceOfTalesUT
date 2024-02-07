import QtQuick 2.0
import Mana 1.0

BorderImage {
    visible: gameClient.npcState !== GameClient.NoNpc;

    source: "images/scroll_thin.png";
    border.left: 33; border.top: 33;
    border.right: 34; border.bottom: 27;
    smooth: false;

    height: contents.height + 50 + 15
    Behavior on height {
        NumberAnimation {
            easing.type: Easing.OutCubic
        }
    }

    CompoundSprite {
        id: sprite
        x: 30
        y: 30
        being: gameClient.npc
        direction: Action.DIRECTION_DOWN
        action: "stand"
    }

    Text {
        text: gameClient.npc ? gameClient.npc.name : ""
        font.pixelSize: 13
        font.bold: true
        x: 60
        y: 15
    }

    Item {
        clip: true
        anchors.fill: parent
        anchors.bottomMargin: 8

        Column {
            id: contents

            spacing: 10

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 50
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Text {
                id: message;
                anchors.left: parent.left;
                anchors.right: parent.right;
                wrapMode: TextEdit.WordWrap;
                text: gameClient.npcMessage;
                font.pixelSize: 14
            }

            ListView {
                id: choices
                anchors.left: parent.left
                anchors.right: parent.right

                height: childrenRect.height

                spacing: 5

                property bool active: gameClient.npcState === GameClient.NpcAwaitChoice
                model: active ? gameClient.npcChoices : null
                focus: active

                delegate: BrownButton {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    property bool waitingForReply: false
                    keepPressed: waitingForReply;

                    text: modelData
                    onClicked: {
                        gameClient.chooseNpcOption(model.index);
                        waitingForReply = true;
                    }

                    ProgressIndicator {
                        id: waitForChoiceIndicator;

                        running: waitingForReply;

                        height: parent.height;
                        width: height;
                        anchors.right: parent.right;
                    }
                }
            }

            BrownButton {
                id: nextButton;

                property bool waitingForReply: false
                iconSource: "images/icon_right.png"
                keepPressed: waitingForReply;

                anchors.right: parent.right
                visible: gameClient.npcState === GameClient.NpcAwaitNext
                focus: visible

                function next() {
                    gameClient.nextNpcMessage();
                    waitingForReply = true;
                }

                onClicked: next()
                Keys.onSpacePressed: next()

                ProgressIndicator {
                    id: waitForNextIndicator;

                    anchors.centerIn: parent;

                    running: parent.waitingForReply;

                    height: parent.height;
                    width: height;
                    anchors.right: parent.right;
                }
            }

            Row {
                anchors.left: parent.left;
                anchors.right: parent.right;

                height: 32;

                visible: gameClient.npcState === GameClient.NpcAwaitNumberInput;

                LineEdit {
                    id: numberInput
                    width: parent.width * 0.45;
                    height: parent.height;
                    inputMethodHints: Qt.ImhDigitsOnly;
                    focus: parent.visible


                    Keys.onEnterPressed: okButton.submit();
                    Keys.onReturnPressed: {
                        // Mod + Enter is fullscreen
                        if (event.modifiers === Qt.NoModifier)
                            okButton.submit();
                        else
                            event.accepted = false;
                    }

                    Connections {
                        target: gameClient;
                        onNpcStateChanged: {
                            nextButton.waitingForReply = false;
                            if (gameClient.npcState === GameClient.NpcAwaitNumberInput) {
                                numberInput.text = gameClient.npcDefaultNumber;
                            }
                        }
                    }
                }

                BrownButton {
                    id: okButton
                    text: qsTr("OK")

                    function submit() {
                        var requireSecondClick = false;
                        var value = parseInt(numberInput.text.toLocaleLowerCase());
                        if (value > gameClient.npcMaximumNumber) {
                            numberInput.text = gameClient.npcMaximumNumber;
                            requireSecondClick = true;
                        }
                        if (value < gameClient.npcMinimumNumber) {
                            numberInput.text = gameClient.npcMinimumNumber;
                            requireSecondClick = true;
                        }

                        if (!requireSecondClick) {
                            gameClient.sendNpcNumberInput(value);
                            numberInput.text = "";
                        }

                        Qt.inputMethod.hide();
                    }

                    onClicked: submit();
                }
            }
        }
    }
}
