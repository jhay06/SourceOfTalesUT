import QtQuick 2.0
import QtQuick.Layouts 1.1

RowLayout {
    property variant itemInfo
    property int value: 0
    property int amount: 1
    property bool showValue: false
    property bool highlightValue: false

    anchors.fill: parent
    anchors.topMargin: 2
    anchors.leftMargin: 2
    anchors.rightMargin: 4

    Item {
        implicitHeight: 32
        implicitWidth: 32

        Image {
            id: itemGraphic
            // TODO: use imageprovider for this + handling dye
            source: resourceManager.dataUrl + resourceManager.itemIconsPrefix + itemInfo.image
            smooth: false

        }

        Rectangle {
            color: "black"
            radius: 6
            opacity: 0.5
            visible: amount > 1

            anchors.centerIn: amountLabel
            width: amountLabel.width + 10
            height: amountLabel.height + 4
        }

        Text {
            id: amountLabel
            text: amount
            font.pixelSize: 8
            color: "white"
            visible: amount > 1

            anchors.right: itemGraphic.right
            anchors.rightMargin: 5
            anchors.bottom: itemGraphic.bottom
            anchors.bottomMargin: 4
        }
    }

    Text {
        text: itemInfo.name;
        elide: Text.ElideRight
        font.pixelSize: 12
        clip: true

        Layout.fillWidth: true
    }

    Text {
        text: value
        font.pixelSize: 12
        color: highlightValue ? "red" : "black"

        visible: showValue
    }

    Image {
        source: "images/icon_money.png"
        smooth: false

        visible: showValue
    }
}

