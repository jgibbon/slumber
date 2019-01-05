import QtQuick 2.0
import Launcher 1.0

ActionLaunchProgram {
    commands: [
        'dbus-send --system --print-reply --dest=net.connman /net/connman/technology/bluetooth net.connman.Technology.SetProperty string:"Powered" variant:boolean:false'
    ]
}
