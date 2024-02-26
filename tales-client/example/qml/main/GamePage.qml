import QtQuick 2.7
import Mana 1.0

Item {
    id: gamePage;

    state: "game";

    Component.onCompleted: gamePage.forceActiveFocus();

    PlayerAttributes { id: playerAttributes }

    property int lastNpcInteractionX: -1
    property int lastNpcInteractionY: -1

    Viewport {
        id: viewport;
        width: parent.width / scale;
        height: parent.height / scale;
        scale: window.gameScale
        transformOrigin: Item.TopLeft;
        centerX: visibleArea.x + visibleArea.width / 2;

        Item {
            id: visibleArea
            anchors.top: parent.top
            anchors.left: leftPanel.right
            anchors.right:  chatLog.left
            anchors.bottom: joystick.top
        }

        HealthBar {
            anchors.horizontalCenter: visibleArea.horizontalCenter;
            width: Math.min(200, visibleArea.width)
        }

        MouseArea {
            anchors.fill: parent;
            enabled: actionBar.selectedAbility();

            onClicked: {
                var ability = actionBar.selectedAbility();
                var mapPos = viewport.toMapPos(mouse.x, mouse.y);
                gameClient.useAbilityOnPoint(ability, mapPos.x, mapPos.y);

                actionBar.reset();
            }
        }

        RespawnButton {
            id: respawnButton
            anchors.centerIn: parent
            anchors.verticalCenterOffset: height / 2 + 16
        }



        NpcDialog {
            id: npcDialog;

            property bool narrow: viewport.width - 240 < 300

            width: Math.max(300, narrow ? viewport.width * 0.8 : (viewport.width - 240) * 0.9)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: narrow ? 120 : 50

            onVisibleChanged: {
                if (!visible) {
                    gamePage.focus = true;
                }
            }
        }

        LeftPanel {
            id: leftPanel
            anchors.top: parent.top
            anchors.bottom: joystick.top
            anchors.topMargin: 3
            width: viewport.width / 2 - 22 - 32
        }




        ChatLog {
            id: chatLog
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: viewport.width * 0.25
            height: viewport.height * 0.5
        }
        Joystick {
            id: joystick
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }




        ActionBar {
            id: actionBar;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
        }
    }

    Connections {
        target: gameClient
        onShopOpened: {
            leftPanel.isShopAccessible = true;
            rightPanel.open("inventory");
            lastNpcInteractionX = gameClient.player.x;
            lastNpcInteractionY = gameClient.player.y;
        }
        onMapChanged: {
            leftPanel.isShopAccessible = false;
        }
        onPlayerDied: {
            leftPanel.isShopAccessible = false;
        }
    }

    Connections {
        target: gameClient.player

        onPositionChanged: {
            if (!leftPanel.isShopAccessible)
                return;

            var distance = Math.abs(lastNpcInteractionX - gameClient.player.x) +
                           Math.abs(lastNpcInteractionY - gameClient.player.y);

            if (distance > 3 * 32)
                leftPanel.isShopAccessible = false;
        }
    }

    Connections {
        target: gameClient
    }

    Keys.onReturnPressed: {
        // Mod + Enter is fullscreen
        if (event.modifiers === Qt.NoModifier)
            chatBar.open();
        else
            event.accepted = false;
    }
    Keys.onEnterPressed: chatBar.open();

    onFocusChanged: {
        gameClient.playerWalkDirection = Qt.vector2d(0, 0);
    }

    property bool w_pressed: false;
    property bool a_pressed: false;
    property bool s_pressed: false;
    property bool d_pressed: false;

    function updateWalkDirection() {
        var x = 0;
        var y = 0;

        if (w_pressed) --y;
        if (a_pressed) --x;
        if (s_pressed) ++y;
        if (d_pressed) ++x;

        gameClient.playerWalkDirection = Qt.vector2d(x, y);
    }

    function handleKeyEvent(event, pressed) {
        if (event.isAutoRepeat)
            return;

        switch (event.key) {
        case Qt.Key_W: w_pressed = pressed; break;
        case Qt.Key_A: a_pressed = pressed; break;
        case Qt.Key_S: s_pressed = pressed; break;
        case Qt.Key_D: d_pressed = pressed; break;
        }

        updateWalkDirection();

        if (pressed && event.key === Qt.Key_C)
            leftPanel.toggle("status");

        if (pressed && event.key === Qt.Key_I)
            rightPanel.toggle("inventory");

        if (pressed && event.key === Qt.Key_Q)
            rightPanel.toggle("quest");

        if (pressed && event.key === Qt.Key_Space)
            startTalkingToNearestNpc();

        if (pressed && event.key === Qt.Key_Up)
            strike();
    }

    function startTalkingToNearestNpc() {
        var talkTarget = gameClient.beingListModel.closestBeingAround(gameClient.player);
        if (talkTarget && talkTarget.type === Being.OBJECT_NPC) {
            gameClient.talkToNpc(talkTarget);
        }
    }

    function strike() {
        var abilityId = abilityDB.getInfoByName("Strike").id;
        gameClient.useAbilityOnDirection(abilityId);
    }

    Keys.onReleased: handleKeyEvent(event, false);
    Keys.onPressed: handleKeyEvent(event, true);
    /*
    ChatBar {
        id: chatBar;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
    }
    */


    states: [
        State {
            name: "game";
            PropertyChanges {
                target: gamePage;
                focus: true;
            }
        }
    ]

    transitions: [
        Transition {
            to: "game";
            SequentialAnimation {
                NumberAnimation {
                    property: "opacity";
                    easing.type: Easing.InOutQuad;
                }
                PropertyAction { property: "visible" }
            }
        },
        Transition {
            NumberAnimation {
                property: "opacity";
                easing.type: Easing.InOutQuad;
            }
        }
    ]
}
