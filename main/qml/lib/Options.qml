import QtQuick 2.6


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
