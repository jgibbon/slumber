import QtQuick 2.6
import Sailfish.Silica 1.0

import '../lib/'


Page {
    id: page

    allowedOrientations: Orientation.All

    function request(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(xhr.readyState === XMLHttpRequest.DONE) {
                    callback(myxhr);
                }
            }
        })(xhr);
        xhr.open('GET', url, true);
        xhr.send('');
    }

    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            bottomPadding: Theme.paddingLarge
            //: PageHeader: Options for things to do when the timer runs out
            PageHeader { title: qsTr('Actions') }

            SettingsGrid {
                id: grid

                TextSwitch {
                    id:timerpauseEnabledSwitch
                    //: TextSwitch: pause media player when timer runs out
                    text: qsTr( 'Pause local media')

                    checked: settings.timerPauseEnabled
                    onClicked: {
                        settings.timerPauseEnabled = checked
                    }
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }

                HighlightImageButton {
                    // Button Text: Go to "pause network players" (vlc/kodi) option page
                    //: ButtonText: Go to "pause network players" (vlc/kodi) option page
                    text: qsTr('Pause Network Players');
                    icon.source: 'image://theme/icon-m-lan'
                    onClicked: pageStack.push(Qt.resolvedUrl('Options_TimerEnd_NetworkPlayers.qml'))

                    width: parent.columnWidth
                }

                TextSwitch {
                    id:timerBTDisconnectEnabledSwitch
                    //: Switch: Action "Disconnect Bluetooth Devices" when timer runs out
                    text: qsTr( 'Disconnect Bluetooth Devices')

                    checked: settings.timerBTDisconnectEnabled
                    onClicked: {
                        settings.timerBTDisconnectEnabled = checked
                    }
                    //: TextSwitch Description: Action "Disconnect Bluetooth Devices" when timer runs out
                    description: qsTr('Disconnects active Bluetooth connections')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                }
                TextSwitch {
                    id:timerBTDisconnectOnlyAudioEnabled
                    //: TextSwitch: Do not disconnect all Bluetooth devices, only Audio
                    text: qsTr( 'Only disconnect Audio Devices')
                    enabled: settings.timerBTDisconnectEnabled
                    checked: settings.timerBTDisconnectOnlyAudioEnabled
                    onClicked: {
                        settings.timerBTDisconnectOnlyAudioEnabled = checked
                    }
                    //: TextSwitch description: Do not disconnect all Bluetooth devices, only Audio
                    description: qsTr('Limits Bluetooth disconnects to audio devices like Speakers')
                    width: parent.columnWidth
                    leftMargin: 0
                    rightMargin: 0
                    height: implicitHeight + Theme.paddingLarge
                }


            }

            HighlightImageButton {
                //: ButtonText: go to dedicated settings page for Privileged Actions; they require administrative rights (root)
                text: qsTr('Privileged Actions');
                icon.source: 'image://theme/icon-m-developer-mode'
                onClicked: pageStack.push(Qt.resolvedUrl('Options_TimerEnd_Privileged.qml'))
                width: parent.width - x*2
                x: Theme.horizontalPageMargin
            }

        }
    }
}
