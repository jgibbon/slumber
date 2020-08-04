import QtQuick 2.0
/*Todo:
 - Use just one Timer (1s loop)
    - set new end date on (re)start
    -

*/
Item {
    id:timerComponent
    property alias interval: countdownTimer.interval
    property alias repeat: countdownTimer.repeat
    property alias running: countdownTimer.running
    property bool nearlyDone: false
    property alias triggeredOnStart: countdownTimer.triggeredOnStart
    property bool enabled: true
    //own attributes
    property int triggerBeforeIntervalDuration: 2000
    property int milliSecondsLeft: countdownTimer.interval
    //methods
    function restart () {
        if(!enabled) {
            return stop();
        }

        countdownTimer.restart();
        milliSecondsLeft = interval;
        nearlyDone = false;
        reset();
    }
    function start () {
        restart();

    }
    function stop () {
        countdownTimer.stop();
        nearlyDone = false;
        milliSecondsLeft = interval;
        reset();
    }
    signal triggerBeforeInterval
    signal triggered
    signal reset

    Timer{
        id: countdownTimer
        repeat: false
        running: false
        onTriggered: {

            timerComponent.nearlyDone = false;
            timerComponent.triggered()

        }
        onIntervalChanged: {
            milliSecondsLeft= interval
            if(running){
                restart()
            }
        }
    }

    Timer {
        id: nearlyDoneTimer
        running: countdownTimer.running
        repeat: true
        interval: countdownTimer.interval - triggerBeforeIntervalDuration
        onTriggered: {
            timerComponent.triggerBeforeInterval();
            timerComponent.nearlyDone = true;
        }

    }
    //one second tick
    Timer {
        id: secondsTimer
        running: countdownTimer.running
        repeat: true
        interval: 1000
        onTriggered: {
            timerComponent.milliSecondsLeft = timerComponent.milliSecondsLeft - interval

        }
    }
}
