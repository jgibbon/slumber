import QtQuick 2.0
import org.nemomobile.dbus 2.0

Item {
    property bool enabled: false
    onEnabledChanged: {
        console.log('screen blank:', enabled)
        dbif.call("req_display"+(enabled?"":"_cancel")+"_blanking_pause", undefined)
    }
    Component.onDestruction: {
        if(enabled){
            enabled=false
        }
    }

    DBusInterface {
            id: dbif

            service: "com.nokia.mce"
            path: "/com/nokia/mce/request"
            iface: "com.nokia.mce.request"

            bus: DBusInterface.SystemBus
        }
}

