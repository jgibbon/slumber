import QtQuick 2.6
import Sailfish.Silica 1.0

Label {
    property alias buttonText: button.text
    property alias icon: button.icon
    property string clickTarget // for some reason type url doesn't work in sfos 3.4 here?!
    color: Theme.highlightColor
    font.pixelSize: Theme.fontSizeExtraSmall
    verticalAlignment: Text.AlignBottom
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    topPadding: button.height + Theme.paddingMedium
    bottomPadding: Theme.paddingLarge
    width: parent.columnWidth

    HighlightImageButton {
        id: button
        width: parent.width
        onClicked: pageStack.push(clickTarget)
    }
}
