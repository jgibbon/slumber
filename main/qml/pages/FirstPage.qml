import QtQuick 2.0
import Sailfish.Silica 1.0

import "../lib/"


Page {
    id: page
    property bool isDarkScreen:  options.viewDarkenMainSceen && (sleepTimer.running ) && !clickArea.pressed;
    BackgroundItem {
        anchors.fill: parent
        opacity: page.isDarkScreen ? options.viewDarkenMainScreenAmount*0.8 : 0

        _backgroundColor:'black'

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }
    }
    Rectangle {
        id: nearlyDoneIndicator
        anchors.fill: parent
        color:Theme.highlightBackgroundColor
        opacity: 0
        visible: sleepTimer.nearlyDone && options.timerFadeVisualEffectEnabled
        SequentialAnimation on opacity {

            PropertyAnimation {from:0; to: 0.8; duration: 1000 }
            PropertyAnimation {from:0.8; to: 0; duration: 1000 }
            running: (sleepTimer.nearlyDone) && options.timerFadeVisualEffectEnabled && Qt.application.active
            loops: Animation.Infinite
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        opacity: page.isDarkScreen ? ((1-options.viewDarkenMainScreenAmount))*0.75 + 0.25 : 1

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
                onClicked: pageStack.push(Qt.resolvedUrl("Options.qml"), {options:options, firstPage:page, globals: globals})
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
            anchors.right: options.viewActiveOptionsButtonEnabled? optionsButton.left: parent.right

        }

        Image {
            opacity: 0.3
            source: "../assets/moon.png"
            smooth: false
            y: 0-(implicitHeight/ 3)
            x: 0-(implicitWidth / 9)
        }
        BackgroundItem {
            id: clickArea
            anchors.fill: parent

            TimerProgressButton {
                width: parent.width < parent.height? (parent.width / 2) : (parent.height / 2)
                running: sleepTimer.running
                anchors.centerIn: parent
                timeFormatShort: options.viewTimeFormatShort
                timer: sleepTimer
                value: sleepTimer.milliSecondsLeft / (options.timerSeconds*1000)
                fontSize: Screen.sizeCategory >= Screen.Large ? Theme.fontSizeHuge*1.2 : Theme.fontSizeMedium
                lineHeight: Screen.sizeCategory >= Screen.Large ? 0.8 : 1.0

            }

            onClicked: {
                sleepTimer.start()
            }
            onPressAndHold: {
                var minutes = (options.timerSeconds / 60);
                var selectedHour, selectedMinute
                if(options.timerSeconds === 30){
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
                        options.timerSeconds = 30
                        return;
                    }

                    selectedHour = dialog.hour
                    selectedMinute = dialog.minute
                    options.timerSeconds = (selectedHour * 60 + selectedMinute)*60;

                })
            }
        }

        IconButton {
            id: optionsButton
            property bool active:  options.viewActiveOptionsButtonEnabled
            visible: active
            icon.source: "image://theme/icon-m-developer-mode"

            anchors.verticalCenter: pageHeader.verticalCenter
            anchors.right: parent.right
            height: pageHeader.height

            onClicked: pageStack.push(Qt.resolvedUrl("Options.qml"), {options:options, firstPage: page})
            onPressAndHold: sleepTimer.triggered()
        }


        Item{
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
                color: Theme.secondaryHighlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: (sleepTimer.running? qsTr("Tap to restart,"):qsTr("Tap to start,"))
            }
            Text
            {

                id:text2

                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: '\n' + (sleepTimer.running? qsTr("pull up or down to stop"):qsTr("pull down for options"))
            }
        }


    }
}


