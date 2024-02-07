import QtQuick 2.0

MouseArea {
    id: leftPanel

    state: "closed"

    property string page: "status"

    property bool toggleOnClick: false

    readonly property bool partlyVisible: x > -width

    property bool isShopAccessible: false

    function toggle(_page) {
        if (state == "closed") {
            page = _page;
            state = "open";
        } else if (page !== _page) {
            page = _page;
        } else {
            state = "closed";
        }
    }

    function openOrClose() {
        var open = -leftPanel.x < leftPanel.width / 2;
        leftPanel.state = ""  // hack to make sure to trigger transition
        leftPanel.state = open ? "open" : "closed";
    }

    drag.target: leftPanel;
    drag.axis: Drag.XAxis;
    drag.minimumX: -leftPanel.width;
    drag.maximumX: 0;
    drag.filterChildren: true
    onReleased: openOrClose();

    Image {
        id: statusTab
        source: "images/tab.png"
        smooth: false

        anchors.left: parent.right
        anchors.leftMargin: -3
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 6
        z: page == "status" ? 1 : 0

        Image {
            source: "images/tab_icon_character.png"
            anchors.centerIn: parent
            smooth: false
        }
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5

            drag.target: leftPanel;
            drag.axis: Drag.XAxis;
            drag.minimumX: -leftPanel.width;
            drag.maximumX: 0;

            onPressed: {
                toggleOnClick = leftPanel.state == "closed" || page == "status";
                page = "status";
            }
            onClicked: if (toggleOnClick) toggle("status");
            onReleased: openOrClose();
        }
    }

    Image {
        id: shopTab
        source: "images/tab.png"
        smooth: false

        anchors.left: statusTab.left
        anchors.top: statusTab.bottom
        anchors.topMargin: 10
        z: page == "shop" ? 1 : 0

        visible: isShopAccessible

        Image {
            source: "images/tab_icon_trade.png"
            anchors.centerIn: parent
            smooth: false
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -5

            drag.target: leftPanel;
            drag.axis: Drag.XAxis;
            drag.minimumX: -leftPanel.width;
            drag.maximumX: 0;

            onPressed: {
                toggleOnClick = leftPanel.state == "closed" || page == "shop";
                page = "shop";
            }
            onClicked: if (toggleOnClick) toggle("shop");
            onReleased: openOrClose();
        }
    }

    BorderImage {
        anchors.fill: parent
        anchors.leftMargin: -33
        anchors.rightMargin: -1

        source: "images/scroll_medium_horizontal.png"
        border.left: 38; border.top: 31
        border.right: 40; border.bottom: 32
        smooth: false
        visible: partlyVisible
    }

    Item {
        id: contents

        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 7
        anchors.rightMargin: 26

        visible: partlyVisible

        StatusPage {
            visible: page == "status"
        }

        ShopPage {
            visible: page == "shop"
        }
    }

    ScrollTitle {
        text: page == "status" ? qsTr("Character") : qsTr("Shop")
        anchors.horizontalCenterOffset: -14
        visible: partlyVisible
    }

    onIsShopAccessibleChanged: {
        if (isShopAccessible) {
            page = "shop";
            state = "open";
        } else {
            state = "closed";
        }
    }

    states: [
        State {
            name: "open";
            PropertyChanges {
                target: leftPanel
                x: 0
            }
        },
        State {
            name: "closed";
            PropertyChanges {
                target: leftPanel
                x: -leftPanel.width
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "x"; easing.type: Easing.OutQuad }
        }
    ]
}
