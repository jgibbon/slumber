import QtQuick 2.0


Item {
    id:root

    property double duration: 1000
    property bool doReset: true

    property double resetToVolume
    property bool isIdle: true
    signal volumeResetDone // to trigger bt disable only after it's done

    function start() {
           audiofadeout.from = VolumeControl.volume
           audiofadeout.start()
      }
    function reset() {
       if(!root.isIdle) {
          if(doReset) {
          resetTimer.start()
          }
           audiofadeout.stop()
       }
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
            volumeResetDone()
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

