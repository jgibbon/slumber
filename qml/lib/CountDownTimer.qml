import QtQuick 2.0
/*Todo:
 - Use just one Timer (1s loop)
    - set new end date on (re)start
    -

*/
Rectangle {
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
//        console.log('try to restart timer')
        if(!enabled) {
            return stop();
        }

        countdownTimer.restart();
        milliSecondsLeft = interval;
        nearlyDone = false;
        onReset();
    }
    function start () {
        restart();

    }
    function stop () {
        countdownTimer.stop();
        nearlyDone = false;
        milliSecondsLeft = interval;
        onReset();
    }
    //settable methods
    property var triggerBeforeInterval: function(){}
    property var onTriggered: function(){}//dirty? likey?
    property var onReset: function(){}//dirty? likey?
    Timer{
        id: countdownTimer
        repeat: false
        running: false
//        onRunningChanged: {
//            if(running){

//            }
//            console.log('timer running changed: '+running);
//        }
        onTriggered: {

            timerComponent.nearlyDone = false;
            timerComponent.onTriggered()

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
            triggerBeforeInterval();
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
//            console.log('secondstimer - '+milliSecondsLeft);
            timerComponent.milliSecondsLeft = timerComponent.milliSecondsLeft - interval

        }
    }
}
