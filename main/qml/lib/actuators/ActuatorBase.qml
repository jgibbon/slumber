import QtQuick 2.6

Item {
    id: actuator
    property bool enabled
    property int doneDelay: 1
    visible: false

    function run() {
        console.log('overload this run thing');
        done()
    }
    function done() {
        doneTimer.start()
    }

    Timer {
        id: doneTimer
        interval: doneDelay
        onTriggered: {
            if(actuator.parent.next) {
                actuator.parent.next();
            }
        }
    }
}
