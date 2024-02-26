import QtQuick 2.7
import QtQuick.Controls 2.7
import QtGraphicalEffects 1.0
/**
 * A TextField in Mana style
 */
TextField {
    anchors.margins: 5;
    clip:true
    font.pixelSize: (height - 10) * 0.5;
    color: "#000000"
//    textColor: "black"
    placeholderTextColor: "#888888"

    rightPadding: 20
    leftPadding: 20
    background:  Rectangle{
        clip:true

        radius: 20
        border.width:  1

    }



    layer.enabled: true
    layer.effect: DropShadow{
        horizontalOffset: 3
        verticalOffset: 1
        color: "#80e8e8e8"
    }
       /*
    style: TextFieldStyle {
        background: BorderImage {
            source: "images/lineedit.png"
            border.bottom: 20;
            border.top: 20;
            border.right: 20;
            border.left: 20;
        }

        padding.right: 12
        padding.left: 12
    }*/
}
