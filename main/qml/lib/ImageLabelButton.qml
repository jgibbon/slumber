import QtQuick 2.6
import Sailfish.Silica 1.0

BackgroundItem {
    id:sleepTimerWidget

    height: (sleepTimerWidgetImage.width + Theme.paddingSmall + sleepTimerWidgetLabel.font.pixelSize)//sleepTimerWidgetColumn.height
    width:  (isSmall? Theme.itemSizeSmall : Theme.itemSizeMedium)//sleepTimerWidgetColumn.width

    property alias label: sleepTimerWidgetLabel
    property alias image: sleepTimerWidgetImage
    //highlighted: true
    property bool isSmall
        Image {

            id: sleepTimerWidgetImage
//            source: '../icon-m-sleeptimer.png'

            opacity: sleepTimerWidget.enabled ? 1.0 : 0.4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: sleepTimerWidget.isSmall ? Theme.itemSizeSmall / 2 : Theme.itemSizeSmall
            height: sleepTimerWidget.isSmall ? Theme.itemSizeSmall / 2 : Theme.itemSizeSmall
        }

        Label {
            id: sleepTimerWidgetLabel
            width:parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            horizontalAlignment: 'AlignHCenter'
            //text:formatMSeconds(SleepTimer.remainingTime)
            font.pixelSize: sleepTimerWidget.isSmall ? Theme.fontSizeSmall : Theme.fontSizeMedium
        }
        //Rectangle { anchors.fill: parent; color: "red"; opacity: 0.3; z:-1; }

}
