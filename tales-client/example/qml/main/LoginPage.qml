import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7
import Mana 1.0
import "." as A
Rectangle{
    id: loginPage
    anchors.fill: parent
    Settings { id: settings }
    color:"#00000000"
    function login() {
        print("Logging in as " + nameEdit.text + "...");
        loggingIn = true;
        errorLabel.clear();
        settings.setValue("username", nameEdit.text)
        accountClient.login(nameEdit.text, passwordEdit.text);
        Qt.inputMethod.hide();
    }

    function registerOrLogin() {
        if (loginPage.state == "register")
            register();
        else
            login();
    }


    Keys.onReturnPressed: {
        // Mod + Enter is fullscreen
        if (event.modifiers ===  Qt.NoModifier)
            registerOrLogin();
        else
            event.accepted = false;
    }
    Keys.onEnterPressed: registerOrLogin();
    Connections {
        target: accountClient;

        onLoginFailed: errorLabel.showError(errorMessage);
        onRegistrationFailed: errorLabel.showError(errorMessage);
        onDisconnected: errorLabel.showError(qsTr("Connection was lost!"))
    }




    Image {
        id: img
        source: "images/sourceoftales.png"
        width : parent.width * 0.7
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }
    ColumnLayout{
        width:parent.width

        spacing: 3

        y: img.height + 50
        LineEdit {

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth:  loginPage.width * 0.35
            Layout.preferredHeight: loginPage.height * 0.10
            id: nameEdit;
            focus: true;
            placeholderText: qsTr("Username");
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase;
            maximumLength: accountClient.maximumNameLength;

            Component.onCompleted: {
                text = settings.value("username", "");
                if (text !== "")
                    passwordEdit.focus = true;
            }

            KeyNavigation.down: passwordEdit;
        }

        LineEdit {
            id: emailEdit;
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth:  loginPage.width * 0.35
            Layout.preferredHeight: loginPage.height * 0.10
            placeholderText: qsTr("Email");
            visible: false;
            opacity: 0;
            height: 0;
            inputMethodHints: Qt.ImhEmailCharactersOnly;

            KeyNavigation.down: passwordEdit;
            KeyNavigation.up: nameEdit;
        }
        LineEdit {
            id: passwordEdit;

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth:  loginPage.width * 0.35
            Layout.preferredHeight: loginPage.height * 0.10
            placeholderText: qsTr("Password");
            echoMode: TextInput.Password;
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData |
                              Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText |
                              Qt.ImhPreferLowercase;

            KeyNavigation.up: nameEdit;
            KeyNavigation.down: loginButton;
        }
        LineEdit {
            id: passwordConfirmEdit;
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth:  loginPage.width * 0.35
            Layout.preferredHeight: loginPage.height * 0.10
            placeholderText: qsTr("Password");
            echoMode: TextInput.Password;
            inputMethodHints: passwordEdit.inputMethodHints;
            visible: false;
            opacity: 0;
            height: 0;

            KeyNavigation.up: passwordEdit;
            KeyNavigation.down: loginButton;
        }

        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            A.Button {
                id: cancelButton;
                text: qsTr("Cancel");
                visible: false;
                Layout.preferredWidth:  loginPage.width * 0.15
                Layout.preferredHeight: loginPage.height * 0.10
                opacity: 0;
                onClicked: loginPage.state = "";
                KeyNavigation.up: passwordConfirmEdit;
                KeyNavigation.right: loginButton;
            }
            A.Button {
                id: loginButton;
                text: qsTr("Login");
                Layout.preferredWidth:  loginPage.width * 0.15
                Layout.preferredHeight: loginPage.height * 0.10
                KeyNavigation.up: passwordEdit;

                enabled: accountClient.state == AccountClient.Connected &&
                         !loggingIn && !loggedIn;

                onClicked: login();
            }
        }
        ErrorLabel {
            id: errorLabel;
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 24
        }

    }


    Image {
        id: registrationBar;
        source: "images/bottombar.png";
        width: parent.width;
        y: parent.height;
        visible: false;

        TextShadow { target: questionText; }
        Text {
            id: questionText;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: 2;
            x: 20;
            text: qsTr("Don't have an account yet?");
            font.pixelSize: 35;
            color: "white";
        }

        A.Button {
            id: registerButton;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: 2;
            anchors.right: parent.right;
            anchors.rightMargin: 20;
            text: qsTr("Sign Up");
            width: parent.width * 0.15
            height: loginPage.height * 0.10
            onClicked: loginPage.state = "register";
            enabled: accountClient.state == AccountClient.Connected &&
                     !loggingIn && !loggedIn && accountClient.registrationAllowed;
        }
        states: [
            State {
                name: "visible";
                when: registerButton.enabled && loginPage.state != "register";
                PropertyChanges {
                    target: registrationBar;
                    y: parent.height - height;
                    visible: true;
                }
            }
        ]
        transitions: [
            Transition {
                to: ""
                SequentialAnimation {
                    NumberAnimation { property: "y"; easing.type: Easing.OutQuad; }
                    PropertyAction { property: "visible"; }
                }
            },
            Transition {
                to: "visible"
                NumberAnimation {
                    property: "y";
                    easing.type: Easing.OutQuad;
                }
            }
        ]
    }

    states: [
        State {
            name: "register"
            PropertyChanges { target: nameEdit; KeyNavigation.down: emailEdit; }
            PropertyChanges { target: emailEdit; visible: true; opacity: 1; height: emailEdit.implicitHeight; }
            PropertyChanges {
                target: passwordEdit;
                KeyNavigation.up: emailEdit;
                KeyNavigation.down: passwordConfirmEdit;
            }
            PropertyChanges { target: passwordConfirmEdit; visible: true; opacity: 1; height: passwordConfirmEdit.implicitHeight; }
            PropertyChanges { target: cancelButton; visible: true; opacity: 1; }
            AnchorChanges { target: loginButton; anchors.left: cancelButton.right; }
            PropertyChanges {
                target: loginButton;
                text: qsTr("Register");
                anchors.leftMargin: 10;
                KeyNavigation.left: cancelButton;
                KeyNavigation.up: passwordConfirmEdit;
                onClicked: register();
            }
        }
    ]

    transitions: [
        Transition {
            to: "register";
            PropertyAction { property: "text"; }
            NumberAnimation { properties: "opacity"; easing.type: Easing.InQuint; }
            NumberAnimation { properties: "height,y,leftMargin"; easing.type: Easing.InOutQuad; }
            AnchorAnimation { easing.type: Easing.InOutQuad; }
        },
        Transition {
            to: "";
            SequentialAnimation {
                ParallelAnimation {
                    PropertyAction { property: "text"; }
                    NumberAnimation { properties: "opacity"; easing.type: Easing.OutQuart; }
                    NumberAnimation { properties: "height,y,leftMargin"; easing.type: Easing.InOutQuad; }
                    AnchorAnimation { easing.type: Easing.InOutQuad; }
                }
                PropertyAction { property: "visible"; }
            }
        }
    ]


}
