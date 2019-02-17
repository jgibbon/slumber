import QtQuick 2.0


Item {
    id:root

    property double duration: 1000
    property bool doReset: true

    property double resetToVolume
    property bool isIdle: true
    property bool isDone: false
    property int resetTimerInterval: 450
    signal volumeResetDone // to trigger bt disable only after it's done
    onVolumeResetDone: {
        isDone = false
    }

    function start() {
           audiofadeout.from = VolumeControl.volume
           audiofadeout.start()
      }
    function reset(forceReset) {
        if(forceReset) {
            resetTimer.interval = 2; //cancel fast
        } else {
            resetTimer.interval = resetTimerInterval; // finish slowly
        }

       if(!root.isIdle) {
          if(doReset || forceReset) {
            resetTimer.start()
          }
           audiofadeout.stop()
       }
     }
    function finish(){ //called when sleep timer is triggered to reset and fire event
        isDone = true;
        reset()
    }

    Item {
        id: volumeSet
        property int volume: VolumeControl.volume
        onVolumeChanged: {
            if(!isIdle) {
                VolumeControl.volume = volume
            }
        }

    }
    Timer {
        id: resetTimer
        interval: 450
        onTriggered: {
            VolumeControl.volume = resetToVolume
            if(root.isDone) {
                volumeResetDone()
            }
        }
    }

    NumberAnimation{
        id:audiofadeout;
        target: volumeSet;
        property: "volume";
        from:0
        to: 0;
        duration:root.duration
        onStarted: {
            isIdle = false
            resetToVolume = VolumeControl.volume
        }
        onStopped: {
            reset()
            isIdle = true
        }
    }
}

