import QtQuick 2.6
import Sailfish.Silica 1.0
import "../lib/"


Page {
    id: page

    property Options options
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

                    checked: options.viewActiveIndicatorEnabled
                    onClicked: {
                        options.viewActiveIndicatorEnabled = checked
                    }
                    description: qsTr('Show a rotating indicator on the main screen while the timer is running.')
                }
                TextSwitch {
                    id:viewActiveOptionsButtonEnabledSwitch
                    text: qsTr( "Show Options Button")

                    checked: options.viewActiveOptionsButtonEnabled
                    onClicked: {
                        options.viewActiveOptionsButtonEnabled = checked
                    }
                    description: qsTr('Show a shortcut to Options on the main screen while the timer is running. Otherwise, you\'d have to stop the timer first to get here.')
                }
                TextSwitch {
                    id:viewDarkenMainScreenEnabledSwitch
                    text: qsTr( "Darken main screen")

                    checked: options.viewDarkenMainSceen
                    onClicked: {
                        options.viewDarkenMainSceen = checked
                    }
                    //                    description: qsTr('Show a shortcut to Options on the main screen while the timer is running. Otherwise, you\'d have to stop the timer first to get here.')
                }
                Item {

                    visible: viewDarkenMainScreenEnabledSwitch.checked
                    width: parent.width
                    height: darkenColumn.height
                    BackgroundItem {
                        anchors.fill: darkenColumn
                        opacity: options.viewDarkenMainScreenAmount*0.8

                        _backgroundColor:'black'
                        //        _backgroundColor: options.viewDarkenMainSceen ? 'black' : 'transparent';

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

                            opacity: ((1-options.viewDarkenMainScreenAmount))*0.75 + 0.25
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
//                            label:
                            onValueChanged: {
                                //                        console.log('clicked')
                                //                        console.log(value, options.viewDarkenMainScreenAmount, (value * 0.9) + 0.1);
                                options.viewDarkenMainScreenAmount = (value * 0.9) + 0.1

                            }
                            Component.onCompleted: {
                                value = (options.viewDarkenMainScreenAmount / 0.9) - 0.1
                            }

                        }

                        Label {
                            id: darkenLabel
                            width: parent.width-Theme.itemSizeSmall
                            visible: options.timerMotionEnabled
                            x: Theme.paddingLarge
                            font.pixelSize: Theme.fontSizeExtraSmall
                            verticalAlignment: Text.AlignBottom

                            opacity: ((1-options.viewDarkenMainScreenAmount))*0.75 + 0.25

                            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                            text:qsTr("Use darker colours while the timer is running")
                            color: Theme.secondaryColor
                        }
//                        TextSwitch {
//                            id: darkenSwitch
//                            width: parent.width
//                            opacity: darkenSlider.opacity
//                            text: qsTr( "Only while running")
//                            checked: options.viewDarkenMainSceenOnlyWhenRunning
//                            onClicked: {
//                                options.viewDarkenMainSceenOnlyWhenRunning = checked
//                            }
//                        }
                    }
                }

                TextSwitch {
                    width: parent.width
                    id:viewTimeFormatShortEnabledSwitch
                    text: qsTr( "Display compact time format")

                    checked: options.viewTimeFormatShort
                    onClicked: {
                        options.viewTimeFormatShort = checked
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
