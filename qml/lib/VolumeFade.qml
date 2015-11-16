import QtQuick 2.0

import QtMultimedia 5.0

import org.nemomobile.dbus 2.0

Item {
    id:root

    property double duration: 1000

    property double resetToVolume

    function start() {audiofadeout.start()}

    SoundEffect {
        id: volumeReadout
    }

    Item {
        id: volumeSet
        volume: volumeReadout.volume
        onVolumeChanged: {
            console.log('volume changed', volume);
        }

    }
//    dbus-send --print-reply --type=method_call --address='unix:path=/run/user/100000/pulse/dbus-socket' --dest=org.Meego.MainVolume2 /com/meego/mainvolume2 org.freedesktop.DBus.Properties.GetAll string:com.Meego.MainVolume2
/*
dbus-send --type=method_call --print-reply  --address='unix:path=/run/user/100000/pulse/dbus-socket' --dest=org.Meego.MainVolume2 /com/meego/mainvolume2 org.freedesktop.DBus.Introspectable.Introspect


-> Set



*/
    DBusInterface {
        id:dbif
        bus: DBus.SystemBus
        service: 'com.Meego'
        path: '/com/meego/mainvolume2'
        iface: 'com.Meego.MainVolume2'
        function enable(){
            var valueVariant = true;
            dbif.typedCall('SetProperty', [
                {'type':'s', 'value': 'Powered'},
                {'type':'v', 'value': valueVariant}
            ]);
        }

        function disable(){
            var valueVariant = false;
            dbif.typedCall('SetProperty', [
                {'type':'s', 'value': 'Powered'},
                {'type':'v', 'value': valueVariant}
            ]);
        }
    }

    NumberAnimation{
        id:audiofadeout;
        target: volumeSet;
        property: "volume";
        from:volumeReadout.volume;
        to: 0;
        duration:root.duration
        onStarted: {
            root.resetToVolume = volumeReadout
        }
        onStopped: {
            volumeSet.volume = resetToVolume
        }
    }

}

