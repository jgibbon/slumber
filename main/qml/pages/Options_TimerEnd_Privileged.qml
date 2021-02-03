import QtQuick 2.6
import Sailfish.Silica 1.0
import de.gibbon.slumber 1.0
import "../lib/"


Page {
    id: page

    property FirstPage firstPage

    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation

    property bool rightsGranted: false
    property bool rightsChecked: false

    Launcher {
        id: privLauncher
        Component.onCompleted: {
            page.rightsGranted = checkPrivilegedLauncher();
            page.rightsChecked = true;
//            console.log('alright?', alright)
//            if(!alright) {
//                var result = preparePrivilegedLauncher('PW');
//                console.log('result', result);

//                alright = checkPrivilegedLauncher();
//                console.log('alright?', alright)
//            }
//            result = launchPrivileged("dbus-send --system --print-reply --dest=net.connman /net/connman/technology/bluetooth net.connman.Technology.SetProperty string:\"Powered\" variant:boolean:false")
//            console.log('does it work?', result);
        }
    }

    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn

            PageHeader {

                //: Page Header: Like other actions (when the timer runs out), but requiring administrative rights (root)
                //~ Context Page Header: Privileged Actions (when the timer runs out) require administrative rights (root)
                title: qsTr("Privileged Actions")
            }

            Column {
                width: parent.width
                move: Transition {
                    NumberAnimation { properties: "x,y"; duration: 300 }
                }
                Column {
                    visible: page.rightsChecked && !page.rightsGranted
                    width: parent.width


                    Label {
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                        text: qsTr("You need to enable Developer Mode and grant privileged access rights once by supplying your root password. Slumber will not save this password and you'll be able to revoke the granted rights at any time. Slumber does not require Developer Mode to remain enabled after these privileges have been granted.")
                    }

                    Item {
                        id: pwWrongContainer
                        width: parent.width
                        height: pwWrong.isWrong ? pwWrong.contentHeight + Theme.paddingMedium * 2 : 0;
                        clip: true
                        Behavior on height { PropertyAnimation {} }
//                        visible: pwWrong.visible
                        Rectangle {
                            color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                            anchors.fill: parent
                        }

                        Label {
                            id: pwWrong
                            property bool isWrong: false
                            opacity: isWrong ? 1.0 : 0.0

                            Behavior on opacity{ PropertyAnimation {} }
//                            visible: true
                            width: parent.width  - (Theme.horizontalPageMargin * 2)
                            x: Theme.horizontalPageMargin
                            y: Theme.paddingMedium
                            height: contentHeight
//                            anchors.centerIn: parent
//                            anchors.topMargin: Theme.paddingMedium
//                            anchors.bottomMargin: Theme.paddingMedium
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                            color: Theme.highlightColor

                            text: qsTr("Granting rights failed. Did you enable Developer Mode and enter the right password?");
                        }
                    }


                    TextField {
                        id: passwordField
                        property bool checkedAndPwWrong: false
                        width: parent.width
                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText: qsTr('root password')
                        label: qsTr('root password')
                        text: ''
                        onTextChanged: {
    //                        settings.timerKodiPauseHost = text
                        }

                        EnterKey.iconSource: !!text ? "image://theme/icon-m-enter-next":"image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            if(!!text){
                                var pwCorrect = privLauncher.checkRootPassword(text);
                                console.log('pw correct?', pwCorrect);
                                if(!pwCorrect) {
                                    pwWrong.isWrong = true;
                                    passwordField.focus = false;
                                    passwordField.forceActiveFocus();
                                } else {
                                    pwWrong.isWrong = false;
                                    privLauncher.preparePrivilegedLauncher(text);
                                    page.rightsGranted = privLauncher.checkPrivilegedLauncher();
                                    passwordField.focus = false;
                                }

                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    visible: page.rightsChecked && page.rightsGranted
                    spacing: Theme.paddingMedium

                    Label {
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                        text: qsTr("Privileged access rights are granted. Revoke them by pressing the button below.")
                    }
                    Button {
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                        //: Button Text: click to remove privileged rights
                        //~ Context Button Text: click to remove privileged rights
                        text: qsTr('Revoke rights')
                        onClicked: {
                            privLauncher.revokePrivilegedLauncher();
                            page.rightsGranted = privLauncher.checkPrivilegedLauncher();
                        }
                    }
                }
            }


            Column {
                width: parent.width
                SectionHeader {
                    //: Section Header: System commands section
                    //~ Context Section Header: System commands section
                    text: qsTr('System')
                }

                TextSwitch {
                    //: Text Switch: Action "Lock the screen"
                    //~ Text Switch: Action "Lock the screen"
                    text: qsTr( "Lock Screen")
                    enabled: page.rightsGranted
                    checked: settings.timerLockScreenEnabled
                    onClicked: {
                        settings.timerLockScreenEnabled = checked
                    }
                }
                TextSwitch {
                    //: Text Switch: Action "Stop Alien Dalvik service"
                    //~ Text Switch: Action "Stop Alien Dalvik service"
                    text: qsTr( "Stop Alien Dalvik")
                    enabled: page.rightsGranted
                    checked: settings.timerStopAlienEnabled
                    onClicked: {
                        settings.timerStopAlienEnabled = checked
                    }
                }

                SectionHeader {
                    //: Section Header: Connectivity commands section
                    //~ Context Section Header: Connectivity commands section
                    text: qsTr('Connectivity')
                }
                TextSwitch {
                    //: Text Switch: Action "Enable Airplane Mode"
                    //~ Text Switch: Action "Enable Airplane Mode"
                    text: qsTr( "Enable Airplane Mode")
                    enabled: page.rightsGranted
                    checked: settings.timerAirplaneModeEnabled
                    onClicked: {
                        settings.timerAirplaneModeEnabled = checked
                    }
                }

                TextSwitch {
                    //: Text Switch: Action "Disable Wifi/wlan"
                    //~ Text Switch: Action "Disable Wifi/wlan"
                    text: qsTr( "Disable Wifi")
                    enabled: page.rightsGranted
                    checked: settings.timerDisableWLANEnabled
                    onClicked: {
                        settings.timerDisableWLANEnabled = checked
                    }
                }

                TextSwitch {
                    //: Text Switch: Action "Disable Bluetooth"
                    //~ Text Switch: Action "Disable Bluetooth"
                    text: qsTr( "Disable Bluetooth")
                    enabled: page.rightsGranted
                    checked: settings.timerDisableBluetoothEnabled
                    onClicked: {
                        settings.timerDisableBluetoothEnabled = checked
                    }
                }
                TextSwitch {
                    //: Text Switch: Action "Restart ofono Service"
                    //~ Text Switch: Action "Restart ofono Service"
                    text: qsTr( "Restart ofono Service")
                    enabled: page.rightsGranted
                    checked: settings.timerRestartOfonoEnabled
                    onClicked: {
                        settings.timerRestartOfonoEnabled = checked
                    }
                    //: Text Switch description: Action "Restart ofono Service"
                    //~ Text Switch description: Action "Restart ofono Service"
                    description: qsTr( "On some combinations of devices and bluetooth accessories, ofono sometimes gets stuck at 100% CPU load after disconnecting. Use this as a workaround.")
                }

            }

            Item {
                width:parent.width
                height: Theme.paddingLarge
            }
        }
    }
}
