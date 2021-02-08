import QtQuick 2.6
import Sailfish.Silica 1.0


Text {
    property int value
    property alias description: subText.text
    width: parent.width / 2
    text: value
    horizontalAlignment: Text.AlignRight
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
