import QtQuick 2.6
import QtMultimedia 5.6
import 'actuators' as Actuator

Item {
    property alias accelerometerTrigger: accelerometerTrigger
    property alias fadeOutSound: fadeOutSound

    property alias actionPauseKodi: actionPauseKodi
    property alias actionPauseVLC: actionPauseVLC


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
        enabled: settings.timerAmazfishButtonResetEnabled || settings.timerAmazfishMusicResetEnabled
        onButtonPressed: {
            if(SleepTimer.running && presses === settings.timerAmazfishButtonResetPresses) {
                SleepTimer.start()
            }

        }
        onMusicAppActivated: {
            if(SleepTimer.running) {
                SleepTimer.start()
            }
        }
    }

    VolumeFade {
        id: volumeFade
        duration: SleepTimer.finalizeSeconds * 1000
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
                id: actionPauseKodi
                enabled: settings.timerKodiPauseEnabled
                host: settings.timerKodiPauseHost
                user: settings.timerKodiPauseUser
                password: settings.timerKodiPausePassword
                secondaryCommand: settings.timerKodiSecondaryCommand
            }
            Actuator.NetworkVLC {
                id: actionPauseVLC
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
        onTriggered: {
            console.log('sleep timer fired!');
            if(SleepTimer.running) { // this can be triggered manually (and/or via dbus)
                SleepTimer.stop();
            }

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

        onRestarted: {
            console.log('restarted')
            if(settings.timerSoundOnResetEnabled) {
                fadeOutSound.setBaseVolume();
                resetSound.play();
            }
        }
    }


    Item {
        id: fadeOutSound
        property string file: settings.timerFadeSoundEffectFile
        property SoundEffect effect
        property real baseVolume: 1.0
        property bool relative: settings.timerSoundEffectVolumeRelativeEnabled
        onRelativeChanged: {
            setBaseVolume();
        }

        onFileChanged: {
            stop()
            if(file === 'cassette-noise') {
                effect = fadeOutSoundCassette;
            } else if(file === 'clock-ticking') {
                effect = fadeOutSoundTicking;
            } else if(file === 'sea-waves') {
                effect = fadeOutSoundSea;
            }
        }

        function setBaseVolume() {
            if(settings.timerSoundEffectVolumeRelativeEnabled) {
                baseVolume = volumeFade.getCurrentMediaVolume();
            } else {
                baseVolume = 1.0
            }

            console.log('ok, so volume may be', baseVolume, settings.timerSoundEffectVolumeRelativeEnabled)

        }

        function play(){
            baseVolume = 0.0
            setBaseVolume()
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
            volume: settings.timerFadeSoundEffectVolume * fadeOutSound.baseVolume
            loops: SoundEffect.Infinite
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }


        SoundEffect {
            id:fadeOutSoundTicking
            category: 'slumber'
            source: '../assets/sound/clock-ticking.wav'
            loops: SoundEffect.Infinite
            volume: settings.timerFadeSoundEffectVolume * fadeOutSound.baseVolume
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }

        SoundEffect {
            id:fadeOutSoundSea
            category: 'slumber'
            source: '../assets/sound/sea-waves.wav'
            loops: SoundEffect.Infinite
            volume: settings.timerFadeSoundEffectVolume * fadeOutSound.baseVolume
            onPlayingChanged: {
                if(!playing) { accelerometerTrigger.paused = false}
            }
        }

        Component.onCompleted: {
            setBaseVolume()
        }
    }
    SoundEffect {
        id: resetSound
        category: 'slumber'
        source: '../assets/sound/blip.wav'
        volume: settings.timerFadeSoundEffectVolume * fadeOutSound.baseVolume
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

