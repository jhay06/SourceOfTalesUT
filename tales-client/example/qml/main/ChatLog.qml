import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7
import Mana 1.0
import "." as A
import QtGraphicalEffects 1.0

Item {
    property int maxHeight;
    height: 100
    Keys.onEnterPressed: {

        if(chatInput.focus){
            sayText();
        }
    }
    ListModel { id: chatModel }
    Connections {
        target: gameClient
        onChatMessage: {
            var name = being ? being.name : qsTr("Server");
            chatModel.insert(0, { name: name, message: message });
            chatView.positionViewAtBeginning();
        }
    }
    Rectangle{
        color:"#80000000"
        anchors.fill: parent
        anchors.leftMargin: -9
        anchors.rightMargin: -9
        border.color:"#964B00"
        border.width:  2
        smooth: false
        clip:true
        radius: 10
        ColumnLayout{
            anchors.fill: parent


            ListView {
                clip: true
                id: chatView
                model: chatModel
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalLayoutDirection: ListView.BottomToTop
                delegate: Item {
                    height: messageLabel.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    TextShadow { target: nameLabel }
                    TextShadow { target: messageLabel }
                    Text {
                        id: nameLabel
                        color: "BurlyWood"
                        font.bold: true
                        font.pixelSize: 12
                        text: "<" + model.name + ">"
                        textFormat: Text.PlainText
                    }
                    Text {
                        id: messageLabel
                        color: "beige"
                        font.pixelSize: 12
                        text: model.message
                        textFormat: Text.PlainText
                        wrapMode: Text.Wrap
                        anchors.left: nameLabel.right
                        anchors.right: parent.right
                        anchors.leftMargin: 5
                    }
                }
            }
            Frame{
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.18
                background:Rectangle{
                    color:"#00000000"
                }
                padding:0
                leftPadding:  10
                rightPadding: 10
                topPadding:  5
                bottomPadding: 5
                RowLayout{
                    anchors.fill: parent
                    TextField{
                        id: chatInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        background:Rectangle{
                            color: "#30FFFFFF"
                            border.color: "#000000"
                            border.width: 1
                            radius: 5
                        }
                        color: "#000000"
                        placeholderTextColor: "#e8e8e8"
                        placeholderText: "Say something"
                        font.pixelSize: 10




                    }
                    Button {
                        id: sayButton;
                        Layout.preferredWidth: parent.width * 0.25
                        Layout.fillHeight: true
                        text: "Say";
                        clip:true
                        font.pixelSize: 12

                        background :
                                Image{
                                    id: img
                                    source:"images/bigbutton.png"
                                    layer.enabled: true
                                    layer.effect: OpacityMask {
                                            maskSource: Item {
                                                width: img.width
                                                height: img.height
                                                Rectangle {
                                                    anchors.fill: parent
                                                    radius:  10
                                                }
                                            }
                                        }
                                }

                      contentItem: Text{
                            text: sayButton.text
                            color:"#00263D"
                            font: sayButton.font
                            anchors.centerIn: sayButton
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                      }



                         onClicked: sayText()
                         KeyNavigation.left: chatInput;
                    }
                }
            }



        }
    }
    function sayText() {
        if (chatInput.text != "") {
            gameClient.say(chatInput.text);
            chatInput.text = "";
        }

    }

}
