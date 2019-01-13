import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0


import "../lib/"


Page {
    id: page
    property var options
    property var appstate
    property var firstPage




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
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"), {options:options, firstPage:page})
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
                            options.timerSeconds = 30

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

            Column {
                width: parent.width
                spacing: Theme.paddingMedium

                Column {
                    width: parent.width
                    spacing: Theme.paddingMedium

                    SectionHeader {
                        text: qsTr("Actions")
                    }
                    Button {
                        text: qsTr("Configure Actions");
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerEnd.qml"), {options:options, firstPage:page})
                        //                    anchors.horizontalCenter: parent.horizontalCenter
                        x:Theme.paddingLarge
                        anchors.leftMargin: Theme.paddingLarge
                        anchors.rightMargin: Theme.paddingLarge
                    }
                    Label {
                        text: qsTr("Timer actions like \"Pause Media\" get executed when the Timer runs out.")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom


                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge
                    }



                    SectionHeader {
                        text: qsTr("Timer Reset")
                        //                color: Theme.secondaryColor
                    }
                    Button {
                        text: qsTr("Configure Reset");
                        x:Theme.paddingLarge
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_TimerReset.qml"), {options:options, firstPage:page})
                        //                    anchors.horizontalCenter: parent.horizontalCenter

                    }
                    Label {
                        text: qsTr("Reset the timer while you are awake.")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom

                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge
                    }


                }




                Column {
                    width: parent.width
                    spacing: Theme.paddingMedium


                    SectionHeader {
                        text: qsTr("Appearance")
                        //                color: Theme.secondaryColor
                    }

                    Button {
                        text: qsTr("Configure Appearance");
                        x:Theme.paddingLarge
                        onClicked: pageStack.push(Qt.resolvedUrl("Options_Appearance.qml"), {options:options, firstPage:page})
                        //                    anchors.horizontalCenter: parent.horizontalCenter

                    }
                    Label {
                        text: qsTr("Change this application's look and feel.")
                        color: Theme.secondaryColor

                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom

                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        width: parent.width - (Theme.paddingLarge * 2)
                        x: Theme.paddingLarge
                    }
                    //                Button {
                    //                    text: qsTr("Configure Appearance");
                    //                    onClicked: pageStack.push(Qt.resolvedUrl("Options_Appearance.qml"), {options:options, firstPage:page})
                    //                    anchors.horizontalCenter: parent.horizontalCenter
                    //                }
                    //                Label {
                    //                    text: qsTr("Reset the timer while you are awake.")
                    //                    color: Theme.secondaryColor

                    //                    font.pixelSize: Theme.fontSizeExtraSmall
                    //                    verticalAlignment: Text.AlignBottom

                    //                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    //                    width: parent.width - (Theme.paddingLarge * 2)
                    //                    x: Theme.paddingLarge
                    //                }




                }
            }


            Item {
                width:parent.width
                height: Theme.paddingLarge
            }
        }
    }
}
