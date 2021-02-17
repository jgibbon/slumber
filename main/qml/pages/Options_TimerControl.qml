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
            //: PageHeader: Timer control settings (automatic start/stop/restart)
            PageHeader { title: qsTr('Control Timer') }
            SettingsGrid {
                width: parent.width
                TextSwitch {
                    id:timerAutostartOnPlaybackDetectionEnabledSwitch
                    //: TextSwitch: autostart on media playback
                    text: qsTr('Start timer if playback is detected')

                    checked: settings.timerAutostartOnPlaybackDetection
                    onClicked: {
                        settings.timerAutostartOnPlaybackDetection = checked
                    }
                    //: TextSwitch description: autostart on media playback
                    description: qsTr('Automatically start timer when playback is detected.')
                    width: parent.columnWidth
                }
                TextSwitch {
                    id:timerAutostopOnPlaybackStopEnabledSwitch
                    //: TextSwitch: stop automatically with media playback
                    text: qsTr('Stop timer if playback is stopped')
                    enabled: timerAutostartOnPlaybackDetectionEnabledSwitch.checked

                    checked: settings.timerAutostopOnPlaybackStop
                    onClicked: {
                        settings.timerAutostopOnPlaybackStop = checked
                    }
                    //: TextSwitch description: stop automatically with media playback
                    description: qsTr('Automatically stop timer when playback stop or pause is detected.')
                    width: parent.columnWidth
                }
            }



            SectionHeader {
                //: section header: entries for automatically resetting the timer to start duration
                text: qsTr('Reset Timer')
            }
            SettingsGrid {
                Column {
                    width: parent.columnWidth

                    ComboBox {
                        id:timerreset
        //                visible: timerEnabledSwitch.checked
                        width: parent.width
                        //: ComboBox: accelerometer – reset after [slight bump, etc]
                        label: (currentIndex ? qsTr('Reset after', 'combo box: reset after [slight bump, etc]'):
                                               //: ComboBox: accelerometer – reset by moving [off]
                                               qsTr('Reset timer by moving the device', 'combo box: reset by moving [off]'))
                        leftMargin: 0
                        rightMargin: 0
                        currentIndex: -1
                        property int readIndex: 0+currentIndex

                        menu: ContextMenu {
                            Component.onCompleted: {
                            }

                            id: timeropts
                            Repeater {
                                model: ListModel {
//                                    dynamicRoles: true
                                }
                                Component.onCompleted: {

                                    //v0.1 - 0.3 transition, there were other values
                                    var oldVals = [8],
                                        newVals = [20],
                                        oldIndex = oldVals.indexOf(settings.timerMotionThreshold);
                                    if(oldIndex > -1){
                                        console.log('Replacing deprecated accelerometer setting ', oldVals[oldIndex], 'with', newVals[oldIndex]);
                                        settings.timerMotionThreshold = newVals[oldIndex];
                                    }
                                    //end value transition

                                    model.append({'value': 0,
                                                     //: Menu Entry: accelerometer – [reset by moving] off
                                                            'text':qsTr('off')});
                                    model.append({'value': 0.1,
                                                     //: Menu Entry: accelerometer – [reset after] tiniest movement
                                                            'text':qsTr('tiniest sign of life')});
                                    model.append({'value': 0.3,
                                                     //: Menu Entry: accelerometer – [reset after] small movement
                                                            'text':qsTr('slight bump')});
                                    model.append({'value': 0.9,
                                                     //: Menu Entry: accelerometer – [reset after] a bit of movement
                                                            'text':qsTr('a bit of movement')});
                                    model.append({'value': 1.4,
                                                     //: Menu Entry: accelerometer – [reset after] a bit more movement
                                                            'text':qsTr('some acceleration')});
                                    model.append({'value': 20,
                                                     //: Menu Entry: accelerometer – [reset after] considerable movement
                                                            'text':qsTr('shaking')});
                                    model.append({'value': 40,
                                                     //: Menu Entry: accelerometer – [reset after] a lot of movement (maximum)
                                                            'text':qsTr('earthquake')});
                                }

                                MenuItem {
                                    text: model.text ? model.text + '' : '-'

                                    onClicked: {

                                        if(index === 0) {
                                            settings.timerMotionThreshold = 0;
                                            settings.timerMotionEnabled = false;
                                        } else {
                                            settings.timerMotionThreshold = model.value;
                                            settings.timerMotionEnabled = true;
                                        }
                                    }

                                    Component.onCompleted: {
                                        if(Math.round(model.value * 10) === Math.round(settings.timerMotionThreshold * 10) || model.value === 0 && !settings.timerMotionEnabled) {
                                            timerreset.currentIndex = index
                                        }

                                    }
                                }

                            }

                        }
                    }


                    Label {
                        width: parent.width
                        visible: settings.timerMotionEnabled
                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom
                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        //: Label text: notice about using the accelerometer
                        text:qsTr('Using the Accelerometer may have an impact on power consumption while playing and only works when the display is lit. If your device supports double tap to wake, you can tap thrice to wake up your device and trigger the Accelerometer. Otherwise you can show a notification in the finalizing phase to turn on the display.')
                        color: Theme.highlightColor
                    }
                }


                TextSwitch {
                    id:timerWaveMotionEnabledSwitch
                    //: TextSwitch: Reset timer with proximity sensor
                    text: qsTr( 'Wave in front of screen')

                    checked: settings.timerWaveMotionEnabled
                    onClicked: {
                        settings.timerWaveMotionEnabled = checked
                    }
                    //: TextSwitch description: Reset timer with proximity sensor
                    description: qsTr('Reset the timer by holding your hand in front of the screen.')
                    leftMargin: 0
                    rightMargin: 0
                    width: parent.columnWidth
                }

            }

            Column {

                width: parent.width - x*2 //.columnWidth
                x: Theme.horizontalPageMargin
                Item {
                    width: parent.width
                    height: Theme.paddingLarge
                }

                HighlightImageButton {
                    //: Button text: go to settings page to reset timer with smartwatch events from the amazfish application
                    text: qsTr('Amazfish integration');
                    width: parent.width
                    onClicked: pageStack.push(Qt.resolvedUrl('Options_TimerControl_Amazfish.qml'))
                    icon.source: 'image://theme/icon-m-watch'
                }
            }

        }
    }
}
