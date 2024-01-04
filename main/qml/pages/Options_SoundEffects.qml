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

        VerticalScrollDecorator{

        }

        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge
            //: Page Header option page
            PageHeader { title: qsTr('Sound Effects') }

            SettingsGrid {
                topPadding: Theme.paddingLarge


                TextSwitch {
                    id:timerSoundEffectVolumeRelativeEnabledSwitch
                    //: TextSwitch: Sound effects volume is relative to active media volume
                    text: qsTr('Relative Volume')

                    checked: settings.timerSoundEffectVolumeRelativeEnabled
                    onClicked: {
                        settings.timerSoundEffectVolumeRelativeEnabled = checked
                    }
                    //: TextSwitch description: Play sound effect while finalizing
                    description: qsTr('Set sound effect volume relative to media volume')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }

                Slider {
                    id: userSlider

//                    enabled: timerFadeSoundEnabledSwitch.checked
                    opacity: enabled ? 1.0 : 0.5

//                    width: parent.width
    //                anchors.horizontalCenter: parent.horizontalCenter
                    value: settings.timerFadeSoundEffectVolume
                    //: Slider label: sound effect volume
                    label: qsTr('Sound Effect volume')
                    onValueChanged: {
                        settings.timerFadeSoundEffectVolume = value
                    }
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                    height: implicitHeight + (parent.columns > 1 ? Theme.paddingLarge : 0)
                }
            }
            SectionHeader {
                //: Section heading: finalize (configurable duration just before the timer runs out)
                text: qsTr('Finalize')
            }
            SettingsGrid {

                TextSwitch {
                    id:timerFadeSoundEnabledSwitch
                    //: TextSwitch: Play sound effect while finalizing
                    text: qsTr('Sound Effect')

                    checked: settings.timerFadeSoundEffectEnabled
                    onClicked: {
                        settings.timerFadeSoundEffectEnabled = checked
                    }
                    //: TextSwitch description: Play sound effect while finalizing
                    description: qsTr('To alert you that the timer is running out')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }


                ComboBox {
                    id:fadesoundeffect
                    enabled: timerFadeSoundEnabledSwitch.checked
                    width: parent.columnWidth
                    //: ComboBox: choose one of the following sounds
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
                            //: ComboBox entry: sound name
                            text: qsTr('cassette noise')
                            onClicked: fadesoundeffect.activate(0)
                        }

                        MenuItem {
                            //: ComboBox entry: sound name
                            text: qsTr('clock ticking')
                            onClicked: fadesoundeffect.activate(1)
                        }

                        MenuItem {
                            //: ComboBox entry: sound name
                            text: qsTr('sail a jolla')
                            onClicked: fadesoundeffect.activate(2)
                        }
                    }
                }

                Column {
                    width: parent.columnWidth
                    bottomPadding: Theme.paddingLarge
                    HighlightImageButton {
                        enabled: timerFadeSoundEnabledSwitch.checked
                        text: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ?
                                  //: Button Text: stop sound effect preview
                                  qsTr('stop playing'):
                                  //: Button Text: start sound effect preview
                                  qsTr('play current sound')

                        icon.source: globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing ? 'image://theme/icon-m-pause' : 'image://theme/icon-m-play'
                        width: parent.width

                        onClicked: {
                            if(globals.fadeOutSound.effect && globals.fadeOutSound.effect.playing){
                                globals.fadeOutSound.stop()
                            } else {
                                globals.accelerometerTrigger.paused = true
                                globals.fadeOutSound.play()
                            }
                        }
                        Component.onDestruction:{
                            globals.fadeOutSound.stop();
                        }
                    }
                }
            }

            SectionHeader {
                //: Section heading: reset (play sound on reset)
                text: qsTr('Reset')
            }
            SettingsGrid {
//                topPadding: Theme.paddingLarge

                TextSwitch {
                    id:timerSoundOnResetEnabledSwitch
                    //: TextSwitch: Play Sound on reset
                    text: qsTr( 'Play sound on reset')

                    checked: settings.timerSoundOnResetEnabled
                    onClicked: {
                        settings.timerSoundOnResetEnabled = checked
                    }
                    //: TextSwitch description: Reset timer with proximity sensor
                    description: qsTr('Plays a sound effect when the timer gets reset')
                    leftMargin: 0
                    rightMargin: 0
                    width: parent.columnWidth
                }
            }
        }
    }
}
