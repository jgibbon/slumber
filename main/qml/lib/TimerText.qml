import QtQuick 2.6
import Sailfish.Silica 1.0


Text {
    property alias description: subText.text
    width: (parent.width - Theme.paddingSmall) / 2
    horizontalAlignment: Text.AlignRight
    Behavior on opacity { NumberAnimation { duration: 500 } }
    Text {
        id: subText
        width: parent.width
        anchors {
            left: parent.right
            leftMargin: Theme.paddingSmall
            bottom: parent.bottom
            bottomMargin: sleepTimerWidget.fontSize * 0.1
        }

        color: secondarytextcolor
        font.pixelSize: Theme.fontSizeTiny
    }
}
