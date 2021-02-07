import QtQuick 2.6
import QtMultimedia 5.6

ActuatorBase {
    function run() {
        playbackEl.play()
        done()
    }
    Audio {
        id: playbackEl
        autoLoad: true
        source: '../../assets/sound/void.mp3'
    }
}
