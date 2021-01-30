import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    property alias options: options
    property alias sleepTimer: sleepTimer
//    property alias appstate: appstate
    property alias accelerometerTrigger: accelerometerTrigger

    //    property alias volume: volume
    property alias fadeOutSound: fadeOutSound
    //    property alias audiofadeout: audiofadeout
    property alias actionPauseKodi: actionPauseKodi
    property alias actionPauseVLC: actionPauseVLC

    PersistentObject {
        id: options
        objectName: 'options'
        doPersist: true

        //timer
        property bool timerEnabled: false
        property bool timerInhibitScreensaverEnabled: false

        property int timerSeconds: 900
        property bool timerMotionEnabled:false
        property bool timerWaveMotionEnabled:false
        property real timerMotionThreshold: 0

        property bool timerPauseEnabled: true
        property bool timerAmazfishButtonResetEnabled: false
        property int timerAmazfishButtonResetPresses: 1

        //privileged commands start
        property bool timerLockScreenEnabled: false
        property bool timerStopAlienEnabled: false
        property bool timerAirplaneModeEnabled: false
        property bool timerDisableWLANEnabled: false
        property bool timerDisableBluetoothEnabled: false
        property bool timerRestartOfonoEnabled: false
        //privileged commands end
//        property var timerActionRunCommands: []//todo

        property bool timerKodiPauseEnabled: false
        property string timerKodiPauseHost: ''
        property string timerKodiPauseUser: ''
        property string timerKodiPausePassword: ''
        property string timerKodiSecondaryCommand: '' //System.Shutdown, System.Suspend

        property bool timerVLCPauseEnabled: false
        property string timerVLCPauseHost: ''
        property string timerVLCPauseUser: ''
        property string timerVLCPausePassword: ''


        property bool timerBTDisconnectEnabled: false
        property bool timerBTDisconnectOnlyAudioEnabled: false

        property bool timerNotificationTriggerEnabled: false
        property bool timerFadeEnabled: true // todo reimplement fadeout volume
        property bool timerFadeResetEnabled: true //todo reset volume afterwards

        property bool timerFadeSoundEffectEnabled: true
        property string timerFadeSoundEffectFile: 'cassette-noise'
        property bool timerFadeVisualEffectEnabled: false

        property real timerFadeSoundEffectVolume: 0.5

        property bool timerAutostartOnPlaybackDetection: false
        property bool timerAutostopOnPlaybackStop: true


        property real viewDarkenMainScreenAmount: 0.7
        property bool viewDarkenMainSceen:false
        property bool viewTimeFormatShort:false
        property bool viewActiveIndicatorEnabled: true
        property bool viewActiveOptionsButtonEnabled: false

    }

    ScreenBlank {
        enabled: options.timerInhibitScreensaverEnabled && sleepTimer.running
    }

    AccelerometerTrigger {
        id: accelerometerTrigger
        paused: false
        triggerThreshold: options.timerMotionThreshold
        active: options.timerMotionEnabled && options.timerMotionThreshold && sleepTimer.running && !paused
        proximityActive: options.timerWaveMotionEnabled && sleepTimer.running
        onTriggered: function(){
            sleepTimer.restart()
        }
    }
    AmazfitButtonTrigger {
        enabled: options.timerAmazfishButtonResetEnabled
        onButtonPressed: {
//            console.log('well…', sleepTimer.running, presses, options.timerAmazfishButtonResetPresses, presses === options.timerAmazfishButtonResetPresses)
            if(sleepTimer.running && presses === options.timerAmazfishButtonResetPresses) {
                sleepTimer.restart()
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
        enabled: options.timerBTDisconnectEnabled
        onlyDisconnectAudioDevices: options.timerBTDisconnectOnlyAudioEnabled
    }

    ActionPrivilegedLauncher {
        id: actionPrivilegedLauncher
        options: options
    }

    ActionNetworkKodi{
        id: actionPauseKodi
        enabled: options.timerKodiPauseEnabled
        host: options.timerKodiPauseHost
        user: options.timerKodiPauseUser
        password: options.timerKodiPausePassword
        secondaryCommand: options.timerKodiSecondaryCommand
    }

    ActionNetworkVLC{
        id: actionPauseVLC
        enabled: options.timerVLCPauseEnabled
        host: options.timerVLCPauseHost
        user: options.timerVLCPauseUser
        password: options.timerVLCPausePassword
    }
    VolumeFade {
        id: volumeFade
        duration: sleepTimer.triggerBeforeIntervalDuration
        doReset: options.timerFadeResetEnabled
        onVolumeResetDone: {
            /*
              There is a delay to reset volume for "slower" media players.
              We don't want BT/network/… to be disabled before this is done, or
              it will start with 0 volume on next connect.
            */

            actionBt.pause(function btCallback(){
                actionPrivilegedLauncher.pause()
            });
        }
    }
    TimerNotificationTrigger {
        id: timerNotificationTrigger
        onTriggered: function(){
            sleepTimer.stop()
        }

    }

    CountDownTimer {
        id: sleepTimer
        interval: options.timerSeconds * 1000
        enabled: true
        property double targetVolume: 1
        triggerBeforeIntervalDuration: 10000
        onTriggerBeforeInterval: { // ten seconds before triggering
            if(options.timerFadeEnabled) {
                if(options.timerFadeSoundEffectEnabled) {
                    fadeOutSound.play();
                }
                if(options.timerFadeEnabled) {
                    volumeFade.start();
                }
            }
            if(options.timerNotificationTriggerEnabled) {
                timerNotificationTrigger.start()
            }
        }
        onTriggered: {
            console.log('sleep timer fired!');
            dbus.emitSignal('Triggered');

            if(options.timerPauseEnabled) {
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
            sleepTimer.stop()
            if(options.timerFadeEnabled && options.timerFadeResetEnabled) {
                volumeFade.finish() // triggers BT after it's done
            } else { // disable bt directly
                actionBt.pause(function btCallback(){
                    actionPrivilegedLauncher.pause()
                });
            }
        }
        onReset: {
            console.log((sleepTimer.running ? 'reset' : 'start') + ' timer');


            fadeOutSound.stop();
            if(options.timerFadeEnabled) {
                volumeFade.reset(true); //reset volume even if not enabled in options
            }
            timerNotificationTrigger.reset()
        }

        Item {
            id: fadeOutSound
            property string file: options.timerFadeSoundEffectFile
            property SoundEffect effect
            property alias volume: options.timerFadeSoundEffectVolume

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
                volume: options.timerFadeSoundEffectVolume
                onPlayingChanged: {
                    if(!playing) { accelerometerTrigger.paused = false}
                }
            }


            SoundEffect {
                id:fadeOutSoundTicking
                category: 'slumber'
                source: '../assets/sound/clock-ticking.wav'
                volume: options.timerFadeSoundEffectVolume
                onPlayingChanged: {
                    if(!playing) { accelerometerTrigger.paused = false}
                }
            }

            SoundEffect {
                id:fadeOutSoundSea
                category: 'slumber'
                source: '../assets/sound/sea-waves.wav'
                volume: options.timerFadeSoundEffectVolume
                onPlayingChanged: {
                    if(!playing) { accelerometerTrigger.paused = false}
                }
            }
        }

    }
    Loader {
        active: options.timerAutostartOnPlaybackDetection
        asynchronous: true
        sourceComponent: scannerComponent
        Component {
            id: scannerComponent
            MprisPlayingScanner {
                enabled: !sleepTimer.running
                reverseEnabled: options.timerAutostopOnPlaybackStop
                onTriggered: {
                    sleepTimer.start()
                }
                onReverseTriggered: {
                    sleepTimer.stop()
                }
            }
        }
    }

}

