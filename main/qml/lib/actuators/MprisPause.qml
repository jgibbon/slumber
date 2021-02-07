import QtQuick 2.6
import Nemo.DBus 2.0

ActuatorBase {
    property var services: []
    function run(){
        playerQuery.typedCall('ListNames', undefined, replyFactory(), function(err){console.log('error query', err)});
        done();
    }
    function replyFactory() {
        return function filterDbusServicesAndPause(dbusReply) {
            var filtered = dbusReply.filter(function(entry) {
                return entry.indexOf('org.mpris.MediaPlayer2.') === 0
            });
            filtered.forEach(function(el, i){
                console.log('found mpris player', el);
                dbif.service = el;
                dbif.call('Pause', undefined);
            });
            console.log('mpris done')
            done()
        }
    }

    DBusInterface {
        id:dbif
        service: 'org.mpris.MediaPlayer2.jolla-mediaplayer' // this gets overridden
        path: '/org/mpris/MediaPlayer2'
        iface: 'org.mpris.MediaPlayer2.Player'
    }
    DBusInterface {
        id: playerQuery
        service: 'org.freedesktop.DBus'
        iface: 'org.freedesktop.DBus'
        path: '/org/freedesktop/DBus'
    }
}
