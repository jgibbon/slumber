import QtQuick 2.6
import QtSensors 5.0

Item {
    id: accelerometerTrigger

    property double triggerThreshold: 4
    property int throttleTrigger: 1500 //trigger only once in this time frame (ms)

    property alias active: accel.active
    property alias reading: accel.reading
    property bool paused: false
    property alias proximityActive: proxi.active
    signal triggered()

    property double tmpmaxamount: 0 //maximum acceleration while triggered (for a duration of [throttleTrigger]), else 0. in case you want to know.
    property double amount:0 //current acceleration
    function triggerTimer(){

    }
    Timer {
        id: delaytimer
        repeat: false
        running: false
        interval: 1500
        onTriggered: {
            console.log('maximum acceleration: '+tmpmaxamount)
            tmpmaxamount = 0;
        }
    }
    ProximitySensor {
        id: proxi
        active: accelerometerTrigger.proximityActive
        onReadingChanged: {
            var prox = (proxi.active ? (proxi.reading.near ? "Near" : "Far") : "Unknown");
            if(prox === 'Near'){
                accelerometerTrigger.triggered()
            }
        }
    }

    Accelerometer {
        id: accel
//        active: options.timerMotionEnabled && options.timerMotionThreshold && sleepTimer.running
        property var acc: {//last values
            x:0
            y:0
            z:0
        }
        onReadingChanged: {
            var r = accel.reading;
            amount = Math.abs(r.x - acc.x) + Math.abs(r.y-acc.y) + Math.abs(r.z-acc.z);
            if(amount > options.timerMotionThreshold && amount > tmpmaxamount) {
                tmpmaxamount = amount;
                if(!delaytimer.running) {
                    delaytimer.start();
                    accelerometerTrigger.triggered()
                }
            }

            acc = {
                x: accel.reading.x,
                y: accel.reading.y,
                z: accel.reading.z
            }
        }
    }
}
