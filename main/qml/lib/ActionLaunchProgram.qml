import QtQuick 2.6
import de.gibbon.slumber 1.0


Launcher {
    id:root
    property bool enabled
    property var commands: []
    function pause(){
        if(enabled){
            var commandCount = commands.length;
            for(var i=0; i<commandCount; i++) {
                console.log('launching', commands[i]);
                console.log(launch(commands[i]));
            }
        }
    }
}

