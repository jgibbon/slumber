import QtQuick 2.6
import QtQuick.LocalStorage 2.0


QtObject {
    id: legacyoptions
    objectName: 'options'

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

    property Timer autoDestructTimer: Timer {
        interval: 200
        onTriggered: {
            settings.legacySettingsPossiblyAvailable = false;
        }
    }

    Component.onCompleted: {
        console.log("legacy options import!");
        var db = LocalStorage.openDatabaseSync('Talefish','1.0','Settings', 5000);

        db.transaction(
                    function (tx) {

                        // Load fields
                        for (var fieldName in legacyoptions) {
                            //values starting with 'on' should be blatantly ignored
                            if ( fieldName in options && fieldName.lastIndexOf('on', 0) !== 0) {

                                var rs = tx.executeSql('SELECT value FROM settings WHERE settingsName=? AND keyName=?;', [legacyoptions.objectName, fieldName]);

                                if (rs.rows.length > 0) {
                                    //obj[fieldName] = JSON.parse(rs.rows.item(0).value);
                                    var value = JSON.parse(rs.rows.item(0).value);
                                    console.log("legacy options import: set ", fieldName, "to", value);
                                    settings[fieldName] = value;

                                }
                            }
                        }
                        autoDestructTimer.start();
                    });
    }
}
