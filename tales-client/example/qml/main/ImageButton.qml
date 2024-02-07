import QtQuick 2.0
import QtQuick.Controls 2.7
//import QtQuick.Controls.Styles 1.0

Button {
    id: control;

    property string baseName: "images/roundbutton"
    property alias imagePath: image.source
    background: Image {
        smooth: false;
        source: {
            if (control.pressed)
                return baseName + "_pressed.png";
            return baseName + ".png";
        }
    } /*
    style: ButtonStyle {
        background:
    }
*/
    Image {
        id: image
        smooth: false;
        anchors.centerIn: parent;
        source: imagePath;
    }

    states: [
        State {
            name: "pressed"
            when: control.pressed
            PropertyChanges {
                target: control;
                anchors.horizontalCenterOffset: 1;
                anchors.verticalCenterOffset: 1;
            }
        }
    ]
}
