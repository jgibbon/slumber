import QtQuick 2.0

import Nemo.DBus 2.0
//this only works if no window is in foreground -.-
Item {
    property bool enabled
    id:root
    function pause(){
        if(enabled){
            var ret = dbif.call('setState', 1);
        }
    }


    DBusInterface {
        id:dbif
        bus:DBus.SystemBus
        service: 'org.nemomobile.lipstick'
        path: '/devicelock'

        iface: 'org.nemomobile.lipstick.devicelock'
        signalsEnabled: true
    }
}
