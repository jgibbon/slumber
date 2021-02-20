import QtQuick 2.6
import Sailfish.Silica 1.0


Text {
    id: timerText
    property alias description: subText.text
    property alias secondaryFontSize: subText.font.pixelSize
    property int value
    text: value
    width: (parent.width - Theme.paddingSmall) / 2
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity { NumberAnimation { duration: 500 } }
    Text {
        id: subText
        width: parent.width
        verticalAlignment: Text.AlignBottom
        anchors {
            left: parent.right
            leftMargin: Theme.paddingSmall
            bottom: parent.bottom
            bottomMargin: (timerText.font.pixelSize - subText.font.pixelSize) * 0.25
        }

        color: secondarytextcolor
        font.pixelSize: Theme.fontSizeTiny
    }
}
