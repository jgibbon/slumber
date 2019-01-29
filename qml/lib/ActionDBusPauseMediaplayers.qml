import QtQuick 2.0
import Nemo.DBus 2.0

Item {
    id: musicControl
    property var services: []
    function pause(cb){
        playerQuery.typedCall('ListNames', undefined, replyFactory(cb), function(err){console.log('error query', err)})
    }
    function replyFactory(cb) {
        return function filterDbusServicesAndPause(dbusReply) {
            var filtered = dbusReply.filter(function(entry) {
                return entry.indexOf('org.mpris.MediaPlayer2.') === 0
            });
            filtered.forEach(function(el, i){
                console.log('found mpris player', el);
                dbif.service = el;
                dbif.call('Pause', undefined);
            });
            console.log('mpris done, running callback')
            if(cb) {
                cb();
            }
        }
    }

    DBusInterface {
        id:dbif
        service: 'org.mpris.MediaPlayer2.jolla-mediaplayer'
        path: '/org/mpris/MediaPlayer2'
        iface: 'org.mpris.MediaPlayer2.Player'
    }
    DBusInterface {
        id: playerQuery
        bus: DBus.SessionBus
        service: 'org.freedesktop.DBus'
        iface: 'org.freedesktop.DBus'
        path: '/org/freedesktop/DBus'

    }
}
