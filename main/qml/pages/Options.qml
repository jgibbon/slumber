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

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                //: Menu Entry to get to the about page
                text: qsTr('About')
                onClicked: pageStack.push(Qt.resolvedUrl('About.qml'))
            }
        }
        VerticalScrollDecorator{

        }

        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge
            //: Page Header option page
            PageHeader { title: qsTr('slumber Options') }

            ValueButton {
                property int selectedHour
                property int selectedMinute
                onSelectedHourChanged: {}

                function openTimeDialog() {
                    var dialog = pageStack.push('Sailfish.Silica.TimePickerDialog', {
                                                    hourMode:  DateTime.TwentyFourHours,
                                                    hour: selectedHour,
                                                    minute: selectedMinute
                                                })

                    dialog.accepted.connect(function() {
                        if(!dialog.hour && !dialog.minute) {//don't set zero-length timer, but don't make a fuss about it
                            timerZeroNotification.show(4000);

                            selectedHour = 0
                            selectedMinute = 0
                            settings.timerSeconds = 15

                            return;
                        }

                        selectedHour = dialog.hour
                        selectedMinute = dialog.minute
                        settings.timerSeconds = (selectedHour * 60 + selectedMinute)*60;

                    })
                }

                //: ValueButton label. Set the timeout duration here.
                label: qsTr('Sleep after')
                value: (settings.timerSeconds === 15)?'15s':selectedHour+ ':'+ ('0'+selectedMinute).slice(-2)
                onClicked: openTimeDialog()
                Component.onCompleted: {
                    if(settings.timerSeconds === 15){
                        selectedHour = 0;
                        selectedMinute = 0.25
                        return;
                    }
                    var minutes = (settings.timerSeconds / 60);
                    selectedHour =  Math.floor(minutes /60);
                    selectedMinute = minutes - selectedHour * 60;
                }
            }
            InlineNotification {
                id: timerZeroNotification
                //: Short error message when a 0:00 duration has been set
                text: qsTr('Please set duration longer than 0:00')
            }


            TextSwitch {
                id:timerDisableScreensaverEnabledSwitch
                //: TextSwitch label: keep display on whlie timer is running
                text: qsTr('Keep display on')

                checked: settings.timerInhibitScreensaverEnabled
                onClicked: {
                    settings.timerInhibitScreensaverEnabled = checked
                }
                //: TextSwitch description: keep display on whlie timer is running
                description: qsTr('Keeps your display lit while the timer is running.')
            }


            SettingsGrid {
                topPadding: Theme.paddingLarge
                SettingsSectionButton {
                    //: Button Text: go to timer control options (start, stop or restart the timer automatically)
                    buttonText: qsTr('Timer Control')
                    icon.source: 'image://theme/icon-m-play'
                    //: Button Description: go to timer control options (start, stop or restart the timer automatically)
                    text: qsTr('Start, stop or reset the timer automatically, for example when media playback is detected.')
                    clickTarget: Qt.resolvedUrl('Options_TimerControl.qml')
                }
                SettingsSectionButton {
                    //: Button Text: go to timer actions options (things that happen when the timer runs out)
                    buttonText: qsTr('Actions')
                    icon.source: 'image://theme/icon-m-moon'
                    //: Button Description: go to timer actions options (things that happen when the timer runs out)
                    text: qsTr('Timer actions like "Pause Media" get executed when the timer runs out.')
                    clickTarget: Qt.resolvedUrl('Options_TimerEnd.qml')
                }
                SettingsSectionButton {
                    //: Button Text: go to timer finalize options (configurable duration just before the timer runs out)
                    buttonText: qsTr('Finalize')
                    icon.source: 'image://theme/icon-m-timer'
                    //: Button Description: go to timer finalize options (configurable duration just before the timer runs out)
                    text: qsTr('You can enable some special functions for the last seconds before the timer runs out, for example fading out media volume or displaying notifications.')
                    clickTarget: Qt.resolvedUrl('Options_Finalize.qml')
                }
                SettingsSectionButton {
                    //: Button Text: go to appearance options (UI settings)
                    buttonText: qsTr('Appearance')
                    icon.source: 'image://theme/icon-m-ambience'
                    //: Button Description: go to appearance options (UI settings)
                    text: qsTr('Change this application\'s look and feel.')
                    clickTarget: Qt.resolvedUrl('Options_Appearance.qml')
                }
                SettingsSectionButton {
                    //: Button Text: go to sound effect options
                    buttonText: qsTr('Sound Effects')
                    icon.source: 'image://theme/icon-m-alarm'
                    //: Button Description: go to sound effect options
                    text: qsTr('Settings for sound effects you can enable as non-visual feedback in various situations, for example while finalizing.')
                    clickTarget: Qt.resolvedUrl('Options_SoundEffects.qml')
                }
            }
        }
    }
}
