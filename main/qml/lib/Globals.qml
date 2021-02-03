import QtQuick 2.6
import QtMultimedia 5.6

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
        enabled: settings.timerAmazfishButtonResetEnabled
        onButtonPressed: {
//            console.log('well…', SleepTimer.running, presses, settings.timerAmazfishButtonResetPresses, presses === settings.timerAmazfishButtonResetPresses)
            if(SleepTimer.running && presses === settings.timerAmazfishButtonResetPresses) {
                SleepTimer.start()
            }
        }
    }

    Item {
        id:actionPauseByPlayingVoid
        property var pause: function(){
            playbackEl.play()
        }
        Audio {
            id: playbackEl
            autoLoad: true
            source: '../assets/sound/void.mp3'
        }
    }
    ActionDBusPauseMediaplayers {
        id:actionPauseByDbus
    }
    ActionDBusDisconnectBluetooth {
        id: actionBt
        enabled: settings.timerBTDisconnectEnabled
        onlyDisconnectAudioDevices: settings.timerBTDisconnectOnlyAudioEnabled
    }

    ActionPrivilegedLauncher {
        id: actionPrivilegedLauncher
    }

    ActionNetworkKodi{
        id: actionPauseKodi
        enabled: settings.timerKodiPauseEnabled
        host: settings.timerKodiPauseHost
        user: settings.timerKodiPauseUser
        password: settings.timerKodiPausePassword
        secondaryCommand: settings.timerKodiSecondaryCommand
    }

    ActionNetworkVLC{
        id: actionPauseVLC
        enabled: settings.timerVLCPauseEnabled
        host: settings.timerVLCPauseHost
        user: settings.timerVLCPauseUser
        password: settings.timerVLCPausePassword
    }
    VolumeFade {
        id: volumeFade
        duration: SleepTimer.finalizeMilliseconds
        doReset: settings.timerFadeResetEnabled
        onVolumeResetDone: {
            /*
              There is a delay to reset volume for "slower" media players.
              We don't want BT/network/… to be disabled before this is done, or
              it will start with 0 volume on next connect.
            */
            actionBt.pause(function btCallback(){
                actionPrivilegedLauncher.pause()
                SleepTimer.stop()
            });
        }
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


    Connections {
        target: SleepTimer
        onTimeout: {
            console.log('sleep timer fired!');
            dbus.emitSignal('Triggered');
            justTriggeredTimer.start()
            if(settings.timerPauseEnabled) {
                actionPauseByDbus.pause(function(){ //only use the fallback after async mpris scanning is done
                    //gpodder, maybe others
                    actionPauseByPlayingVoid.pause()
                });
            }
            actionPauseKodi.action(function(o, success){
                console.log('Kodi: success', success)
            });
            actionPauseVLC.action(function(o, success){
                console.log('VLC: success', success)
            });

            timerNotificationTrigger.reset()
            if(settings.timerFadeEnabled && settings.timerFadeResetEnabled) {
                volumeFade.finish() // triggers BT after it's done
            } else { // disable bt directly
                actionBt.pause(function btCallback(){
                    actionPrivilegedLauncher.pause()
                    SleepTimer.stop()
                });
            }
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

