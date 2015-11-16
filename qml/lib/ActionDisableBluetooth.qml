import QtQuick 2.0

import org.nemomobile.dbus 2.0
Item {
    property bool enabled
    id:root
    function pause(){
        if(enabled){
            dbif.disable()
        }
    }


    DBusInterface {
        id:dbif
        bus: DBus.SystemBus
        service: 'net.connman'
        path: '/net/connman/technology/bluetooth'
        iface: 'net.connman.Technology'
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
}
