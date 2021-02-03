import QtQuick 2.6
import Sailfish.Silica 1.0

import "../lib/"


Page {
    id: page

    property FirstPage firstPage

    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation

    function request(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(xhr.readyState === XMLHttpRequest.DONE) {
                    callback(myxhr);
                }
            }
        })(xhr);
        xhr.open('GET', url, true);
        xhr.send('');
    }

    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge

            PageHeader { title: qsTr("slumber Actions") }

            SectionHeader {

                //                visible: timerEnabledSwitch.checked
                text: qsTr('when the timer runs out')
                //                color: Theme.secondaryColor
            }

            TextSwitch {
                id:timerpauseEnabledSwitch
                text: qsTr( "Pause local media")

                checked: settings.timerPauseEnabled
                onClicked: {
                    settings.timerPauseEnabled = checked
                }
                description: qsTr('Only works in native Applications')
            }

            TextSwitch {
                id:timerkodipauseEnabledSwitch
                text: qsTr( "Pause Kodi")

                checked: settings.timerKodiPauseEnabled
                onClicked: {
                    settings.timerKodiPauseEnabled = checked


                }
                description: qsTr('Pauses Kodi on your local network')

            }
            Column {
                x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                width: parent.width - x
                visible: timerkodipauseEnabledSwitch.checked
//                move: Transition {
//                    NumberAnimation { properties: "x,y"; duration: 300 }
//                }
                Label {
                    id:timerkodimoteLabel

//                    visible: timerkodipauseEnabledSwitch.checked// && settings.timerKodiPauseHost
                    text: qsTr("(Hint: If you use kodimote, you don't need to enable this. It works as a 'local' player.)")
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
                    placeholderText: qsTr('IP or host:port for Kodi')
                    label: qsTr('IP or host:port for Kodi')
                    text: settings.timerKodiPauseHost
                    onTextChanged: {
                        settings.timerKodiPauseHost = text
                    }

                    EnterKey.iconSource: !!text ? "image://theme/icon-m-enter-next":"image://theme/icon-m-enter-close"
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

                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    placeholderText: qsTr('Kodi username')
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
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    placeholderText: qsTr('Kodi password')
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
                                    timerkodiPingLabel.text = qsTr('Host works fine!')
                                } else {
                                    if(o.status === 0){
                                        timerkodiPingLabel.text = qsTr('No response from host')
                                    } else if(o.status === 404){
                                        timerkodiPingLabel.text = qsTr('Kodi not found on host')
                                    } else if(o.status === 401){
                                        timerkodiPingLabel.text = qsTr('Username/Password incorrect')
                                    } else {
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
                    text: qsTr("You can try to ping the current Kodi configuration")
                    color: Theme.secondaryColor

                    font.pixelSize: Theme.fontSizeExtraSmall
                    verticalAlignment: Text.AlignBottom


                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.horizontalPageMargin * 2)
                    x: Theme.horizontalPageMargin

                }


                ComboBox {
                    id:kodisecondaryaction
                    visible: timerFadeSoundEnabledSwitch.checked
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






            TextSwitch {
                id:timerVLCpauseEnabledSwitch
                text: qsTr( "Pause VLC")

                checked: settings.timerVLCPauseEnabled
                onClicked: {
                    settings.timerVLCPauseEnabled = checked


                }
                description: qsTr('Pauses VLC on your local network')

            }
            Column {
                x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                width: parent.width - x

                visible: timerVLCpauseEnabledSwitch.checked
//                move: Transition {
//                    NumberAnimation { properties: "x,y"; duration: 300 }
//                }
                TextField {
                    id: timerVLCPauseHostField
                    width: parent.width
                    placeholderText: qsTr('IP or host:port for VLC')
                    label: qsTr('IP or host:port for VLC')
                    text: settings.timerVLCPauseHost
                    onTextChanged: {
                        settings.timerVLCPauseHost = text
                    }

                    EnterKey.iconSource: !!text ? "image://theme/icon-m-enter-next":"image://theme/icon-m-enter-close"
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
                    visible: (settings.timerVLCPauseHost !== "")
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    placeholderText: qsTr('VLC password')
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
                        visible: settings.timerVLCPauseHost !== ""
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
                                    timerVLCPingLabel.text = qsTr('Host works fine!')
                                } else {
                                    if(o.status === 0){
                                        timerVLCPingLabel.text = qsTr('No response from host')
                                    } else if(o.status === 404){
                                        timerVLCPingLabel.text = qsTr('VLC not found on host')
                                    } else if(o.status === 401){
                                        timerVLCPingLabel.text = qsTr('Username/Password incorrect')
                                    } else {
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

                    visible: settings.timerVLCPauseHost !== ""
                    text: qsTr("You can try to ping the current VLC configuration")
                    color: Theme.secondaryColor

                    font.pixelSize: Theme.fontSizeExtraSmall
                    verticalAlignment: Text.AlignBottom


                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.horizontalPageMargin * 2)
                    x: Theme.horizontalPageMargin

                }


            }



            TextSwitch {
                id:timerBTDisconnectEnabledSwitch
                // Text Switch: Action Bluetooth Disconnect
                //: Switch: Action "Disconnect Bluetooth Devices"
                text: qsTr( "Disconnect Bluetooth Devices")

                checked: settings.timerBTDisconnectEnabled
                onClicked: {
                    settings.timerBTDisconnectEnabled = checked


                }
                // TextSwitch Description: Action Bluetooth Disconnect
                //: TextSwitch Description: Action "Disconnect Bluetooth Devices"
                description: qsTr('Disconnects active Bluetooth connections')

            }
            TextSwitch {
                id:timerBTDisconnectOnlyAudioEnabled
                // TextSwitch: Do not disconnect all Bluetooth devices, only Audio
                //: TextSwitch: Do not disconnect all Bluetooth devices, only Audio
                text: qsTr( "Only disconnect Audio Devices")
                enabled: settings.timerBTDisconnectEnabled
                checked: settings.timerBTDisconnectOnlyAudioEnabled
                onClicked: {
                    settings.timerBTDisconnectOnlyAudioEnabled = checked


                }
                description: qsTr('Limits Bluetooth disconnects to audio devices like Speakers')

            }

            HighlightImageButton {
                // Button Text: Like other actions (when the timer runs out), but requiring administrative rights (root)
                //: ButtonText: Privileged Actions (when the timer runs out) require administrative rights (root)
                text: qsTr("Privileged Actions");
                icon.source: "image://theme/icon-m-developer-mode"
                onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerEnd_Privileged.qml"), {firstPage:firstPage})

                width: parent.width - (Theme.horizontalPageMargin * 2)
                x: Theme.horizontalPageMargin

            }


            SectionHeader {
                text: qsTr('ten seconds before end')
            }

            TextSwitch {
                id:timerFadeVisualEffectEnabledSwitch
                text: qsTr('Visual Indicator')

                checked: settings.timerFadeVisualEffectEnabled
                onClicked: {
                    settings.timerFadeVisualEffectEnabled = checked
                }
                description: qsTr('Flashes the main screen before the Timer is running out')
            }

            TextSwitch {
                id:timerNotificationEnabledSwitch
                text: qsTr( "Notification")

                checked: settings.timerNotificationTriggerEnabled
                onClicked: {
                    settings.timerNotificationTriggerEnabled = checked
                }
                description: qsTr('Display a Notification shortly before the Timer runs out. Notifications activate the Screen and, with it, Accelerometer readings.')
            }

            TextSwitch {
                id:timerFadeSoundEnabledSwitch
                text: qsTr('Sound Effect')

                checked: settings.timerFadeSoundEffectEnabled
                onClicked: {
                    settings.timerFadeSoundEffectEnabled = checked
                }
                description: qsTr('To alert you that the Timer is running out')
            }


            ComboBox {
                id:fadesoundeffect
                visible: timerFadeSoundEnabledSwitch.checked
                width: parent.width
                label: qsTr('Sound')
                property var sounds: ['cassette-noise', 'clock-ticking', 'sea-waves']
                currentIndex: -1
                function activate(id) {
                    settings.timerFadeSoundEffectFile = sounds[id];
                    settings.timerFadeSoundEffectEnabled = true;
                }
                Component.onCompleted: {
                    currentIndex = sounds.indexOf(settings.timerFadeSoundEffectFile);
                }

                menu: ContextMenu {
                    id: timeropts
                    MenuItem {
                        text: qsTr('cassette noise')
                        onClicked: fadesoundeffect.activate(0)
                    }

                    MenuItem {
                        text: qsTr('clock ticking')
                        onClicked: fadesoundeffect.activate(1)
                    }

                    MenuItem {
                        text: qsTr('sail a jolla')
                        onClicked: fadesoundeffect.activate(2)
                    }
                }


            }

            Slider {
                id: userSlider

                visible: timerFadeSoundEnabledSwitch.checked

                width: parent.width
//                anchors.horizontalCenter: parent.horizontalCenter
                value: settings.timerFadeSoundEffectVolume
                label: qsTr("Sound Effect volume")
                onValueChanged: {
                    settings.timerFadeSoundEffectVolume = value
                }
            }
            Item {
                width:parent.width
                height: Theme.paddingLarge
            }


            HighlightImageButton {
                visible: timerFadeSoundEnabledSwitch.checked
                text: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ? qsTr('stop playing'):  qsTr('play current sound')

                icon.source: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"
                width: parent.width - (Theme.horizontalPageMargin * 2)
                x: Theme.horizontalPageMargin

                onClicked: {
                    if(globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing){
                        globals.fadeOutSound.stop()
                    } else {
                        globals.accelerometerTrigger.paused = true
                        globals.fadeOutSound.play()
                    }
                }

            }

            TextSwitch {
                id:timerFadeEnabledSwitch
                text: qsTr('Fade out when falling asleep')

                checked: settings.timerFadeEnabled
                onClicked: {
                    settings.timerFadeEnabled = checked
                }
                description: qsTr('Lowers System Volume to 0 (ca the last 10 seconds of the timer)')
            }
            TextSwitch {
                id:timerFadeResetEnabledSwitch
                text: qsTr('Reset Volume afterwards')

                visible: timerFadeEnabledSwitch.checked
                height: timerFadeEnabledSwitch.checked ? timerFadeResetEnabledSwitch.implicitHeight:0;
                opacity: visible ? 1:0;
                onHeightChanged: {
                    if(height > 0) {
                        listView.scrollToBottom()
                    }
                }

                checked: settings.timerFadeResetEnabled
                onClicked: {
                    settings.timerFadeResetEnabled = checked
                }
                description: qsTr('Reset System Volume to previous level afterwards. Should be enabled for most use cases.')
            }
        }
    }
}
