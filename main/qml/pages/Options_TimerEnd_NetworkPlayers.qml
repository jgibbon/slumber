import QtQuick 2.6
import Sailfish.Silica 1.0

import '../lib/'


Page {
    id: page

    allowedOrientations: Orientation.All


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: grid.height

        VerticalScrollDecorator{}
        //: PageHeader: Options to pause network players (kodi/vlc)
        PageHeader { id: pageHeader; title: qsTr('Network Players') }
        SettingsGrid {
            id: grid
            topPadding: pageHeader.height
            Column {
                width: parent.columnWidth

                TextSwitch {
                    id:timerkodipauseEnabledSwitch
                    //: TextSwitch: Pause Kodi when timer runs out
                    text: qsTr( 'Pause Kodi')

                    checked: settings.timerKodiPauseEnabled
                    onClicked: {
                        settings.timerKodiPauseEnabled = checked
                    }
                    //: TextSwitch description: Pause Kodi when timer runs out
                    description: qsTr('Pauses Kodi on your local network')

                }
                Column {
                    x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                    width: parent.width - x
                    visible: timerkodipauseEnabledSwitch.checked
                    Label {
                        id:timerkodimoteLabel

    //                    visible: timerkodipauseEnabledSwitch.checked// && settings.timerKodiPauseHost
                        //: Label text: use kodimote instead of this to pause kodi ;)
                        text: qsTr('(Hint: If you use kodimote, you don\'t need to enable this. It works as a \'local\' player.)')
                        color: Theme.highlightColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin

                    }
                    TextField {
                        id: timerkodiPauseHostField
                        width: parent.width
    //                    visible: timerkodipauseEnabledSwitch.checked
                        //: TextField placeholder for kodi settings
                        placeholderText: qsTr('IP or host:port for Kodi')

                        //: TextField label for kodi settings
                        label: qsTr('IP or host:port for Kodi')
                        text: settings.timerKodiPauseHost
                        onTextChanged: {
                            settings.timerKodiPauseHost = text
                        }

                        EnterKey.iconSource: !!text ? 'image://theme/icon-m-enter-next':'image://theme/icon-m-enter-close'
                        EnterKey.onClicked: {
                            if(!!text){
                                timerkodiPauseUserField.focus = true
                            }
                            focus = false;
                        }
                    }
                    TextField {
                        id: timerkodiPauseUserField
                        width: parent.width
                        visible: settings.timerKodiPauseHost !== ''

                        EnterKey.iconSource: 'image://theme/icon-m-enter-next'
                        //: TextField placeholder for kodi settings
                        placeholderText: qsTr('Kodi username')
                        //: TextField label for kodi settings
                        label: qsTr('Kodi username')
                        text: settings.timerKodiPauseUser

                        onTextChanged: {
                            settings.timerKodiPauseUser = text
                        }
                        EnterKey.onClicked: {
                            if(!!text){
                                timerkodiPausePasswordField.focus = true
                            }
                            focus = false;
                        }
                    }

                    TextField {
                        id: timerkodiPausePasswordField
                        width: parent.width
                        echoMode: TextInput.Password
                        visible: (settings.timerKodiPauseHost !== '') && !!(settings.timerKodiPauseUser !== '')
                        EnterKey.iconSource: 'image://theme/icon-m-enter-close'
                        //: TextField placeholder for kodi settings
                        placeholderText: qsTr('Kodi password')
                        //: TextField label for kodi settings
                        label: qsTr('Kodi password')
                        text: settings.timerKodiPausePassword

                        onTextChanged: {
                            settings.timerKodiPausePassword = text
                        }
                        EnterKey.onClicked: {
                            timerkodiPausePasswordField.focus = false
                        }
                    }

                    Row {
                        width: parent.width - Theme.horizontalPageMargin*2
                        height: timerkodiPauseTestButton.height
                        spacing: Theme.paddingLarge
    //                    visible: timerkodipauseEnabledSwitch.checked
                        x: Theme.horizontalPageMargin
                        Button {

                            id: timerkodiPauseTestButton
                            visible: settings.timerKodiPauseHost !== ''
                            //: Button text: test if kodi is reachable
                            text: qsTr('Check Host')
                            anchors.leftMargin: Theme.paddingLarge
                            anchors.rightMargin: Theme.paddingLarge
                            enabled: !pingBusyIndicatorKodi.running
                            onClicked: {
                                pingBusyIndicatorKodi.running = true
                                globals.actionPauseKodi.ping(function(o,success){

                                    pingBusyIndicatorKodi.running = false
                                    console.log('ping successful:', success, o.responseText);
                                    if(success){
                                        //: Label text: Kodi host is OK
                                        timerkodiPingLabel.text = qsTr('Host works fine!')
                                    } else {
                                        if(o.status === 0){
                                            //: Label text: Kodi host is unreachable
                                            timerkodiPingLabel.text = qsTr('No response from host')
                                        } else if(o.status === 404){
                                            //: Label text: Kodi not running on host
                                            timerkodiPingLabel.text = qsTr('Kodi not found on host')
                                        } else if(o.status === 401){
                                            //: Label text: Kodi authentication failed
                                            timerkodiPingLabel.text = qsTr('Username/Password incorrect')
                                        } else {
                                            //: Label text: Kodi didn't work for some unknown reason
                                            timerkodiPingLabel.text = qsTr('Unknown Error')
                                        }
                                    }

                                });
                            }
                        }


                        BusyIndicator {
                            id: pingBusyIndicatorKodi
                            y: parent.height / 4
                            size: BusyIndicatorSize.Small
                            height: parent.height / 2
                            width: parent.height / 2
                            running: false
                            visible: true
                        }
                    }


                    Label {
                        id:timerkodiPingLabel

                        visible: settings.timerKodiPauseHost !== ''
                        //: Label text: Describing "Check Host" button
                        text: qsTr('You can try to ping the current Kodi configuration')
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin

                    }


                    ComboBox {
                        id:kodisecondaryaction
                        visible: timerkodipauseEnabledSwitch.checked
                        width: parent.width
                        // ComboBox: Kodi secondary Action on reset
                        //: ComboBox Kodi secondary Action on reset
                        label: qsTr('Secondary Action')
                        property var actions: ['', 'System.Suspend', 'System.Shutdown']
                        currentIndex: -1
                        function activate(id) {
                            settings.timerKodiSecondaryCommand = actions[id];
                        }
                        Component.onCompleted: {
                            currentIndex = actions.indexOf(settings.timerKodiSecondaryCommand);
                        }

                        menu: ContextMenu {
    //                        id: kodisecondaryopts
                            MenuItem {
                                // ContextMenu: Kodi secondary Option: None
                                //: ContextMenu: Kodi secondary Option: None
                                text: qsTr('None')
                                onClicked: kodisecondaryaction.activate(0)
                            }

                            MenuItem {
                                // ContextMenu: Kodi secondary Option: Suspend
                                //: ContextMenu: Kodi secondary Option: Suspend
                                text: qsTr('Suspend Kodi System')
                                onClicked: kodisecondaryaction.activate(1)
                            }

                            MenuItem {
                                // ContextMenu: Kodi secondary Option: Shutdown
                                //: ContextMenu: Kodi secondary Option: Shutdown
                                text: qsTr('Shutdown Kodi System')
                                onClicked: kodisecondaryaction.activate(2)
                            }
                        }


                    }
                }
            }




            Column {
                width: parent.columnWidth



                TextSwitch {
                    id:timerVLCpauseEnabledSwitch
                    //: TextSwitch: Pause vlc via network
                    text: qsTr( 'Pause VLC')

                    checked: settings.timerVLCPauseEnabled
                    onClicked: {
                        settings.timerVLCPauseEnabled = checked


                    }
                    //: TextSwitch description: Pause vlc via network
                    description: qsTr('Pauses VLC on your local network')

                }
                Column {
                    x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                    width: parent.width - x

                    visible: timerVLCpauseEnabledSwitch.checked
    //                move: Transition {
    //                    NumberAnimation { properties: 'x,y'; duration: 300 }
    //                }
                    TextField {
                        id: timerVLCPauseHostField
                        width: parent.width
                        //: TextField placeholder for kodi settings
                        placeholderText: qsTr('IP or host:port for VLC')
                        //: TextField label for kodi settings
                        label: qsTr('IP or host:port for VLC')
                        text: settings.timerVLCPauseHost
                        onTextChanged: {
                            settings.timerVLCPauseHost = text
                        }

                        EnterKey.iconSource: !!text ? 'image://theme/icon-m-enter-next':'image://theme/icon-m-enter-close'
                        EnterKey.onClicked: {
                            if(!!text){
                                timerVLCPausePasswordField.focus = true
                            }
                            focus = false;
                        }
                    }

                    TextField {
                        id: timerVLCPausePasswordField
                        width: parent.width
                        echoMode: TextInput.Password
                        visible: (settings.timerVLCPauseHost !== '')
                        EnterKey.iconSource: 'image://theme/icon-m-enter-close'
                        //: TextField placeholder for vlc settings
                        placeholderText: qsTr('VLC password')
                        //: TextField label for vlc settings
                        label: qsTr('VLC password')
                        text: settings.timerVLCPausePassword

                        onTextChanged: {
                            settings.timerVLCPausePassword = text
                        }
                        EnterKey.onClicked: {
                            timerVLCPausePasswordField.focus = false
                        }
                    }

                    Row {
                        width: parent.width - Theme.paddingLarge*2
                        height: timerVLCPauseTestButton.height
                        spacing: Theme.paddingLarge
    //                    visible: timerVLCpauseEnabledSwitch.checked
                        x: Theme.paddingLarge
                        Button {

                            id: timerVLCPauseTestButton
                            visible: settings.timerVLCPauseHost !== ''
                            //: Button text: test if vlc is reachable
                            text: qsTr('Check Host')
                            anchors.leftMargin: Theme.paddingLarge
                            anchors.rightMargin: Theme.paddingLarge
                            enabled: !pingBusyIndicatorVLC.running
                            onClicked: {
                                pingBusyIndicatorVLC.running = true
                                globals.actionPauseVLC.ping(function(o,success){

                                    pingBusyIndicatorVLC.running = false
                                    console.log('ping successful:', success);
                                    if(success){
                                        //: Label text: VLC host is OK
                                        timerVLCPingLabel.text = qsTr('Host works fine!')
                                    } else {
                                        if(o.status === 0){
                                            //: Label text: VLC host is unreachable
                                            timerVLCPingLabel.text = qsTr('No response from host')
                                        } else if(o.status === 404){
                                            //: Label text: VLC not running on host
                                            timerVLCPingLabel.text = qsTr('VLC not found on host')
                                        } else if(o.status === 401){
                                            //: Label text: VLC authentication failed
                                            timerVLCPingLabel.text = qsTr('Username/Password incorrect')
                                        } else {
                                            //: Label text: VLC didn't work for some unknown reason
                                            timerVLCPingLabel.text = qsTr('Unknown Error')
                                        }
                                    }
                                });
                            }
                        }

                        BusyIndicator {
                            id: pingBusyIndicatorVLC
                            y: parent.height / 4
                            size: BusyIndicatorSize.Small
                            height: parent.height / 2
                            width: parent.height / 2
                            running: false
                            visible: true
                        }
                    }


                    Label {
                        id:timerVLCPingLabel

                        visible: settings.timerVLCPauseHost !== ''
                        //: Label text: Describing "Check Host" button
                        text: qsTr('You can try to ping the current VLC configuration')
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin

                    }


                }
            }

        }
    }
}
