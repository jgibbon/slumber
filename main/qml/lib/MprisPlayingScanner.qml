import QtQuick 2.6
import Nemo.DBus 2.0
import Nemo.Notifications 1.0

Item {
    id: scanner
    property bool enabled: true //generally enabled
    property bool reverseEnabled: true
    Component.onCompleted: {
        playerQuery.query();
    }

    property bool mprisIsPlaying: false
    property string mprisPlayingService
    property string mprisPlayingName: {
        var match = mprisPlayingService.match(/([^.]+)$/);
        return match ? match[0] : '';
    }

    signal triggered()
    signal reverseTriggered()

    onMprisIsPlayingChanged: {
        console.log("mpris change playing", mprisIsPlaying)
        if(mprisIsPlaying && enabled) {
            notificationComponent.previewBody = 'slumber '+ qsTr('Autostart: %1 is playing').arg(scanner.mprisPlayingName);
            notificationComponent.publish();
            triggered()
        } else if(!mprisIsPlaying && reverseEnabled) {
            notificationComponent.previewBody = 'slumber '+ qsTr('stopped…');
            notificationComponent.publish();
            reverseTriggered();
        }

    }

    ListModel {
        id: playersModel
    }

    DBusInterface {
        id: playerQuery
        bus: DBus.SessionBus
        service: 'org.freedesktop.DBus'
        iface: 'org.freedesktop.DBus'
        path: '/org/freedesktop/DBus'

        function query(){
            playerQuery.typedCall('ListNames', undefined, filterDbusServices, function(err){console.log('error query', err)})
        }

    }
    function filterDbusServices(dbusReply) {
        var filtered = dbusReply.filter(function(entry) {
            return entry.indexOf('org.mpris.MediaPlayer2.') === 0
        });

        var currentEntries = [];
        for(var i=0; i<playersModel.count; i++) {
            var existingEntry = playersModel.get(i).dbusService;
            if(filtered.indexOf(existingEntry) === -1) {
                console.log('mpris player removed:', existingEntry);
                playersModel.remove(i, 1);
                i--;
            } else {
                currentEntries.push(existingEntry);
            }
        }
        filtered.forEach(function(el, i){
            if(currentEntries.indexOf(el) === -1) {
                playersModel.append({dbusService: el});
                console.log('found new mpris player', el);
            }
        });
    }
    Repeater {
        model: playersModel
        delegate: Item {
            DBusInterface {
                id:dbif
                service: dbusService
                path: '/org/mpris/MediaPlayer2'
                iface: 'org.mpris.MediaPlayer2.Player'
                property bool isPlaying: false
                onIsPlayingChanged: {
                    if(isPlaying) {
                        scanner.mprisPlayingService = service;
                        scanner.mprisIsPlaying = true;
                    } else {
                        if(scanner.mprisPlayingService === service) {
                            scanner.mprisPlayingService = '';
                            scanner.mprisIsPlaying = false;
                        }
                    }
                }

                function queryPlayback() {
                    isPlaying = getProperty('PlaybackStatus') === 'Playing';
                }

                signalsEnabled: true
                propertiesEnabled: true
                onPropertiesChanged: queryPlayback()
                Component.onCompleted: queryPlayback()

                Component.onDestruction: {
                    if(scanner.mprisPlayingService === service) {
                        scanner.mprisPlayingService = '';
                        scanner.mprisIsPlaying = false;
                    }
                }
            }
        }
    }

    Timer {
        id: playerQueryTimer
        interval: 2000
        running: scanner.enabled
        repeat: true
        onTriggered: playerQuery.query()
    }

    Notification {
        id: notificationComponent
        expireTimeout: 3000
        replacesId: 0
        icon: 'image://theme/icon-m-night'
//        previewBody:

    }
    Component.onDestruction: notificationComponent.close()
}
