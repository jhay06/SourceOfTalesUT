
import QtQuick.Window 2.0

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
/**
 * This is the mobile version of the QML based Mana client.
 */
Client {
    id: client

    width: 1280
    height: 720

    contentOrientation: Qt.LandscapeOrientation /*{
        if (Screen.orientation == Qt.InvertedLandscapeOrientation)
            Qt.InvertedLandscapeOrientation;
        else
            Qt.LandscapeOrientation;
    }
    */

    MainView {
        id: root
        objectName: 'mainView'
        applicationName: 'sourcetales.jhayproject'
        automaticOrientation: true
    anchors.fill: parent
    MainWindow { anchors.fill: parent; }


    }


}

