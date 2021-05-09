import QtQuick 2.6


Item {
    id:root

    property double duration: 1000
    property bool doReset: true

    property double resetToVolume
    property bool isIdle: true
    property bool isDone: false
    property bool hasBeenFaded: false
    property int resetTimerInterval: 450
    signal volumeResetDone // to trigger bt disable only after it's done
    onVolumeResetDone: {
        isDone = false
    }

    function start() {
        resetToVolume = VolumeControl.getVolume()
        if(resetToVolume > 1) {
            hasBeenFaded = true
            audiofadeout.from = resetToVolume
            audiofadeout.start()
        }
    }
    function reset(forceReset) {
        if(hasBeenFaded) {
            if(forceReset) {
                resetTimer.interval = 2; //cancel fast
            } else {
                resetTimer.interval = resetTimerInterval; // finish slowly
            }

            if(!root.isIdle) {
                audiofadeout.stop()
                if(doReset || forceReset) {
                    resetTimer.start()
                }
            }
        }
        hasBeenFaded = false;
    }
    function finish(){ //called when sleep timer is triggered to reset and fire event

        isDone = true;
        reset()
    }

    QtObject {
        id: volumeSet
        property int volume: resetToVolume
    }
    Timer {
        id: setTimer
        interval: 250
        repeat: true
        running: !isIdle
        onTriggered: {
            VolumeControl.setVolume(volumeSet.volume);
        }
    }

    Timer {
        id: resetTimer
        interval: 450 // some players take a while to pause. Not ideal.
        onTriggered: {
            VolumeControl.setVolume(resetToVolume)
            resetToVolume = -1
            doneTimer.start()
        }
    }
    Timer {
        id: doneTimer
        interval: 80
        onTriggered: {
            if(isDone) {
                volumeResetDone()
            }
        }
    }

    NumberAnimation{
        id:audiofadeout;
        target: volumeSet;
        property: 'volume';
        from:0
        to: 0;
        easing.type: Easing.Linear
        duration:root.duration
        onStarted: {
            isIdle = false
        }
        onStopped: {
            reset()
            isIdle = true
        }
    }
}

