import QtQuick 2.6
import Sailfish.Silica 1.0

Button {
    id: background
    property alias _iconButton: iconButton
    property alias _label: label
    property alias icon: iconButton.icon
    property alias text: label.text
    property int horizontalPadding: Theme.horizontalPageMargin

    height: Math.max(iconButton.height, label.height)
//    Button {
//        enabled: false
//        anchors {
//            fill:parent
//            leftMargin: background.horizontalPadding
//            rightMargin: background.horizontalPadding
//        }
//        down: background.down
//        propagateComposedEvents: true
//    }

    IconButton {
        id: iconButton
        down: background.down
        propagateComposedEvents: true
        enabled: false
        icon.opacity: background.enabled ? 1.0 : 0.4
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: background.horizontalPadding
        }
    }
    Label {
        id: label
        anchors {
            right: parent.right
            left: iconButton.right
            verticalCenter: parent.verticalCenter
            leftMargin: Theme.paddingLarge
            rightMargin: background.horizontalPadding
        }
        color: down ? Theme.highlightColor : Theme.primaryColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
