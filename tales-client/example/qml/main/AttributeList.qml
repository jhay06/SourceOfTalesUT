import QtQuick 2.0
import QtQuick.Layouts 1.0

GridLayout {
    columns: 2
    rowSpacing: 5
    columnSpacing: 5

    anchors.left: parent.left
    anchors.right: parent.right

    property int itemWidth: width / 2 - columnSpacing

    property bool changesPlanned:
        pointsToDistribute !== gameClient.attributePoints ||
        pointsToCorrect !== gameClient.correctionPoints

    property int pointsToDistribute: gameClient.attributePoints
                                     - strength.plannedChange
                                     - agility.plannedChange
                                     - dexterity.plannedChange
                                     - vitality.plannedChange
                                     - intelligence.plannedChange
                                     - willpower.plannedChange
    property int pointsToCorrect: gameClient.correctionPoints
                                  + Math.min(strength.plannedChange, 0)
                                  + Math.min(agility.plannedChange, 0)
                                  + Math.min(dexterity.plannedChange, 0)
                                  + Math.min(vitality.plannedChange, 0)
                                  + Math.min(intelligence.plannedChange, 0)
                                  + Math.min(willpower.plannedChange, 0)

    property variant plannedChanges: [
        {
            id: playerAttributes.attributeToId("strength"),
            raise: strength.plannedChange,
        },
        {
            id: playerAttributes.attributeToId("agility"),
            raise: agility.plannedChange,
        },
        {
            id: playerAttributes.attributeToId("dexterity"),
            raise: dexterity.plannedChange,
        },
        {
            id: playerAttributes.attributeToId("vitality"),
            raise: vitality.plannedChange,
        },
        {
            id: playerAttributes.attributeToId("intelligence"),
            raise: intelligence.plannedChange,
        },
        {
            id: playerAttributes.attributeToId("willpower"),
            raise: willpower.plannedChange,
        },
    ]

    function resetChanges() {
        strength.plannedChange = 0;
        agility.plannedChange = 0;
        dexterity.plannedChange = 0;
        vitality.plannedChange = 0;
        intelligence.plannedChange = 0;
        willpower.plannedChange = 0;

        strength.extended = false;
        agility.extended = false;
        dexterity.extended = false;
        vitality.extended = false;
        intelligence.extended = false;
        willpower.extended = false;
    }

    function limitPrecision(number, precision) {
        var p = Math.pow(10, precision);
        var roundedValue =  Math.round(number * p) / p;

        return roundedValue.toString();
    }

    AttributeEdit {
        id: strength
        name: qsTr("Strength")
        value: playerAttributes.strength

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 0
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
    }

    ColumnLayout {
        AttributeLabel {
            name: qsTr("Damage")
            value: {
                var base = playerAttributes.damage;
                var min = Math.round(base);
                var max = Math.round(base + playerAttributes.damageDelta);
                return min + "-" + max;
            }
        }

        Layout.row: 0
        Layout.column: 1
        Layout.preferredWidth: parent.itemWidth
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    AttributeEdit {
        id: agility
        name: qsTr("Agility")
        value: playerAttributes.agility

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 1
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    ColumnLayout {
        spacing: 5

        AttributeLabel {
            name: qsTr("Movement speed")
            value: limitPrecision(playerAttributes.movementSpeed, 1)
        }

        AttributeLabel {
            name: qsTr("Dodge")
            value: limitPrecision(playerAttributes.dodge, 1)
        }

        Layout.row: 1
        Layout.column: 1
        Layout.preferredWidth: parent.itemWidth
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    AttributeEdit {
        id: dexterity
        name: qsTr("Dexterity")
        value: playerAttributes.dexterity

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 3
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    ColumnLayout {
        AttributeLabel {
            name: qsTr("Hit chance")
            value: limitPrecision(playerAttributes.hitChance, 1)
        }

        Layout.row: 3
        Layout.column: 1
        Layout.preferredWidth: parent.itemWidth
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    AttributeEdit {
        id: vitality
        name: qsTr("Vitality")
        value: playerAttributes.vitality

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 4
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    ColumnLayout {
        spacing: 5

        AttributeLabel {
            name: qsTr("Health")
            value: playerAttributes.maxHealth
        }

        AttributeLabel {
            name: qsTr("Regeneration")
            value: limitPrecision(playerAttributes.healthRegeneration / 10, 2) + "/s"
        }

        AttributeLabel {
            name: qsTr("Defense")
            value: limitPrecision(playerAttributes.defense, 1)
        }

        Layout.row: 4
        Layout.column: 1
        Layout.preferredWidth: parent.itemWidth
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    AttributeEdit {
        id: intelligence
        name: qsTr("Intelligence")
        value: playerAttributes.intelligence

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 7
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }

    AttributeEdit {
        id: willpower
        name: qsTr("Willpower")
        value: playerAttributes.willpower

        allowedIncrease: pointsToDistribute
        allowedDecrease: pointsToCorrect

        Layout.row: 8
        Layout.column: 0
        Layout.preferredWidth: parent.itemWidth
        Layout.preferredHeight: height
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop;
    }
}

