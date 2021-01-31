import QtQuick 2.6
import Launcher 1.0

Launcher {
    id:root
    property bool enabled
    property var options
    function pause(){
        var commands = [];
        if(options.timerLockScreenEnabled) {
            commands.push('sh -c \"\"\"dbus-send --system --type=method_call --dest=org.nemomobile.lipstick /devicelock org.nemomobile.lipstick.devicelock.setState int32:1 & dbus-send --system --dest=com.nokia.mce --print-reply --type=method_call /com/nokia/mce/request com.nokia.mce.request.req_display_state_off\"\"\"')
        }
        if(options.timerStopAlienEnabled) {
            commands.push('systemctl stop aliendalvik.service')
        }
        if(options.timerAirplaneModeEnabled) {
            commands.push('dbus-send --system --type=method_call --print-reply --dest=net.connman / net.connman.Manager.SetProperty string:\"OfflineMode\" variant:boolean:true')
        }
        if(options.timerDisableWLANEnabled) {
            commands.push('dbus-send --system --type=method_call --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:"Powered" variant:boolean:false')
        }
        if(options.timerDisableBluetoothEnabled) {
            commands.push('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/bluetooth net.connman.Technology.SetProperty string:"Powered" variant:boolean:false')
        }
        if(options.timerRestartOfonoEnabled) {
            commands.push('killall -s9 ofonod')
        }


        var commandCount = commands.length;
        for(var i=0; i<commandCount; i++) {
            console.log('launching privileged', commands[i]);
            console.log(launchPrivileged(commands[i]));
        }
    }
}


//ActionLaunchProgram {
//    commands: [
//
//    ]
//}
