import QtQuick 2.0
import org.nemomobile.dbus 2.0

//import org.nemomobile.mpris 1.0

Item {
    id: musicControl
    property var services: [
        "org.mpris.MediaPlayer2.jolla-mediaplayer",
        "org.mpris.MediaPlayer2.sailfish-browser",
        "org.mpris.MediaPlayer2.quasarmx",
        "org.mpris.MediaPlayer2.sirensong",
        "org.mpris.MediaPlayer2.daedalus",
        "org.mpris.MediaPlayer2.kodimote",
        "org.mpris.MediaPlayer2.CuteSpot",
        "org.mpris.MediaPlayer2.flowplayer",
        "org.mpris.MediaPlayer2.CuteSpotify",
        //those probably won't appear on SFOS any time soon:
        "org.mpris.MediaPlayer2.spotify",
        "org.mpris.MediaPlayer2.rhythmbox",
        "org.mpris.MediaPlayer2.vlc",
    ]
    function pause(){
        musicControl.services.forEach(function(el, i){
            dbif.service = el;
            dbif.call('Pause', undefined);
        });
//        mprisManager.pause()
//        browserif.call('openUrl',['http://www.heise.de'])
    }


//    MprisManager { id: mprisManager }

    DBusInterface {
        id:dbif
        service: 'org.mpris.MediaPlayer2.jolla-mediaplayer'
        path: '/org/mpris/MediaPlayer2'
        iface: 'org.mpris.MediaPlayer2.Player'
    }

//    DBusInterface {
//        id:browserif
//        service: 'org.sailfishos.browser'
//        path: '/org/sailfishos/browser'
//        iface: 'org.sailfishos.browser'
////        signalsEnabled: true
//    }
    Component.onCompleted: {
    }
}
