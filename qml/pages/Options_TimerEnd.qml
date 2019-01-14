import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0


import "../lib/"


Page {
    id: page
    property Options options
//    property Appstate  appstate
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
            PageHeader { title: qsTr("slumber Actions") }

            SectionHeader {

//                visible: timerEnabledSwitch.checked
                text: qsTr('when the timer runs out')
//                color: Theme.secondaryColor
            }

            Column {
                width: parent.width
                TextSwitch {
                    id:timerpauseEnabledSwitch
                    text: qsTr( "Pause local media")

                    checked: options.timerPauseEnabled
                    onClicked: {
                        options.timerPauseEnabled = checked
                    }
                    description: qsTr('Only works in native Applications')
                }
            }
            Column {
                id:timerkodi

                width: parent.width
                TextSwitch {
                    id:timerkodipauseEnabledSwitch
                    text: qsTr( "Pause Kodi")

                    checked: options.timerKodiPauseEnabled
                    onClicked: {
                        options.timerKodiPauseEnabled = checked


                    }
                    description: qsTr('Pauses Kodi on your local network')

                }
                Column {
                    x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                    width: parent.width - x

                    Label {
                        id:timerkodimoteLabel

                        visible: timerkodipauseEnabledSwitch.checked && options.timerKodiPauseHost
                        text: qsTr("(Hint: If you use kodimote, you don't need to enable this. It works as a 'local' player.)")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge

                    }
                    TextField {
                        id: timerkodiPauseHostField
                        width: parent.width
                        visible: timerkodipauseEnabledSwitch.checked
                        placeholderText: qsTr('IP or host:port for Kodi')
                        label: qsTr('IP or host:port for Kodi')
                        text: options.timerKodiPauseHost
                        onTextChanged: {
                            options.timerKodiPauseHost = text
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
                        visible: timerkodipauseEnabledSwitch.checked && !!(options.timerKodiPauseHost)

                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        placeholderText: qsTr('Kodi username')
                        label: qsTr('Kodi username')
                        text: options.timerKodiPauseUser

                        onTextChanged: {
                            options.timerKodiPauseUser = text
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
                        visible: timerkodipauseEnabledSwitch.checked && !!(options.timerKodiPauseHost) && !!(options.timerKodiPauseUser)
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        placeholderText: qsTr('Kodi password')
                        label: qsTr('Kodi password')
                        text: options.timerKodiPausePassword

                        onTextChanged: {
                            options.timerKodiPausePassword = text
                        }
                        EnterKey.onClicked: {
                            timerkodiPausePasswordField.focus = false
                        }
                    }

                    Row {
                        width: parent.width - Theme.paddingLarge*2
                        height: timerkodiPauseTestButton.height
                        spacing: Theme.paddingLarge
                        visible: timerkodipauseEnabledSwitch.checked
                        x: Theme.paddingLarge
                        Button {

                            id: timerkodiPauseTestButton
                            visible: timerkodipauseEnabledSwitch.checked && options.timerKodiPauseHost
                            text: qsTr('Check Host')
                            anchors.leftMargin: Theme.paddingLarge
                            anchors.rightMargin: Theme.paddingLarge
                            enabled: !pingBusyIndicatorKodi.running
                            onClicked: {
                                pingBusyIndicatorKodi.running = true
                                globals.actionPauseKodi.ping(function(o,success){

                                    pingBusyIndicatorKodi.running = false
                                    console.log('ping successful:', success);
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

                        visible: timerkodipauseEnabledSwitch.checked && options.timerKodiPauseHost
                        text: qsTr("You can try to ping the current Kodi configuration")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge

                    }


                }


            }








            Column {
                id:timerVLC
                width: parent.width
                TextSwitch {
                    id:timerVLCpauseEnabledSwitch
                    text: qsTr( "Pause VLC")

                    checked: options.timerVLCPauseEnabled
                    onClicked: {
                        options.timerVLCPauseEnabled = checked


                    }
                    description: qsTr('Pauses VLC on your local network')

                }
                Column {
                    x:Theme.itemSizeExtraSmall - Theme.paddingLarge
                    width: parent.width - x

                    TextField {
                        id: timerVLCPauseHostField
                        width: parent.width
                        visible: timerVLCpauseEnabledSwitch.checked
                        placeholderText: qsTr('IP or host:port for VLC')
                        label: qsTr('IP or host:port for VLC')
                        text: options.timerVLCPauseHost
                        onTextChanged: {
                            options.timerVLCPauseHost = text
                        }

                        EnterKey.iconSource: !!text ? "image://theme/icon-m-enter-next":"image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            if(!!text){
                                timerVLCPausePasswordField.focus = true
                            }
                            focus = false;
                        }
                    }
//                    TextField {
//                        id: timerVLCPauseUserField
//                        width: parent.width
//                        visible: timerVLCpauseEnabledSwitch.checked && !!(options.timerVLCPauseHost)

//                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
//                        placeholderText: qsTr('VLC username')
//                        label: qsTr('VLC username')
//                        text: options.timerVLCPauseUser

//                        onTextChanged: {
//                            options.timerVLCPauseUser = text
//                        }
//                        EnterKey.onClicked: {
//                            if(!!text){
//                                timerVLCPausePasswordField.focus = true
//                            }
//                            focus = false;
//                        }
//                    }

                    TextField {
                        id: timerVLCPausePasswordField
                        width: parent.width
                        echoMode: TextInput.Password
                        visible: timerVLCpauseEnabledSwitch.checked && !!(options.timerVLCPauseHost)
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        placeholderText: qsTr('VLC password')
                        label: qsTr('VLC password')
                        text: options.timerVLCPausePassword

                        onTextChanged: {
                            options.timerVLCPausePassword = text
                        }
                        EnterKey.onClicked: {
                            timerVLCPausePasswordField.focus = false
                        }
                    }

                    Row {
                        width: parent.width - Theme.paddingLarge*2
                        height: timerVLCPauseTestButton.height
                        spacing: Theme.paddingLarge
                        visible: timerVLCpauseEnabledSwitch.checked
                        x: Theme.paddingLarge
                        Button {

                            id: timerVLCPauseTestButton
                            visible: timerVLCpauseEnabledSwitch.checked && options.timerVLCPauseHost
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

                        visible: timerVLCpauseEnabledSwitch.checked && options.timerVLCPauseHost
                        text: qsTr("You can try to ping the current VLC configuration")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge

                    }


                }


            }


            Column {
                width: parent.width
                TextSwitch {
                    id:timerbtEnabledSwitch
                    text: qsTr( "Disable Bluetooth")

                    checked: options.timerDisableBluetoothEnabled
                    onClicked: {
                        options.timerDisableBluetoothEnabled = checked
                    }
                    description: qsTr('Useful if you\'re low on power')
                }
            }



//            Column {
//                width: parent.width
//                Button {
//                    text: "Launch Programs ("+options.timerActionRunCommands.length+")"
//                    onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerEnd_Programs.qml"), {options:options, firstPage:page})
//                    x:Theme.paddingLarge
//                    anchors.leftMargin: Theme.paddingLarge
//                    anchors.rightMargin: Theme.paddingLarge
//                }
//            }
            SectionHeader {

//                visible: timerEnabledSwitch.checked
                text: qsTr('ten seconds before end')
//                color: Theme.secondaryColor
            }

            TextSwitch {
                id:timerFadeVisualEffectEnabledSwitch
                text: qsTr('Visual Indicator')

                checked: options.timerFadeVisualEffectEnabled
                onClicked: {
                    options.timerFadeVisualEffectEnabled = checked
                }
                description: qsTr('Flashes the main screen before the Timer is running out')
            }

            TextSwitch {
                id:timerFadeSoundEnabledSwitch
                text: qsTr('Sound Effect')

                checked: options.timerFadeSoundEffectEnabled
                onClicked: {
                    options.timerFadeSoundEffectEnabled = checked
                }
                description: qsTr('To alert you that the Timer is running out')
            }


            ComboBox {
                id:fadesoundeffect
                visible: timerFadeSoundEnabledSwitch.checked
                width: parent.width
                label: qsTr('Sound')

                currentIndex: -1
                property int readIndex: 0+currentIndex

                menu: ContextMenu {
                    id: timeropts

                    Repeater {
                        model: ListModel {
                            dynamicRoles: true
                        }
                        Component.onCompleted: {

                            model.append({"value": 'cassette-noise',
                                                    "text":qsTr('cassette noise')});
                            model.append({"value": 'clock-ticking',
                                                    "text":qsTr('clock ticking')});
                            model.append({"value": 'sea-waves', "text":qsTr('sail a jolla')});
                        }
                        MenuItem {
                            text: model.text ? model.text + '' : '-'

                            onClicked: {
                                    options.timerFadeSoundEffectFile = model.value;
                                    options.timerFadeSoundEffectEnabled = true;
                            }

                            Component.onCompleted: {
                                if(model.value === options.timerFadeSoundEffectFile) {
                                    fadesoundeffect.currentIndex = index
                                }

                            }
                        }

                    }

                }


            }

            Slider {
                id: userSlider

                visible: timerFadeSoundEnabledSwitch.checked

                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                value: options.timerFadeSoundEffectVolume
                label: qsTr("Sound Effect volume")
                onValueChanged: {
                    options.timerFadeSoundEffectVolume = value
                }
            }
            Item {
                width:parent.width
                height: Theme.paddingLarge
            }
            Button {
                visible: timerFadeSoundEnabledSwitch.checked
                text: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ? qsTr('stop playing'):  qsTr('play current sound')


                x:Theme.paddingLarge

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

//                visible: timerEnabledSwitch.checked
                checked: options.timerFadeEnabled
                onClicked: {
                    if(checked){
                        timerFadeResetEnabledSwitch.height = 0
                        timerFadeResetEnabledSwitch.opacity = 0

                        timerFadeResetEnabledSwitch.visible = true
                        timerFadeResetEnabledSwitchFadein.start()
                        timerFadeResetEnabledSwitchHeightin.start()
                    } else {
                        timerFadeResetEnabledSwitch.visible = true
                        timerFadeResetEnabledSwitchFadeout.start()
                        timerFadeResetEnabledSwitchHeightout.start()
                    }

                    options.timerFadeEnabled = checked
                }
                description: qsTr('Lowers System Volume to 0 (ca the last 10 seconds of the timer)')
            }
            TextSwitch {
                id:timerFadeResetEnabledSwitch
                text: qsTr('Reset Volume afterwards')

                visible: timerFadeEnabledSwitch.checked
                height: timerFadeEnabledSwitch.checked ? timerFadeResetEnabledSwitch.implicitHeight:0;
                opacity: checked ? 1:0;

                PropertyAnimation {id: timerFadeResetEnabledSwitchFadeout; target: timerFadeResetEnabledSwitch; properties: "opacity"; to: 0.0; duration: 200}
                PropertyAnimation {id: timerFadeResetEnabledSwitchFadein; target: timerFadeResetEnabledSwitch; properties: "opacity";
                    to: 1.0;
                    duration: 200}

                PropertyAnimation {id: timerFadeResetEnabledSwitchHeightout; target: timerFadeResetEnabledSwitch; properties: "height"; to: 0.0; duration: 200}
                PropertyAnimation {id: timerFadeResetEnabledSwitchHeightin; target: timerFadeResetEnabledSwitch; properties: "height";
                    to: timerFadeResetEnabledSwitch.implicitHeight;
                    duration: 200}



                checked: options.timerFadeResetEnabled
                onClicked: {
                    options.timerFadeResetEnabled = checked
                }
                description: qsTr('Reset System Volume to previous level afterwards. Should be enabled for most use cases.')
            }

            Item {
                width:parent.width
                height: Theme.paddingLarge
            }




//            TextSwitch {
//                enabled: false
//                text: 'Disable Screen Blank'

//                visible:timerEnabledSwitch.checked
//                //checked: options.timerFadeSoundEffectEnabled
////                onClicked: {
////                    options.timerFadeSoundEffectEnabled = checked
////                }
//                description: 'This option is not working yet. (QML ScreenSaver does not seem to change anything on a Jolla.)'
//            }

        }
    }
}
