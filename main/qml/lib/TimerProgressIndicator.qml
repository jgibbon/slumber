import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id:sleepTimerWidget
    property real value: SleepTimer.remaining
    property bool running: SleepTimer.running//true
    property bool timeFormatShort: settings.viewTimeFormatShort//false //one line
    property color textcolor: palette.highlightColor
    property color secondarytextcolor: palette.secondaryHighlightColor
    height: width
    property real busysize: width * 0.8
    property real busyborder: width * 0.02
    property int fontSize: Theme.fontSizeMedium
    property real lineHeight: 1.0
    property real progressborderDifference: (running?0:busyborder)
    Behavior on progressborderDifference { NumberAnimation { easing.type: Easing.InOutQuad;duration: 300;} }
    property real progressborder: ((width - busysize) / 2) + progressborderDifference// + busyborder*progressborderFactor
    property bool viewActiveIndicatorEnabled: settings.viewActiveIndicatorEnabled
    property int animationDuration: 200

    Item {
        id: circlesContainer
        anchors.fill: parent
        Item {
            id: progressCircleContainer
            anchors.fill: parent
            SlumberCircle {
                anchors.fill: parent
                value: sleepTimerWidget.value
                borderWidth: progressborder
                backgroundColor:  Theme.rgba(palette.highlightBackgroundColor, Theme.opacityFaint)
                valueColor: SleepTimer.running ? palette.highlightColor : Theme.rgba(palette.highlightColor, 0.0)
                Behavior on value { NumberAnimation { duration: sleepTimerWidget.animationDuration }}
                Behavior on valueColor { ColorAnimation { duration: sleepTimerWidget.animationDuration }}
            }


        }
        Loader {
            active: sleepTimerWidget.viewActiveIndicatorEnabled && sleepTimerWidget.running
            asynchronous: true

            anchors.centerIn: parent
            height: busysize
            width: busysize

            sourceComponent: Component {
                Item {
                    id: busyindicatorrect
                    property int duration: 20000
                    SequentialAnimation on rotation {
                        PropertyAnimation {from:45; to: 405; duration: busyindicatorrect.duration }
                        running: (sleepTimerWidget.running) && Qt.application.state === Qt.ApplicationActive
                        loops: Animation.Infinite
                    }

                    SlumberCircle {
                        id: busyindicator
                        anchors.fill: parent
                        value: 0.75
                        borderWidth: busyborder
                        valueColor: palette.highlightColor
                        backgroundColor: 'transparent'
                    }
                }
            }
        }
    }

    Component {
        id: shortTextComponent
        Text {
            width: sleepTimerWidget.width
            height: width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            readonly property int seconds: SleepTimer.remainingSeconds
            color: textcolor
            text: (seconds < 61 ? ('0'+seconds).slice(-2)+'s'
                                                   : Format.formatDuration(seconds, seconds > 3599 ? Formatter.Duration : Formatter.DurationShort)).replace(/:/g, '<font color="'+secondarytextcolor+'">:</font>');
            font.pixelSize: sleepTimerWidget.fontSize
        }
    }
    Component {
        id: longTextComponent
        Column {
            id: longTextColumn
            readonly property int seconds: SleepTimer.remainingSeconds
            readonly property string formattedDuration: Format.formatDuration(seconds, Formatter.Duration)
            readonly property var formattedEntries: formattedDuration.split(':');
            readonly property int lineHeight: seconds < 3600 ? sleepTimerWidget.lineHeight: 1.0
            height: childrenRect.height
            width: sleepTimerWidget.width
            move: Transition {
                NumberAnimation { easing.type: Easing.InOutQuad; properties: 'y'; duration: 500; }
            }
            TimerText {
                visible: opacity > 0
                opacity: parent.seconds >= 3600 ? 1.0 : 0.0
                text: parseInt(longTextColumn.formattedEntries[0])
                //: "Long" duration option, the shortest variant of [x] Hour(s) you can find
                description: qsTr('Hrs', 'short: [x] Hour(s)', value);
                color: textcolor
                font.pixelSize: sleepTimerWidget.fontSize
                lineHeight: parent.lineHeight
            }
            TimerText {
                visible: opacity > 0
                opacity: parent.seconds >= 60 ? 1.0 : 0.0
                text: parseInt(longTextColumn.formattedEntries[1])
                //: "Long" duration option, the shortest variant of [x] Minute(s) you can find
                description: qsTr('Min', 'short: [x] Minute(s)', value);
                color: textcolor
                font.pixelSize: sleepTimerWidget.fontSize
                lineHeight: parent.lineHeight
            }
            TimerText {
               text: parseInt(longTextColumn.formattedEntries[2])
                //: "Long" duration option, the shortest variant of [x] Seconds(s) you can find
                description: qsTr('Sec', 'short: [x] Seconds(s)', value);
                color: textcolor
                font.pixelSize: sleepTimerWidget.fontSize
                lineHeight: parent.lineHeight
            }
        }
    }
    Loader {
        id: textLoader
        anchors.centerIn: sleepTimerWidget
        sourceComponent: sleepTimerWidget.timeFormatShort ? shortTextComponent : longTextComponent
    }
}


