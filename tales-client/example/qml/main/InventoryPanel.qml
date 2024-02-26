import QtQuick 2.0
import Mana 1.0

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        clip: true
        topMargin: 10
        bottomMargin: 5 + 24

        model: itemDB.isLoaded ? gameClient.inventoryListModel : null

        delegate: Item {
            anchors.left: parent.left
            anchors.right: parent.right

            property variant info: itemDB.getInfo(model.item.id)

            height: 36

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1

                color: Qt.rgba(0, 0, 0, 0.2)
                border.color: Qt.rgba(0, 0, 0, 0.4)
                visible: item.isEquipped
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (model.item.isEquipped)
                        gameClient.unequip(model.item.slot);
                    else
                        gameClient.equip(model.item.slot);
                }
            }

            ItemRow {
                itemInfo: info
                amount: item.amount
                value: info.value
                showValue: gameClient.shopMode !== GameClient.NoShop
            }
        }
    }

    BorderImage {
        source: "images/scroll_footer.png"
        smooth: false

        anchors.left: moneyDisplay.left
        anchors.right: moneyDisplay.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: -10
        anchors.rightMargin: -10
        anchors.bottomMargin: -1

        border.top: 7
        border.left: 7
        border.right: 7
    }
    Row {
        id: moneyDisplay
        spacing: 5

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 2

        Image {
            source: "images/icon_money.png"
            smooth: false
        }
        Text {
            text: playerAttributes.gold
            font.pixelSize: 10
            y: 3
        }
    }
}
