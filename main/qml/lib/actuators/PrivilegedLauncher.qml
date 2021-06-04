import QtQuick 2.6
import de.gibbon.slumber 1.0

ActuatorBase {
    function run(){
        var commands = [];
        if(settings.timerLockScreenEnabled) {
            commands.push('sh -c \"\"\"dbus-send --system --type=method_call --dest=org.nemomobile.lipstick /devicelock org.nemomobile.lipstick.devicelock.setState int32:1 & dbus-send --system --dest=com.nokia.mce --print-reply --type=method_call /com/nokia/mce/request com.nokia.mce.request.req_display_state_off\"\"\"')
        }
        if(settings.timerStopAlienEnabled) {
            commands.push('systemctl stop aliendalvik.service')
        }
        if(settings.timerAirplaneModeEnabled) {
            commands.push('dbus-send --system --type=method_call --print-reply --dest=net.connman / net.connman.Manager.SetProperty string:\"OfflineMode\" variant:boolean:true')
        }
        if(settings.timerDisableWLANEnabled) {
            commands.push('dbus-send --system --type=method_call --print-reply --dest=net.connman /net/connman/technology/wifi net.connman.Technology.SetProperty string:"Powered" variant:boolean:false')
        }
        if(settings.timerDisableBluetoothEnabled) {
            commands.push('dbus-send --system --print-reply --dest=net.connman /net/connman/technology/bluetooth net.connman.Technology.SetProperty string:"Powered" variant:boolean:false')
        }
        if(settings.timerRestartOfonoEnabled) {
            commands.push('killall -9 ofonod');
        }

        var commandCount = commands.length;
        for(var i=0; i<commandCount; i++) {
            console.log('launching privileged', commands[i]);
            console.log(launcher.launchPrivileged(commands[i]));
        }
        done();
    }
    Launcher {
        id: launcher
    }
}
