import QtQuick 2.0
import QtQuick.Layouts 1.0

MouseArea {
    id: attributeEdit

    property alias name: label.name
    property string value: ""
    property bool extended: false
    property int plannedChange: 0

    property int allowedIncrease: 0
    property int allowedDecrease: 0

    height: 14 + (extended ? 30 : 0)

    onClicked: extended = !extended

    ColumnLayout {
        spacing: 5

        anchors.left: parent.left
        anchors.right: parent.right

        AttributeLabel {
            id: label
            value: {
                var value = attributeEdit.value;
                if (plannedChange === 0)
                    return value;

                var color = plannedChange < 0 ? 'red' : 'green';
                value += ' <font color="' + color + '">';
                if (plannedChange > 0)
                    value += '+';

                value += plannedChange + '</font>';
                return value;
            }
        }

        RowLayout {
            spacing: 5

            visible: attributeEdit.extended

            BrownButton {
                text: "-"
                Layout.fillWidth: true


                onClicked: {
                    if (allowedDecrease > 0 || plannedChange > 0)
                        --plannedChange;
                }
            }

            BrownButton {
                text: "+"
                Layout.fillWidth: true

                onClicked: {
                    if (allowedIncrease > 0)
                        ++plannedChange;
                }
            }

            Layout.fillWidth: true
        }
    }
}

