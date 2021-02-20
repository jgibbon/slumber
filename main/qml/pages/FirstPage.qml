import QtQuick 2.6
import Sailfish.Silica 1.0
import de.gibbon.slumber 1.0
import '../lib/'


Page {
    id: page
    property bool isDarkScreen:  settings.viewDarkenMainSceen && (SleepTimer.running ) && !clickArea.pressed;

    palette {
        colorScheme: isDarkScreen ? Theme.LightOnDark : Theme.colorScheme
        highlightColor:  isDarkScreen ? Theme.highlightFromColor(Theme.highlightColor, Theme.LightOnDark) : Theme.highlightFromColor(Theme.highlightColor, Theme.colorScheme)
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
            running: SleepTimer.finalizing && settings.timerFadeVisualEffectEnabled && Qt.application.state === Qt.ApplicationActive
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
                //: Menu Entry to get to the options page
                text: qsTr('Options')
                onClicked: pageStack.push(Qt.resolvedUrl('Options.qml'))
            }
            MenuItem {
                //: Menu Entry to stop an active timer
                text: qsTr('Stop Timer')
                visible: SleepTimer.running
                onClicked: SleepTimer.stop()
            }
        }
        PushUpMenu {
            visible: SleepTimer.running || pushUpStillVisibleTimer.running
            quickSelect: true
            onActiveChanged: {
                globals.accelerometerTrigger.paused = active
            }

            MenuItem {
                enabled: SleepTimer.running
                //: Menu Entry to stop an active timer
                text: qsTr('Stop Timer')
                onClicked: {
                    pushUpStillVisibleTimer.start();
                    SleepTimer.stop()
                }
            }
        }
        Timer {
            id: pushUpStillVisibleTimer
            interval: 300
        }

        contentHeight: page.height
        PageHeader {
            id: pageHeader
            //: Page Header text on main page
            title: qsTr('slumber')
            anchors.right: settings.viewActiveOptionsButtonEnabled ? optionsButton.left : parent.right
            rightMargin: settings.viewActiveOptionsButtonEnabled ? 0 : Theme.horizontalPageMargin
        }
        BackgroundItem {
            id: clickArea
            anchors.fill: parent

            TimerProgressIndicator {
                id: indicator
                width: Screen.width
                opacity: 0
                anchors.centerIn: parent
                fontSize: Screen.sizeCategory >= Screen.Large ? Theme.fontSizeHuge : Theme.fontSizeMedium
                secondaryFontSize: Screen.sizeCategory >= Screen.Large ? Theme.fontSizeSmall : Theme.fontSizeTiny
                animationDuration: Qt.application.state === Qt.ApplicationActive ? 200 : 0
                ParallelAnimation {
                    running: true
                    NumberAnimation { target: indicator; property: 'width'; to: Screen.width / 2; duration: 600 }
                    NumberAnimation { target: indicator; property: 'opacity'; easing.type: Easing.InCubic; to: 1.0; duration: 600; }
                }
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
                var dialog = pageStack.push('Sailfish.Silica.TimePickerDialog', {
                                                hourMode: DateTime.TwentyFourHours,
                                                hour: selectedHour,
                                                minute: selectedMinute
                                            })

                dialog.accepted.connect(function() {
                    if(!dialog.hour && !dialog.minute) {//don't set zero-length timer, but don't make a fuss about it
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
        }


        IconButton {
            id: optionsButton
            property bool active: settings.viewActiveOptionsButtonEnabled
            visible: active
            icon.source: 'image://theme/icon-m-developer-mode'
            anchors {
                verticalCenter: pageHeader.verticalCenter
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            height: pageHeader.height
            onClicked: pageStack.push(Qt.resolvedUrl('Options.qml'))
            onPressAndHold: SleepTimer.triggered()
        }

        Text {
            font.pixelSize: Theme.fontSizeSmall
            anchors {
                bottom: parent.bottom
                bottomMargin: Theme.paddingLarge
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            color: palette.secondaryHighlightColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            //: Short description of gestures on main page (timer running)
            text: SleepTimer.running? qsTr('Tap to restart,\npull up or down to stop')
                    //: Short description of gestures on main page (timer NOT running)
                                    :qsTr('Tap to start,\npull down for options')
        }
    }
}


