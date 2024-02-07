import QtQuick 2.0
import Mana 1.0

Rectangle {
    property variant client;
    property string label;

    width: 10;
    height: 10;
    radius: 5;

    color: {
        var state = client.state;
        if (state === ENetClient.Connected)
            return "green";
        else if (state === ENetClient.Disconnected)
            return "red";

        return "orange";
    }

    Text {
        anchors.centerIn: parent

        text: label
        font.pixelSize: parent.height
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: "PointingHandCursor"
        onClicked: client.disconnect();
    }
}
