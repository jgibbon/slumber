import QtQuick 2.6
import Sailfish.Silica 1.0

import '../lib/'


Page {
    id: page

    allowedOrientations: Orientation.All


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge
            //: Page Header: Finalize options (just before the timer runs out)
            PageHeader { title: qsTr('Finalize') }

            Label {
                width: parent.width - (Theme.horizontalPageMargin * 2)
                x: Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                //: Text Label: Finalize options (just before the timer runs out)
                text: qsTr('You can set a custom duration at the end of the timer in which some finalizing actions happen, for example to get your attention in case you didn\'t fall asleep, yet.')
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
            }


            Slider {
                id: finalizingSlider
                width: parent.width
//                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 5
                maximumValue: 45
                stepSize: 1
                value: settings.timerFinalizingSeconds
                valueText: value+'s'
                label: qsTr('Finalize duration')
                animateValue: false
                onPressedChanged: {
                    if(!pressed) {

                        settings.timerFinalizingSeconds = value

                        // in case the value couldn't be set (too big)
                        value = settings.timerFinalizingSeconds
                    }
                }
            }

            SettingsGrid {

                TextSwitch {
                    id:timerFadeEnabledSwitch
                    //: TextSwitch: Fade out system volume while finalizing
                    text: qsTr('Fade out when falling asleep')

                    checked: settings.timerFadeEnabled
                    onClicked: {
                        settings.timerFadeEnabled = checked
                    }
                    //: TextSwitch description: Fade out system volume while finalizing
                    description: qsTr('Lowers System Volume to 0')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
                TextSwitch {
                    id:timerFadeResetEnabledSwitch
                    //: TextSwitch: Restore system volume after fading it out
                    text: qsTr('Reset Volume afterwards')

                    enabled: timerFadeEnabledSwitch.checked
//                    height: timerFadeEnabledSwitch.checked ? timerFadeResetEnabledSwitch.implicitHeight:0;
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
                    //: TextSwitch description: Restore system volume after fading it out
                    description: qsTr('Reset System Volume to previous level afterwards. Should be enabled for most use cases.')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                    height: implicitHeight + Theme.paddingLarge
                }

                SettingsSectionButton {
                    //: Button Text: go to sound effect options
                    buttonText: qsTr('Sound Effects')
                    icon.source: 'image://theme/icon-m-alarm'
                    //: Button Description: go to sound effect options
                    text: qsTr('See sound effects options to set a sound to play while finalizing.')
                    clickTarget: Qt.resolvedUrl('Options_SoundEffects.qml')
                }

//                TextSwitch {
//                    id:timerFadeSoundEnabledSwitch
//                    //: TextSwitch: Play sound effect while finalizing
//                    text: qsTr('Sound Effect')

//                    checked: settings.timerFadeSoundEffectEnabled
//                    onClicked: {
//                        settings.timerFadeSoundEffectEnabled = checked
//                    }
//                    //: TextSwitch description: Play sound effect while finalizing
//                    description: qsTr('To alert you that the timer is running out')
//                    width: parent.columnWidth
//                    leftMargin: 0
//                    rightMargin: 0
//                }


//                ComboBox {
//                    id:fadesoundeffect
//                    enabled: timerFadeSoundEnabledSwitch.checked
//                    width: parent.columnWidth
//                    //: ComboBox: choose one of the following sounds
//                    label: qsTr('Sound')
//                    property var sounds: ['cassette-noise', 'clock-ticking', 'sea-waves']
//                    currentIndex: -1
//                    function activate(id) {
//                        settings.timerFadeSoundEffectFile = sounds[id];
//                        settings.timerFadeSoundEffectEnabled = true;
//                    }
//                    Component.onCompleted: {
//                        currentIndex = sounds.indexOf(settings.timerFadeSoundEffectFile);
//                    }

//                    menu: ContextMenu {
//                        id: timeropts
//                        MenuItem {
//                            //: ComboBox entry: sound name
//                            text: qsTr('cassette noise')
//                            onClicked: fadesoundeffect.activate(0)
//                        }

//                        MenuItem {
//                            //: ComboBox entry: sound name
//                            text: qsTr('clock ticking')
//                            onClicked: fadesoundeffect.activate(1)
//                        }

//                        MenuItem {
//                            //: ComboBox entry: sound name
//                            text: qsTr('sail a jolla')
//                            onClicked: fadesoundeffect.activate(2)
//                        }
//                    }
//                }


//                TextSwitch {
//                    id:timerSoundEffectVolumeRelativeEnabledSwitch
//                    //: TextSwitch: Sound effects volume is relative to active media volume
//                    text: qsTr('Relative Volume')

//                    checked: settings.timerSoundEffectVolumeRelativeEnabled
//                    onClicked: {
//                        settings.timerSoundEffectVolumeRelativeEnabled = checked
//                    }
//                    //: TextSwitch description: Play sound effect while finalizing
//                    description: qsTr('Set sound effect volume relative to media volume')
//                    width: parent.columnWidth
//                    leftMargin: 0
//                    rightMargin: 0
//                }


//                Slider {
//                    id: userSlider

//                    enabled: timerFadeSoundEnabledSwitch.checked
//                    opacity: enabled ? 1.0 : 0.5

////                    width: parent.width
//    //                anchors.horizontalCenter: parent.horizontalCenter
//                    value: settings.timerFadeSoundEffectVolume
//                    //: Slider label: sound effect volume
//                    label: qsTr('Sound Effect volume')
//                    onValueChanged: {
//                        settings.timerFadeSoundEffectVolume = value
//                    }
//                    width: parent.columnWidth
//                    leftMargin: 0
//                    rightMargin: 0
//                    height: implicitHeight + (parent.columns > 1 ? Theme.paddingLarge : 0)
//                }
//                Column {
//                    width: parent.columnWidth
//                    bottomPadding: Theme.paddingLarge
//                    HighlightImageButton {
//                        enabled: timerFadeSoundEnabledSwitch.checked
//                        text: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ?
//                                  //: Button Text: stop sound effect preview
//                                  qsTr('stop playing'):
//                                  //: Button Text: start sound effect preview
//                                  qsTr('play current sound')

//                        icon.source: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ? 'image://theme/icon-m-pause' : 'image://theme/icon-m-play'
//                        width: parent.width

//                        onClicked: {
//                            if(globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing){
//                                globals.fadeOutSound.stop()
//                            } else {
//                                globals.accelerometerTrigger.paused = true
//                                globals.fadeOutSound.play()
//                            }
//                        }
//                        Component.onDestruction:{
//                            globals.fadeOutSound.stop();
//                        }
//                    }
//                }



                TextSwitch {
                    id:timerNotificationEnabledSwitch
                    //: TextSwitch: Display system notification while finalizing
                    text: qsTr( 'Notification')

                    checked: settings.timerNotificationTriggerEnabled
                    onClicked: {
                        settings.timerNotificationTriggerEnabled = checked
                    }
                    //: TextSwitch description: Display system notification while finalizing
                    description: qsTr('Display a Notification shortly before the timer runs out. Notifications activate the Screen and, with it, Accelerometer readings.')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }

                TextSwitch {
                    id:timerFadeVisualEffectEnabledSwitch
                    //: TextSwitch: flash main page a bit while finalizing
                    text: qsTr('Visual Indicator')

                    checked: settings.timerFadeVisualEffectEnabled
                    onClicked: {
                        settings.timerFadeVisualEffectEnabled = checked
                    }
                    //: TextSwitch description: flash main page a bit while finalizing
                    description: qsTr('Flashes the main screen before the timer is running out')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
            }


        }
    }
}
