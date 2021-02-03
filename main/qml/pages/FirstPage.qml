import QtQuick 2.6
import Sailfish.Silica 1.0

import "../lib/"


Page {
    id: page
    property bool isDarkScreen:  settings.viewDarkenMainSceen && (sleepTimer.running ) && !clickArea.pressed;
    onIsDarkScreenChanged: {
        if(isDarkScreen && Theme.colorScheme === Theme.DarkOnLight) {
            palette.colorScheme = Theme.LightOnDark
            palette.highlightColor = Theme.highlightFromColor(Theme.highlightColor, Theme.LightOnDark)
        } else {
            palette.colorScheme = Theme.colorScheme;
            palette.highlightColor = Theme.highlightColor;
        }
    }

    Rectangle {
        anchors.fill: parent
        opacity: page.isDarkScreen ? settings.viewDarkenMainScreenAmount*0.8 : 0

        color: Qt.rgba(0,0,0,1)

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
    }
    Rectangle {
        id: nearlyDoneIndicator
        anchors.fill: parent
        color:palette.highlightBackgroundColor
        opacity: 0
        visible: sleepTimer.nearlyDone && settings.timerFadeVisualEffectEnabled
        SequentialAnimation on opacity {

            PropertyAnimation {from:0; to: 0.8; duration: 1000 }
            PropertyAnimation {from:0.8; to: 0; duration: 1000 }
            running: (sleepTimer.nearlyDone) && settings.timerFadeVisualEffectEnabled && Qt.application.active
            loops: Animation.Infinite
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        opacity: page.isDarkScreen ? ((1-settings.viewDarkenMainScreenAmount))*0.75 + 0.25 : 1

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
        PullDownMenu {
            quickSelect: true
            onActiveChanged: {
                globals.accelerometerTrigger.paused = active
            }

            MenuItem {
                visible: !sleepTimer.running
                text: qsTr("Options")
                onClicked: pageStack.push(Qt.resolvedUrl("Options.qml"), {firstPage:page, globals: globals})
            }
            MenuItem {
                text: qsTr("Stop Timer")
                visible: sleepTimer.running
                onClicked: sleepTimer.stop()
            }
        }
        PushUpMenu {
            visible: sleepTimer.running
            quickSelect: true
            onActiveChanged: {
                globals.accelerometerTrigger.paused = active
            }

            MenuItem {
                text: qsTr("Stop Timer")
                onClicked: sleepTimer.stop()
            }
        }

        contentHeight: page.height
        PageHeader {
            id: pageHeader
            title: qsTr("slumber")
            anchors.right: settings.viewActiveOptionsButtonEnabled? optionsButton.left: parent.right

        }
//        Column {
//            anchors.top: pageHeader.bottom
//            width: parent.width
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "interval:" + SleepTimer.interval
//            }
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "remaining:" + SleepTimer.remainingTime
//            }
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "remaining s:" + SleepTimer.remainingSeconds
//            }
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "running:" + SleepTimer.running
//            }
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "finalizing:" + SleepTimer.finalizing
//            }
//            Label {
//                font.pixelSize: Theme.fontSizeTiny
//                text: "finalizeMilliseconds:" + SleepTimer.finalizeMilliseconds
//            }
//            Connections {
//                target: SleepTimer
//                onRemainingTimeChanged: {
//                    console.log("remaining time changed", SleepTimer.remainingTime, SleepTimer.remainingSeconds);

//                }
//                onIntervalChanged: {
//                    console.log("interval changed", SleepTimer.interval);
//                }
//                onFinalizingChanged: {
//                    console.log("finalizing changed", SleepTimer.finalizing);
//                }
//                onFinalizeMillisecondsChanged: {
//                    console.log("finalizeMilliseconds changed", SleepTimer.finalizeMilliseconds);
//                }
//                onIsActiveChanged: {
//                    console.log("active changed", SleepTimer.running);
//                }
//                onTimeout: {
//                    console.log("timeout");
//                }

//            }

//            Component.onCompleted: {
//                SleepTimer.interval = 10000;
//                SleepTimer.finalizeMilliseconds = 5000;
//                SleepTimer.start();

//            }

//        }

//        Image {
//            opacity: 0.3
//            source: "../assets/moon.png"
//            smooth: false
//            cache: false
//            y: 0-(implicitHeight/ 3)
//            x: 0-(implicitWidth / 9)
//        }
        BackgroundItem {
            id: clickArea
            anchors.fill: parent

            TimerProgressButton {
                width: Screen.width / 2
                running: sleepTimer.running
                anchors.centerIn: parent
                timeFormatShort: settings.viewTimeFormatShort
                timer: sleepTimer
                value: sleepTimer.milliSecondsLeft / (settings.timerSeconds*1000)
                fontSize: Screen.sizeCategory >= Screen.Large ? Theme.fontSizeHuge*1.2 : Theme.fontSizeMedium
                lineHeight: Screen.sizeCategory >= Screen.Large ? 0.8 : 1.0
            }

            onClicked: {
                sleepTimer.start()
            }
            onPressAndHold: {
                var minutes = (settings.timerSeconds / 60);
                var selectedHour, selectedMinute
                if(settings.timerSeconds === 30){
                    selectedHour = 0;
                    selectedMinute = 0.5
                } else {
                    selectedHour =  Math.floor(minutes /60);
                    selectedMinute = minutes - selectedHour * 60;
                }
                var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                hourMode:  DateTime.TwentyFourHours,
                                                hour: selectedHour,
                                                minute: selectedMinute
                                            })

                dialog.accepted.connect(function() {
                    if(!dialog.hour && !dialog.minute) {//don't set zero-length timer, but don't make a fuss about it
                        selectedHour = 0
                        selectedMinute = 0
                        settings.timerSeconds = 30
                        return;
                    }

                    selectedHour = dialog.hour
                    selectedMinute = dialog.minute
                    settings.timerSeconds = (selectedHour * 60 + selectedMinute)*60;

                })
            }
        }

        IconButton {
            id: optionsButton
            property bool active:  settings.viewActiveOptionsButtonEnabled
            visible: active
            icon.source: "image://theme/icon-m-developer-mode"

            anchors.verticalCenter: pageHeader.verticalCenter
            anchors.right: parent.right
            height: pageHeader.height

            onClicked: pageStack.push(Qt.resolvedUrl("Options.qml"), {firstPage: page})
            onPressAndHold: sleepTimer.triggered()
        }


        Item {
            width: parent.width
            height: text2.height

            anchors.horizontalCenter: parent.horizontalCenter

            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge

            Text
            {
                id:text1
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: palette.secondaryHighlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: (sleepTimer.running? qsTr("Tap to restart,"):qsTr("Tap to start,"))
            }
            Text
            {

                id:text2

                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: palette.secondaryHighlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: '\n' + (sleepTimer.running? qsTr("pull up or down to stop"):qsTr("pull down for options"))
            }
        }


    }
}


