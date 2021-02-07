import QtQuick 2.6
import Nemo.DBus 2.0

ActuatorBase {
    id: btDeviceDisconnect
    property var services: []
    property bool onlyDisconnectAudioDevices: true
    function run(){
        console.log('bt list')
        disconnectDelay.start()
    }
    function replyFactory() {
        return function filterDbusServices(dbusReply) {
            var devices = [];
            for (var key in dbusReply) {
                //check if it's a paired device ;)
                if('org.bluez.Device1' in dbusReply[key] && dbusReply[key]['org.bluez.Device1'].Paired && dbusReply[key]['org.bluez.Device1'].Connected) {
                    console.log('paired & connected device:', dbusReply[key]['org.bluez.Device1'].Name, 'type:', dbusReply[key]['org.bluez.Device1'].Icon, 'key:', key);
                    if(btDeviceDisconnect.onlyDisconnectAudioDevices) {
                        if(dbusReply[key]['org.bluez.Device1'].Icon === 'audio-card') {
                            console.log('audio device found')
                            devices.push(key);
                        } else {
                            console.log('device not matched:', JSON.stringify(dbusReply[key]['org.bluez.Device1']));
                        }

                    } else {
                        console.log('disconnect ALL the devices!');
                        devices.push(key);
                    }
                }
            }

            devices.forEach(function(el, i){
                console.log('trying to disconnect', el);
                dbif.path = el;
                dbif.call('Disconnect', undefined);
            });
            console.log('dbus bt disconnects done')
            done();
        }
    }
    Timer {
        id: disconnectDelay
        interval: 200
        onTriggered: {
            deviceQuery.typedCall('GetManagedObjects', undefined, replyFactory(), function(err){console.log('error query', err)})
        }
    }

    DBusInterface {
        id:dbif
        bus: DBus.SystemBus
        service: 'org.bluez'
        path: '/org/bluez/…' //will be set in replyFactory
        iface: 'org.bluez.Device1'
    }
    DBusInterface {
        id: deviceQuery
        bus: DBus.SystemBus
        service: 'org.bluez'
        iface: 'org.freedesktop.DBus.ObjectManager'
        path: '/'

    }
}
