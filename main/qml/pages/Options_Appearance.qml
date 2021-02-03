import QtQuick 2.6
import Sailfish.Silica 1.0
import "../lib/"


Page {
    id: page
    property FirstPage firstPage

    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: qsTr("slumber Appearance") }


                TextSwitch {
                    id:activeIndicatorEnabledSwitch
                    text: qsTr( "Show indicator")

                    checked: settings.viewActiveIndicatorEnabled
                    onClicked: {
                        settings.viewActiveIndicatorEnabled = checked
                    }
                    description: qsTr('Show a rotating indicator on the main screen while the timer is running.')
                }
                TextSwitch {
                    id:viewActiveOptionsButtonEnabledSwitch
                    text: qsTr( "Show Options Button")

                    checked: settings.viewActiveOptionsButtonEnabled
                    onClicked: {
                        settings.viewActiveOptionsButtonEnabled = checked
                    }
                    description: qsTr('Show a shortcut to Options on the main screen while the timer is running. Otherwise, you\'d have to stop the timer first to get here.')
                }
                TextSwitch {
                    id:viewDarkenMainScreenEnabledSwitch
                    text: qsTr( "Darken main screen")

                    checked: settings.viewDarkenMainSceen
                    onClicked: {
                        settings.viewDarkenMainSceen = checked
                    }
                    //                    description: qsTr('Show a shortcut to Options on the main screen while the timer is running. Otherwise, you\'d have to stop the timer first to get here.')
                }
                Item {

                    visible: viewDarkenMainScreenEnabledSwitch.checked
                    width: parent.width
                    height: darkenColumn.height
                    BackgroundItem {
                        anchors.fill: darkenColumn
                        opacity: settings.viewDarkenMainScreenAmount*0.8

                        _backgroundColor:'black'
                        //        _backgroundColor: settings.viewDarkenMainSceen ? 'black' : 'transparent';

                        //                                Behavior on opacity {
                        //                                    NumberAnimation { duration: 1000 }
                        //                                }
                    }

                    Column {

                        id: darkenColumn
                        width: parent.width
                        height: darkenSlider.height + darkenLabel.height

                        Slider {
                            id: darkenSlider

                            opacity: ((1-settings.viewDarkenMainScreenAmount))*0.75 + 0.25
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
//                            label:
                            onValueChanged: {
                                settings.viewDarkenMainScreenAmount = (value * 0.9) + 0.1

                            }
                            Component.onCompleted: {
                                value = (settings.viewDarkenMainScreenAmount / 0.9) - 0.1
                            }

                        }

                        Label {
                            id: darkenLabel
                            width: parent.width-Theme.itemSizeSmall
                            visible: settings.timerMotionEnabled
                            x: Theme.paddingLarge
                            font.pixelSize: Theme.fontSizeExtraSmall
                            verticalAlignment: Text.AlignBottom

                            opacity: ((1-settings.viewDarkenMainScreenAmount))*0.75 + 0.25

                            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                            text:qsTr("Use darker colours while the timer is running")
                            color: Theme.secondaryColor
                        }
//                        TextSwitch {
//                            id: darkenSwitch
//                            width: parent.width
//                            opacity: darkenSlider.opacity
//                            text: qsTr( "Only while running")
//                            checked: settings.viewDarkenMainSceenOnlyWhenRunning
//                            onClicked: {
//                                settings.viewDarkenMainSceenOnlyWhenRunning = checked
//                            }
//                        }
                    }
                }

                TextSwitch {
                    width: parent.width
                    id:viewTimeFormatShortEnabledSwitch
                    text: qsTr( "Display compact time format")

                    checked: settings.viewTimeFormatShort
                    onClicked: {
                        settings.viewTimeFormatShort = checked
                    }
                }
            }

//            SectionHeader {

////                visible: timerEnabledSwitch.checked
//                text: "Fade out"
////                color: Theme.secondaryColor
//            }



    }
}
