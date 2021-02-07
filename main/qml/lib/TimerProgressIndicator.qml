import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id:sleepTimerWidget
    property real value: SleepTimer.remainingSeconds / settings.timerSeconds //0.0
    property bool running: SleepTimer.running//true
    property bool timeFormatShort: settings.viewTimeFormatShort//false //one line
    property color textcolor: palette.highlightColor
    property color secondarytextcolor: palette.secondaryHighlightColor
    height: width
    property real busysize: width * 0.8
    property real busyborder: width * 0.02
    property int fontSize: Theme.fontSizeMedium
    property real lineHeight: 1.0
    readonly property real progressborder: ((width - busysize) / 2) + busyborder*0.5
    property bool viewActiveIndicatorEnabled: settings.viewActiveIndicatorEnabled
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        color: Qt.rgba(0,0,0,0)
        border {
            color: Theme.rgba(palette.highlightBackgroundColor, 0.2)
            width: progressborder
        }
        radius: width/2
        anchors.fill: parent
    }
    Item {
        id: circlesContainer
        anchors.fill: parent
        opacity: sleepTimerWidget.running ? 1.0 : 0.0
        visible: opacity > 0
        Behavior on opacity { FadeAnimation { id: fadeAnimation }}

        Item {
            id: progressCircleContainer
            anchors.fill: parent
            rotation:  (sleepTimerWidget.value * 180) -180
            Behavior on rotation { NumberAnimation { duration: 200 }}

            ProgressCircle {
                id: progressCircle
                anchors.fill: parent
                value: 1 - sleepTimerWidget.value
                borderWidth: progressborder
                progressColor: palette.highlightColor

                Behavior on value { NumberAnimation { duration: 200 }}
                backgroundColor: 'transparent'
                inAlternateCycle: true
                onValueChanged: {
                    inAlternateCycle = true
                    _previousValue = value //TODO check if still needed
                }
            }

        }
        Loader {
            active: sleepTimerWidget.viewActiveIndicatorEnabled
            asynchronous: true

            anchors.centerIn: parent
            height: busysize
            width: busysize

            sourceComponent: Component {
                Item {
                    id: busyindicatorrect
                    property int duration: 20000
                    SequentialAnimation on rotation {
                        PropertyAnimation {from:0; to: 360; duration: busyindicatorrect.duration }
                        running: (sleepTimerWidget.running) && Qt.application.active
                        loops: Animation.Infinite
                    }
                    ProgressCircle {
                        id: busyindicator
                        anchors.fill: parent
                        value: 0.25
                        borderWidth: busyborder
                        progressColor: palette.highlightColor
                        backgroundColor: 'transparent'
                        inAlternateCycle: true
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
            text: (seconds < 61 ? ("0"+seconds).slice(-2)+"s"
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
            TimerText {
                visible: parent.seconds >= 3600
                value: parseInt(longTextColumn.formattedEntries[0])
                description: qsTr("Hrs", "short: [x] Hour(s)", value);
                color: textcolor
                font.pixelSize: sleepTimerWidget.fontSize
                lineHeight: parent.lineHeight
            }
            TimerText {
                visible: parent.seconds >= 60
                value: parseInt(longTextColumn.formattedEntries[1])
                description: qsTr("Min", "short: [x] Minute(s)", value);
                color: textcolor
                font.pixelSize: sleepTimerWidget.fontSize
                lineHeight: parent.lineHeight
            }
            TimerText {
                value: parseInt(longTextColumn.formattedEntries[2])
                description: qsTr("Sec", "short: [x] Seconds(s)", value);
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


