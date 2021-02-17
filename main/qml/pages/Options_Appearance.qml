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
            //: PageHeader: appearance options/UI settings page
            PageHeader { title: qsTr('Appearance') }

            SettingsGrid {

                TextSwitch {
                    //                    width: parent.width
                    id:viewTimeFormatShortEnabledSwitch
                    //: TextSwitch: Enable a short time format for the timer duration, like 1:23:45
                    text: qsTr( 'Compact time format')

                    checked: settings.viewTimeFormatShort
                    onClicked: {
                        settings.viewTimeFormatShort = checked
                    }
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
                TextSwitch {
                    id:activeIndicatorEnabledSwitch
                    //: TextSwitch: Enable a rotating thing on the main page when the timer runs
                    text: qsTr( 'Indicator')

                    checked: settings.viewActiveIndicatorEnabled
                    onClicked: {
                        settings.viewActiveIndicatorEnabled = checked
                    }
                    //: TextSwitch description: Enable a rotating thing on the main page when the timer runs
                    description: qsTr('Show a rotating indicator on the main screen while the timer is running.')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }

                TextSwitch {
                    id:viewActiveOptionsButtonEnabledSwitch
                    //: TextSwitch: Enable a dedicated button to get to the settings
                    text: qsTr( 'Options Button')

                    checked: settings.viewActiveOptionsButtonEnabled
                    onClicked: {
                        settings.viewActiveOptionsButtonEnabled = checked
                    }
                    //: TextSwitch description: Enable a dedicated button to get to the settings
                    description: qsTr('Show a shortcut to Options on the main screen while the timer is running. Otherwise, you\'d have to stop the timer first to get here.')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
                TextSwitch {
                    id:viewDarkenMainScreenEnabledSwitch
                    //: TextSwitch: show main page a bit darker when the timer runs
                    text: qsTr( 'Darken main screen')

                    checked: settings.viewDarkenMainSceen
                    onClicked: {
                        settings.viewDarkenMainSceen = checked
                    }
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
            }
            SilicaItem {
                Component.onCompleted: {
                    if(Theme.colorScheme === Theme.DarkOnLight) {
                        palette.colorScheme = Theme.LightOnDark
                        palette.highlightColor = Theme.highlightFromColor(Theme.highlightColor, Theme.LightOnDark)
                    }
                }

                opacity: viewDarkenMainScreenEnabledSwitch.checked ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation {} }
                visible: opacity > 0
                width: parent.width
                height: darkenColumn.height
                Rectangle {
                    anchors.fill: darkenColumn
                    opacity: settings.viewDarkenMainScreenAmount*0.8
                    color:'black'
                }

                Column {

                    id: darkenColumn
                    width: parent.width
                    bottomPadding: Theme.paddingLarge

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
                        width: parent.width-Theme.horizontalPageMargin*2
                        visible: viewDarkenMainScreenEnabledSwitch.checked
                        x: Theme.horizontalPageMargin
                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignHCenter
                        highlighted: darkenSlider.highlighted

                        opacity: ((1-settings.viewDarkenMainScreenAmount))*0.75 + 0.25

                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        //: description label: show main page a bit darker when the timer runs
                        text:qsTr('Use darker colours while the timer is running')
                        color: palette.secondaryColor
                    }
                }
            }

        }
    }
}
