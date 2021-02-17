import QtQuick 2.6
import Sailfish.Silica 1.0

Grid {
    width: parent.width - ( 2 * Theme.horizontalPageMargin )
    columns: page.isLandscape || Screen.sizeCategory > Screen.Medium ? 2 : 1
    columnSpacing: Theme.paddingLarge
    anchors.horizontalCenter: parent.horizontalCenter
    readonly property real columnWidth: (width-columnSpacing*(columns - 1))/columns
}
