import QtQuick 2.6
import Sailfish.Silica 1.0

import '../lib/'


Page {
    id: page

    allowedOrientations: Orientation.All


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge
            //: PageHeader: Options to reset the timer with smartwatch events from the amazfish application
            PageHeader { title: qsTr('Amazfish Integation', 'header; options') }
            Label {
                width: parent.width - (Theme.horizontalPageMargin * 2)
                x: Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                //: Label text: %1 is a comma separated list of smartwatch models
                text: qsTr('For some smartwatch models (at least %1), Amazfish exposes button presses.', '%1 is a comma separated list').arg('Amazfit Bip, Amazfit Bip Lite')
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
            }

            SettingsGrid {

                TextSwitch {
                    id:timerAmazfishButtonResetEnabledSwitch
                    // TextSwitch: Reset by pressing Amazfish watch button
                    //: TextSwitch: Reset by pressing Amazfish watch button
                    text: qsTr( 'Amazfish button press')

                    checked: settings.timerAmazfishButtonResetEnabled
                    onClicked: {
                        settings.timerAmazfishButtonResetEnabled = checked
                    }
                    // TextSwitch description: Reset by pressing Amazfish watch button
                    //: TextSwitch description: Reset by pressing Amazfish watch button
                    description: qsTr('Reset the timer by pressing the button on a device connected to the Amazfish application.')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }

                Slider {
                    id: timerAmazfishButtonResetPressesSlider
//                    width: parent.width
//                    anchors.horizontalCenter: parent.horizontalCenter
                    minimumValue: 1
                    maximumValue: 5
                    stepSize: 1
                    enabled: settings.timerAmazfishButtonResetEnabled
                    opacity: settings.timerAmazfishButtonResetEnabled ? 1.0 : 0.5
                    // Slider Value: Press Amazfish watch button x times to reset
                    //: Slider Value: Press Amazfish watch button x times to reset
                    valueText: qsTr('Press %L1 time', '', value).arg(value)
    //                            label:
                    onValueChanged: {
                        settings.timerAmazfishButtonResetPresses = value
                    }
                    Component.onCompleted: {
                        value = settings.timerAmazfishButtonResetPresses
                    }
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
            }

            Label {
                width: parent.width - (Theme.horizontalPageMargin * 2)
                x: Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                topPadding: Theme.paddingLarge
                //: Label text: %1 is a comma separated list of smartwatch models
                text: qsTr('For some smartwatch models (at least %1), Amazfish exposes when the music screen is opened.', '%1 is a comma separated list').arg('Amazfit Bip S, Amazfit GTS, PineTime')
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
            }

            TextSwitch {
                id:timerAmazfishMusicResetEnabledSwitch
                // TextSwitch: Reset by activating smartwatch music screen
                //: TextSwitch: Reset by activating smartwatch music screen
                text: qsTr( 'Amazfish music screen activation')

                checked: settings.timerAmazfishMusicResetEnabled
                onClicked: {
                    settings.timerAmazfishMusicResetEnabled = checked
                }
                // TextSwitch description: Reset by activating smartwatch music screen
                //: TextSwitch description: Reset by activating smartwatch music screen
                description: qsTr('Reset the timer by activating the music screen on a device connected to the Amazfish application.')
            }

        }
    }
}
