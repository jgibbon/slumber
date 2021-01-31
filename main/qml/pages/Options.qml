import QtQuick 2.6
import Sailfish.Silica 1.0



import "../lib/"


Page {
    id: page

    property Options options
    property FirstPage firstPage




    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"), {options:options, firstPage:firstPage})
            }
        }
        VerticalScrollDecorator{

        }

        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: qsTr("slumber Options") }

//            SectionHeader {
//                text: qsTr( "Timer Duration")
//            }

            ValueButton {
                property int selectedHour
                property int selectedMinute
                onSelectedHourChanged: {}

                function openTimeDialog() {
                    var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                    hourMode:  DateTime.TwentyFourHours,
                                                    hour: selectedHour,
                                                    minute: selectedMinute
                                                })

                    dialog.accepted.connect(function() {
                        if(!dialog.hour && !dialog.minute) {//don't set zero-length timer, but don't make a fuss about it
                            timerZeroNotification.show(4000);

                            selectedHour = 0
                            selectedMinute = 0
                            options.timerSeconds = 15

                            return;
                        }

                        selectedHour = dialog.hour
                        selectedMinute = dialog.minute
                        options.timerSeconds = (selectedHour * 60 + selectedMinute)*60;

                    })
                }

                label: qsTr("Sleep after")
                value: (options.timerSeconds === 30)?'30s':selectedHour+ ':'+ ("0"+selectedMinute).slice(-2)
                onClicked: openTimeDialog()
                Component.onCompleted: {
                    if(options.timerSeconds === 30){
                        selectedHour = 0;
                        selectedMinute = 0.5
                        return;
                    }
                    var minutes = (options.timerSeconds / 60);
                    selectedHour =  Math.floor(minutes /60);
                    selectedMinute = minutes - selectedHour * 60;
                }
            }
            InlineNotification {
                id: timerZeroNotification
                text: qsTr('Please set Timer longer than 0:00')
            }

//            SectionHeader {
//                text: qsTr( "System")
//            }

            TextSwitch {
                id:timerDisableScreensaverEnabledSwitch
                text: qsTr('Keep Display on')

                checked: options.timerInhibitScreensaverEnabled
                onClicked: {
                    options.timerInhibitScreensaverEnabled = checked
                }
                description: qsTr('Keeps your Display lit while the timer is running.')
            }

            TextSwitch {
                id:timerAutostartOnPlaybackDetectionEnabledSwitch
                text: qsTr('Start Timer if Playback is detected')

                checked: options.timerAutostartOnPlaybackDetection
                onClicked: {
                    options.timerAutostartOnPlaybackDetection = checked
                }
                description: qsTr('Automatically start timer when playback is detected. Slumber has to be open for this to work.')
            }
            TextSwitch {
                id:timerAutostopOnPlaybackStopEnabledSwitch
                text: qsTr('Stop Timer if Playback is stopped')
                enabled: timerAutostartOnPlaybackDetectionEnabledSwitch.checked

                checked: options.timerAutostopOnPlaybackStop
                onClicked: {
                    options.timerAutostopOnPlaybackStop = checked
                }
                description: qsTr('Automatically stop timer when playback stop or pause is detected.')
            }

                Column {
                    width: parent.width
                    spacing: Theme.paddingMedium

                    SectionHeader {
                        text: qsTr("Actions")
                    }
                    HighlightImageButton {
                        text: qsTr("Configure Actions");
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerEnd.qml"), {options:options, firstPage:firstPage})
                        icon.source: "image://theme/icon-m-moon"
                    }
                    Label {
                        text: qsTr("Timer actions like \"Pause Media\" get executed when the Timer runs out.")
                        color: Theme.highlightColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                    }



                    SectionHeader {
                        text: qsTr("Timer Reset")
                    }
                    HighlightImageButton {
                        text: qsTr("Configure Reset");
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerReset.qml"), {options:options, firstPage:firstPage})
                        icon.source: "image://theme/icon-m-refresh"
                    }
                    Label {
                        text: qsTr("Reset the timer while you are awake.")
                        color: Theme.highlightColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom

                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                    }


                }




                Column {
                    width: parent.width
                    spacing: Theme.paddingMedium


                    SectionHeader {
                        text: qsTr("Appearance")
                        //                color: Theme.secondaryColor
                    }

                    HighlightImageButton {
                        text: qsTr("Configure Appearance");
                        icon.source: "image://theme/icon-m-ambience"
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_Appearance.qml"), {options:options, firstPage:firstPage})

                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin

                    }
                    Label {
                        text: qsTr("Change this application's look and feel.")
                        color: Theme.highlightColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom

                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.horizontalPageMargin * 2)
                        x: Theme.horizontalPageMargin
                }
            }


            Item {
                width:parent.width
                height: Theme.paddingLarge
            }
        }
    }
}
