import QtQuick 2.6
import Sailfish.Silica 1.0

import "../lib/"


Page {
    id: page
    property bool isDarkScreen:  settings.viewDarkenMainSceen && (SleepTimer.running ) && !clickArea.pressed;
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
        visible: SleepTimer.finalizing && settings.timerFadeVisualEffectEnabled
        SequentialAnimation on opacity {

            PropertyAnimation {from:0; to: 0.8; duration: 1000 }
            PropertyAnimation {from:0.8; to: 0; duration: 1000 }
            running: (SleepTimer.finalizing) && settings.timerFadeVisualEffectEnabled && Qt.application.active
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
                visible: !SleepTimer.running
                text: qsTr("Options")
                onClicked: pageStack.push(Qt.resolvedUrl("Options.qml"), {firstPage:page, globals: globals})
            }
            MenuItem {
                text: qsTr("Stop Timer")
                visible: SleepTimer.running
                onClicked: SleepTimer.stop()
            }
        }
        PushUpMenu {
            visible: SleepTimer.running
            quickSelect: true
            onActiveChanged: {
                globals.accelerometerTrigger.paused = active
            }

            MenuItem {
                text: qsTr("Stop Timer")
                onClicked: SleepTimer.stop()
            }
        }

        contentHeight: page.height
        PageHeader {
            id: pageHeader
            title: qsTr("slumber")
            anchors.right: settings.viewActiveOptionsButtonEnabled? optionsButton.left: parent.right

        }
        BackgroundItem {
            id: clickArea
            anchors.fill: parent

            TimerProgressIndicator {
                width: Screen.width / 2
                anchors.centerIn: parent
                fontSize: Screen.sizeCategory >= Screen.Large ? Theme.fontSizeHuge*1.2 : Theme.fontSizeMedium
                lineHeight: Screen.sizeCategory >= Screen.Large ? 0.8 : 1.0
            }


            onClicked: {
                SleepTimer.start()
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
            onPressAndHold: SleepTimer.triggered()
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
                text: (SleepTimer.running? qsTr("Tap to restart,"):qsTr("Tap to start,"))
            }
            Text
            {

                id:text2

                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: palette.secondaryHighlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: '\n' + (SleepTimer.running? qsTr("pull up or down to stop"):qsTr("pull down for options"))
            }
        }


    }
}


