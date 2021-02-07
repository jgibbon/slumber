import QtQuick 2.6
import QtMultimedia 5.6
import "actuators" as Actuator

Item {
    property alias accelerometerTrigger: accelerometerTrigger

    property alias fadeOutSound: fadeOutSound
//    property alias actionPauseKodi: actionPauseKodi
//    property alias actionPauseVLC: actionPauseVLC


    ScreenBlank {
        enabled: settings.timerInhibitScreensaverEnabled && SleepTimer.running
    }

    AccelerometerTrigger {
        id: accelerometerTrigger
        paused: false
        triggerThreshold: settings.timerMotionThreshold
        active: settings.timerMotionEnabled && settings.timerMotionThreshold && SleepTimer.running && !paused
        proximityActive: settings.timerWaveMotionEnabled && SleepTimer.running
        onTriggered: function(){
            SleepTimer.start()
        }
    }
    AmazfitButtonTrigger {
        enabled: settings.timerAmazfishButtonResetEnabled
        onButtonPressed: {
//            console.log('well…', SleepTimer.running, presses, settings.timerAmazfishButtonResetPresses, presses === settings.timerAmazfishButtonResetPresses)
            if(SleepTimer.running && presses === settings.timerAmazfishButtonResetPresses) {
                SleepTimer.start()
            }
        }
    }

    VolumeFade {
        id: volumeFade
        duration: SleepTimer.finalizeMilliseconds
        doReset: settings.timerFadeResetEnabled
    }
    TimerNotificationTrigger {
        id: timerNotificationTrigger
        onTriggered: function(){
            SleepTimer.stop()
        }
    }
    Timer { // dont display mpris notification if we stopped it ourselves
        id: justTriggeredTimer
        interval: 500
    }
    ActuatorManager {
        id: actuators
            Actuator.MprisPause { enabled: settings.timerPauseEnabled }
            Actuator.VoidPlayPause { enabled: settings.timerPauseEnabled }
            Actuator.NetworkKodi {
                enabled: settings.timerKodiPauseEnabled
                host: settings.timerKodiPauseHost
                user: settings.timerKodiPauseUser
                password: settings.timerKodiPausePassword
                secondaryCommand: settings.timerKodiSecondaryCommand
            }
            Actuator.NetworkVLC {
                enabled: settings.timerVLCPauseEnabled
                host: settings.timerVLCPauseHost
                user: settings.timerVLCPauseUser
                password: settings.timerVLCPausePassword
            }
            Actuator.ActuatorBase {
                enabled: settings.timerNotificationTriggerEnabled
                function run() {
                    timerNotificationTrigger.reset();
                    done();
                }
            }
            Actuator.ActuatorBase {
                enabled: settings.timerFadeEnabled && settings.timerFadeResetEnabled
                /*
                  There is a delay to reset volume for "slower" media players.
                  We don't want BT/network/… to be disabled before this is done, or
                  it will start with 0 volume on next connect.
                */
                doneDelay: 450
                function run() {
                    volumeFade.finish();
                    done();
                }
            }
            Actuator.DisconnectBT {
                enabled: settings.timerBTDisconnectEnabled
                onlyDisconnectAudioDevices: settings.timerBTDisconnectOnlyAudioEnabled
            }
            Actuator.PrivilegedLauncher {
                enabled: true
            }
    }

    Connections {
        target: SleepTimer
        onTimeout: {
            console.log('sleep timer fired!');
            dbus.emitSignal('Triggered');
            justTriggeredTimer.start();
            actuators.run();
        }

        onFinalizingChanged: {
            if(SleepTimer.finalizing) {
                if(settings.timerFadeEnabled) {
                    if(settings.timerFadeSoundEffectEnabled) {
                        fadeOutSound.play();
                    }
                    if(settings.timerFadeEnabled) {
                        volumeFade.start();
                    }
                }
                if(settings.timerNotificationTriggerEnabled) {
                    timerNotificationTrigger.start()
                }
            } else {
                fadeOutSound.stop();
                if(settings.timerFadeEnabled) {
                    volumeFade.reset(true); //reset volume even if not enabled in options
                }
                timerNotificationTrigger.reset()
            }
        }
    }


    Item {
        id: fadeOutSound
        property string file: settings.timerFadeSoundEffectFile
        property SoundEffect effect

        onFileChanged: {
            stop()
            if(file === "cassette-noise") {
                effect = fadeOutSoundCassette;
            } else if(file === "clock-ticking") {
                effect = fadeOutSoundTicking;
            } else if(file === "sea-waves") {
                effect = fadeOutSoundSea;
            }
        }

        function play(){
            stop()
            if(effect){
                effect.play()
            }
        }
        function stop(){
            fadeOutSoundCassette.stop()
            fadeOutSoundTicking.stop()
            fadeOutSoundSea.stop()
        }


        SoundEffect {
            id:fadeOutSoundCassette
            category: 'slumber'
            source: '../assets/sound/cassette-noise.wav'
            volume: settings.timerFadeSoundEffectVolume
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }


        SoundEffect {
            id:fadeOutSoundTicking
            category: 'slumber'
            source: '../assets/sound/clock-ticking.wav'
            volume: settings.timerFadeSoundEffectVolume
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }

        SoundEffect {
            id:fadeOutSoundSea
            category: 'slumber'
            source: '../assets/sound/sea-waves.wav'
            volume: settings.timerFadeSoundEffectVolume
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }
    }
    Loader {
        active: settings.timerAutostartOnPlaybackDetection
        asynchronous: true
        sourceComponent: scannerComponent
        Component {
            id: scannerComponent
            MprisPlayingScanner {
                enabled: !SleepTimer.running
                reverseEnabled: settings.timerAutostopOnPlaybackStop && !justTriggeredTimer.running
                onTriggered: {
                    SleepTimer.start()
                }
                onReverseTriggered: {
                    SleepTimer.stop()
                }
            }
        }
    }

}

