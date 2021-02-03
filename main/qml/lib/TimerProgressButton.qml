import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id:sleepTimerWidget

    property CountDownTimer timer
    property real value: 0.0
    property bool running: true
    property bool timeFormatShort: false //one line
    property bool timeFomatAbbreviateIfLong: true //
    property color textcolor: palette.highlightColor
    property color secondarytextcolor: palette.secondaryHighlightColor

    property int milliSecondsLeft: 0

    height: width

    property int minutesLeft: (timer.milliSecondsLeft / 60000)
    property int selectedHour: Math.floor(minutesLeft /60);
    property int selectedMinute: minutesLeft - selectedHour * 60
    property int selectedSecond: (timer.milliSecondsLeft / 1000) - (selectedMinute) * 60  - (selectedHour) * 3600
    property real busysize: width * 0.8
    property real busyborder: width * 0.02
    property real progresssize: width
    property int fontSize: Theme.fontSizeMedium
    property real lineHeight: 1.0
    property real progressborder: ((progresssize - busysize) / 2) + busyborder*0.5

    property alias busyindicator: busyindicatorrect
    anchors.horizontalCenter: parent.horizontalCenter
    Rectangle {
        color: Qt.rgba(0,0,0,0)
        border {
            color: Theme.rgba(palette.highlightBackgroundColor, 0.2)
            width: progressborder
        }
        radius: width/2
        height: progresssize
        width: progresssize
    }
    Item {
        id: progressCircleContainer
        width: sleepTimerWidget.width
        height: sleepTimerWidget.height
        rotation:  (sleepTimerWidget.value * 180) -180
        Behavior on rotation { NumberAnimation { duration: 200 }}

        ProgressCircle {
            id: progressCircle
            visible: sleepTimerWidget.running
            height: progresssize
            width: progresssize
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

    Item {
        id: busyindicatorrect
        visible: options.viewActiveIndicatorEnabled
        anchors.centerIn: parent
        height: busysize
        opacity: sleepTimerWidget.running ? 1.0 : 0.0
        width: busysize
        property int duration: 20000
        Behavior on opacity { FadeAnimation { id: fadeAnimation }}
        SequentialAnimation on rotation {

            PropertyAnimation {from:0; to: 360; duration: busyindicatorrect.duration }
            //            from: 0; to: 360
            //            duration: 20000
            running: (sleepTimerWidget.running) && busyindicator.visible && Qt.application.active
            loops: Animation.Infinite
        }
        ProgressCircle {
            id: busyindicator
            anchors.centerIn: parent
            height: busysize
            width: busysize
            value: 0.25
            borderWidth: busyborder
            progressColor: palette.highlightColor

            backgroundColor: 'transparent'
            inAlternateCycle: true
        }
    }




    Item{
        id: textItem

        width: progressCircleContainer.width
        height: sleepTimerWidget.timeFormatShort ? displayText.height : longDisplayText.height

        property string hoursStr: selectedHour
        property string minutesStr: ("0"+selectedMinute).slice(-2)
        property string secondStr:("0"+selectedSecond).slice(-2)
        anchors.horizontalCenter: progressCircleContainer.horizontalCenter

        anchors.verticalCenter: progressCircleContainer.verticalCenter

        Text
        {

            visible: sleepTimerWidget.timeFormatShort
            id:displayText
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: textcolor
            text: (selectedHour ? textItem.hoursStr + '<font color="'+secondarytextcolor+'">:</font>' : '')
                  + (selectedMinute||selectedHour
                     ? textItem.minutesStr+'<font color="'+secondarytextcolor+'">:</font>'+textItem.secondStr
                     : (textItem.secondStr+qsTr("s")))
            font.pixelSize: sleepTimerWidget.fontSize
        }
        Text {
            visible: !sleepTimerWidget.timeFormatShort
            id:longDisplayText
            property string mainTag: '<span>'
            property string mainTagEnd: '</span>'
            property string smallTag: '<font color="'+secondarytextcolor+'" size="1">'
            property string smallTagEnd: '</font>'

            // couldn't think of something clever, so:
            Item {
                id: datestrings
                property string verboseHour: qsTr("Hour")
                property string verboseHours: qsTr("Hours")
                property string verboseMinute: qsTr("Minute")
                property string verboseMinutes: qsTr("Minutes")
                property string verboseSecond: qsTr("Second")
                property string verboseSeconds: qsTr("Seconds")
                //a bit redundant now, but to help fixed localisation later:
                property string abbrHour: qsTr("Hrs")
                property string abbrHours: qsTr("Hrs")
                property string abbrMinute: qsTr("Min")
                property string abbrMinutes: qsTr("Min")
                property string abbrSecond: qsTr("Sec")
                property string abbrSeconds: qsTr("Sec")


                property string hours: timeFomatAbbreviateIfLong ?  abbrHours : verboseHours
                property string hour: timeFomatAbbreviateIfLong ? abbrHour : verboseHour
                property string minutes: timeFomatAbbreviateIfLong ? abbrMinutes : verboseMinutes
                property string minute: timeFomatAbbreviateIfLong ? abbrMinute : verboseMinute
                property string seconds: timeFomatAbbreviateIfLong ? abbrSeconds : verboseSeconds
                property string second: timeFomatAbbreviateIfLong ? abbrSecond : verboseSecond
            }



            property bool showSecond: selectedSecond || running || milliSecondsLeft === 0

            anchors.centerIn: parent
            color: textcolor
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            //                       qsTr("text")
            text: mainTag
//            + secondarytextcolor + ' ' + textcolor + '<br>'
                  + (selectedHour? '<span>'+selectedHour+'</span>'+smallTag
                                   +(selectedHour==1
                                     ? datestrings.hour
                                     : datestrings.hours)
                                   + smallTagEnd+'<br />':'')
                  + (selectedHour || selectedMinute
                     ? '<span>'+selectedMinute+'</span>'+smallTag
                       + (selectedMinute == 1
                          ? datestrings.minute
                          : datestrings.minutes)
                       +smallTagEnd +
                       (showSecond
                            ?'<br />'
                            :'')
                     :'')
                  + (showSecond ? '<span>'+selectedSecond+'</span>'+smallTag
                                  +(selectedSecond == 1
                                    ? datestrings.second
                                    : datestrings.seconds)
                                  +smallTagEnd:'')
                  + mainTagEnd
            font.pixelSize: sleepTimerWidget.fontSize
            lineHeight: selectedHour && showSecond ? sleepTimerWidget.lineHeight: 1.0
        }
        Item {
            width: parent.width
            height: parent.height
//            anchors.fill: parent



        }
    }
}



