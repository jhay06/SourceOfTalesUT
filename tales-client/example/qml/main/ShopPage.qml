import QtQuick 2.0
import QtQuick.Layouts 1.1

import Mana 1.0

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        clip: true

        model: itemDB.isLoaded ? gameClient.shopListModel : null
        delegate: MouseArea {
            id: item
            property variant info: itemDB.getInfo(model.itemId)
            property bool affordable: cost <= playerAttributes.gold
            property bool extended: false

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            //height: extended ? 100 : 36
            height: layout.height

            ColumnLayout {
                id: layout
                anchors.left: parent.left
                anchors.right: parent.right

                ItemRow {
                    itemInfo: info
                    amount: model.amount
                    value: cost
                    showValue: true
                    highlightValue: !affordable
                }

                BrownButton {
                    text: "Buy"
                    visible: item.extended && affordable

                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 100

                    onClicked: {
                        onClicked: gameClient.buySell(model.itemId, 1);
                    }
                }
            }

            onClicked: {
                extended = !extended && affordable;
            }
        }
    }
}
