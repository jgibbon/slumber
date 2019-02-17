import QtQuick 2.0
import Nemo.DBus 2.0
import Nemo.Notifications 1.0

Item {
    id: scanner
    property bool enabled: true //generally enabled
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

    onMprisIsPlayingChanged: {
        if(mprisIsPlaying && enabled) {
            notificationComponent.publish()
            triggered()
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
        appName: 'slumber'
        body: qsTr('%1 Playback detected: Timer autostart').arg(scanner.mprisPlayingName)
        expireTimeout: 3000
        category: "x-nemo.example"
        replacesId: 1
        summary: 'slumber'
        itemCount: 1
        maxContentLines: 3
        previewSummary: 'slumber'
        previewBody: qsTr('Autostart: %1 is playing').arg(scanner.mprisPlayingName)

    }
    Component.onDestruction: notificationComponent.close()
}
