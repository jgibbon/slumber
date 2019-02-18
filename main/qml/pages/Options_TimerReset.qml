import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0


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
            PageHeader { title: qsTr("slumber Reset") }

            SectionHeader {
                text: qsTr("Accelerometer")
            }

            ComboBox {
                id:timerreset
//                visible: timerEnabledSwitch.checked
                width: parent.width
                label: (currentIndex ? qsTr('Reset after'):qsTr('Reset Timer by moving the device'))

                currentIndex: -1
                property int readIndex: 0+currentIndex
               
                menu: ContextMenu {
                    Component.onCompleted: {
                    }

                    id: timeropts
                    Repeater {
                        model: ListModel {
                            dynamicRoles: true
                        }
                        Component.onCompleted: {

                            //v0.1 - 0.3 transition, there were other values
                            var oldVals = [8],
                                newVals = [20],
                                oldIndex = oldVals.indexOf(options.timerMotionThreshold);
                            if(oldIndex > -1){
                                console.log('Replacing deprecated accelerometer setting ', oldVals[oldIndex], 'with', newVals[oldIndex]);
                                options.timerMotionThreshold = newVals[oldIndex];
                            }
                            //end value transition

                            model.append({"value": 0,
                                                    "text":qsTr('off')});
                            model.append({"value": 0.1,
                                                    "text":qsTr('tiniest sign of life')});
                            model.append({"value": 0.3,
                                                    "text":qsTr('slight bump')});
                            model.append({"value": 0.9,
                                                    "text":qsTr('a bit of movement')});
                            model.append({"value": 1.4,
                                                    "text":qsTr('some acceleration')});
                            model.append({"value": 20,
                                                    "text":qsTr('shaking')});
                            model.append({"value": 40,
                                                    "text":qsTr('earthquake')});
                        }

                        MenuItem {
                            text: model.text ? model.text + '' : '-'

                            onClicked: {

                                if(index === 0) {
                                    options.timerMotionThreshold = 0;
                                    options.timerMotionEnabled = false;
                                } else {
                                    options.timerMotionThreshold = model.value;
                                    options.timerMotionEnabled = true;
                                }
                            }

                            Component.onCompleted: {
                                if(model.value === options.timerMotionThreshold || model.value === 0 && !options.timerMotionEnabled) {
                                    timerreset.currentIndex = index
                                }

                            }
                        }

                    }

                }


            }


            Label {
                width: parent.width-Theme.itemSizeSmall
                visible: options.timerMotionEnabled
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeExtraSmall
                verticalAlignment: Text.AlignBottom


                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                text:qsTr('Using the Accelerometer may have an impact on power consumption while playing and only works when the Display is lit. You can Tap thrice to wake up your Device and trigger the Accelerometer.')
                color: Theme.highlightColor
            }


            SectionHeader {
                text: qsTr("Proximity Sensor")
            }
            TextSwitch {
                id:timerWaveMotionEnabledSwitch
                text: qsTr( "Wave in front of screen")

                checked: options.timerWaveMotionEnabled
                onClicked: {
                    options.timerWaveMotionEnabled = checked
                }
                description: qsTr('Reset the timer by holding your hand in front of the screen.')
            }

            TextSwitch {
                id:timerNotificationEnabledSwitch
                text: qsTr( "Notification")

                checked: options.timerNotificationTriggerEnabled
                onClicked: {
                    options.timerNotificationTriggerEnabled = checked
                }
                description: qsTr('Display a Notification shortly before the Timer runs out. Notifications activate the Screen and, with it, Accelerometer readings.')
            }

            Item {
                width:parent.width
                height: Theme.paddingLarge
            }
        }
    }
}
