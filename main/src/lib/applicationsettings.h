#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <QObject>
#include <QSettings>

class ApplicationSettings : public QObject {
    Q_OBJECT

    // TODO: remove at some point with the legacy exporter
    Q_PROPERTY(bool legacySettingsPossiblyAvailable READ getLegacySettingsPossiblyAvailable WRITE setLegacySettingsPossiblyAvailable NOTIFY legacySettingsPossiblyAvailableChanged)

    Q_PROPERTY(bool timerInhibitScreensaverEnabled READ getTimerInhibitScreensaverEnabled WRITE setTimerInhibitScreensaverEnabled NOTIFY timerInhibitScreensaverEnabledChanged)
    Q_PROPERTY(int timerSeconds READ getTimerSeconds WRITE setTimerSeconds NOTIFY timerSecondsChanged)
    Q_PROPERTY(int timerFinalizingSeconds READ getTimerFinalizingSeconds WRITE setTimerFinalizingSeconds NOTIFY timerFinalizingSecondsChanged)
    Q_PROPERTY(bool timerSoundOnResetEnabled READ getTimerSoundOnResetEnabled WRITE setTimerSoundOnResetEnabled NOTIFY timerSoundOnResetEnabledChanged)
    Q_PROPERTY(bool timerMotionEnabled READ getTimerMotionEnabled WRITE setTimerMotionEnabled NOTIFY timerMotionEnabledChanged)
    Q_PROPERTY(bool timerWaveMotionEnabled READ getTimerWaveMotionEnabled WRITE setTimerWaveMotionEnabled NOTIFY timerWaveMotionEnabledChanged)
    Q_PROPERTY(float timerMotionThreshold READ getTimerMotionThreshold WRITE setTimerMotionThreshold NOTIFY timerMotionThresholdChanged)
    Q_PROPERTY(bool timerPauseEnabled READ getTimerPauseEnabled WRITE setTimerPauseEnabled NOTIFY timerPauseEnabledChanged)
    Q_PROPERTY(bool timerAmazfishButtonResetEnabled READ getTimerAmazfishButtonResetEnabled WRITE setTimerAmazfishButtonResetEnabled NOTIFY timerAmazfishButtonResetEnabledChanged)
    Q_PROPERTY(bool timerAmazfishMusicResetEnabled READ getTimerAmazfishMusicResetEnabled WRITE setTimerAmazfishMusicResetEnabled NOTIFY timerAmazfishMusicResetEnabledChanged)
    Q_PROPERTY(int timerAmazfishButtonResetPresses READ getTimerAmazfishButtonResetPresses WRITE setTimerAmazfishButtonResetPresses NOTIFY timerAmazfishButtonResetPressesChanged)
    Q_PROPERTY(bool timerLockScreenEnabled READ getTimerLockScreenEnabled WRITE setTimerLockScreenEnabled NOTIFY timerLockScreenEnabledChanged)
    Q_PROPERTY(bool timerStopAlienEnabled READ getTimerStopAlienEnabled WRITE setTimerStopAlienEnabled NOTIFY timerStopAlienEnabledChanged)
    Q_PROPERTY(bool timerAirplaneModeEnabled READ getTimerAirplaneModeEnabled WRITE setTimerAirplaneModeEnabled NOTIFY timerAirplaneModeEnabledChanged)
    Q_PROPERTY(bool timerDisableWLANEnabled READ getTimerDisableWLANEnabled WRITE setTimerDisableWLANEnabled NOTIFY timerDisableWLANEnabledChanged)
    Q_PROPERTY(bool timerDisableBluetoothEnabled READ getTimerDisableBluetoothEnabled WRITE setTimerDisableBluetoothEnabled NOTIFY timerDisableBluetoothEnabledChanged)
    Q_PROPERTY(bool timerRestartOfonoEnabled READ getTimerRestartOfonoEnabled WRITE setTimerRestartOfonoEnabled NOTIFY timerRestartOfonoEnabledChanged)
    Q_PROPERTY(bool timerKodiPauseEnabled READ getTimerKodiPauseEnabled WRITE setTimerKodiPauseEnabled NOTIFY timerKodiPauseEnabledChanged)
    Q_PROPERTY(QString timerKodiPauseHost READ getTimerKodiPauseHost WRITE setTimerKodiPauseHost NOTIFY timerKodiPauseHostChanged)
    Q_PROPERTY(QString timerKodiPauseUser READ getTimerKodiPauseUser WRITE setTimerKodiPauseUser NOTIFY timerKodiPauseUserChanged)
    Q_PROPERTY(QString timerKodiPausePassword READ getTimerKodiPausePassword WRITE setTimerKodiPausePassword NOTIFY timerKodiPausePasswordChanged)
    Q_PROPERTY(QString timerKodiSecondaryCommand READ getTimerKodiSecondaryCommand WRITE setTimerKodiSecondaryCommand NOTIFY timerKodiSecondaryCommandChanged)
    Q_PROPERTY(bool timerVLCPauseEnabled READ getTimerVLCPauseEnabled WRITE setTimerVLCPauseEnabled NOTIFY timerVLCPauseEnabledChanged)
    Q_PROPERTY(QString timerVLCPauseHost READ getTimerVLCPauseHost WRITE setTimerVLCPauseHost NOTIFY timerVLCPauseHostChanged)
    Q_PROPERTY(QString timerVLCPauseUser READ getTimerVLCPauseUser WRITE setTimerVLCPauseUser NOTIFY timerVLCPauseUserChanged)
    Q_PROPERTY(QString timerVLCPausePassword READ getTimerVLCPausePassword WRITE setTimerVLCPausePassword NOTIFY timerVLCPausePasswordChanged)
    Q_PROPERTY(bool timerBTDisconnectEnabled READ getTimerBTDisconnectEnabled WRITE setTimerBTDisconnectEnabled NOTIFY timerBTDisconnectEnabledChanged)
    Q_PROPERTY(bool timerBTDisconnectOnlyAudioEnabled READ getTimerBTDisconnectOnlyAudioEnabled WRITE setTimerBTDisconnectOnlyAudioEnabled NOTIFY timerBTDisconnectOnlyAudioEnabledChanged)
    Q_PROPERTY(bool timerNotificationTriggerEnabled READ getTimerNotificationTriggerEnabled WRITE setTimerNotificationTriggerEnabled NOTIFY timerNotificationTriggerEnabledChanged)
    Q_PROPERTY(bool timerFadeEnabled READ getTimerFadeEnabled WRITE setTimerFadeEnabled NOTIFY timerFadeEnabledChanged)
    Q_PROPERTY(bool timerFadeResetEnabled READ getTimerFadeResetEnabled WRITE setTimerFadeResetEnabled NOTIFY timerFadeResetEnabledChanged)
    Q_PROPERTY(bool timerFadeSoundEffectEnabled READ getTimerFadeSoundEffectEnabled WRITE setTimerFadeSoundEffectEnabled NOTIFY timerFadeSoundEffectEnabledChanged)
    Q_PROPERTY(QString timerFadeSoundEffectFile READ getTimerFadeSoundEffectFile WRITE setTimerFadeSoundEffectFile NOTIFY timerFadeSoundEffectFileChanged)
    Q_PROPERTY(bool timerFadeVisualEffectEnabled READ getTimerFadeVisualEffectEnabled WRITE setTimerFadeVisualEffectEnabled NOTIFY timerFadeVisualEffectEnabledChanged)
    Q_PROPERTY(float timerFadeSoundEffectVolume READ getTimerFadeSoundEffectVolume WRITE setTimerFadeSoundEffectVolume NOTIFY timerFadeSoundEffectVolumeChanged)
    Q_PROPERTY(bool timerAutostartOnPlaybackDetection READ getTimerAutostartOnPlaybackDetection WRITE setTimerAutostartOnPlaybackDetection NOTIFY timerAutostartOnPlaybackDetectionChanged)
    Q_PROPERTY(bool timerAutostopOnPlaybackStop READ getTimerAutostopOnPlaybackStop WRITE setTimerAutostopOnPlaybackStop NOTIFY timerAutostopOnPlaybackStopChanged)
    Q_PROPERTY(float viewDarkenMainScreenAmount READ getViewDarkenMainScreenAmount WRITE setViewDarkenMainScreenAmount NOTIFY viewDarkenMainScreenAmountChanged)
    Q_PROPERTY(bool viewDarkenMainSceen READ getViewDarkenMainSceen WRITE setViewDarkenMainSceen NOTIFY viewDarkenMainSceenChanged)
    Q_PROPERTY(bool viewTimeFormatShort READ getViewTimeFormatShort WRITE setViewTimeFormatShort NOTIFY viewTimeFormatShortChanged)
    Q_PROPERTY(bool viewActiveIndicatorEnabled READ getViewActiveIndicatorEnabled WRITE setViewActiveIndicatorEnabled NOTIFY viewActiveIndicatorEnabledChanged)
    Q_PROPERTY(bool viewActiveOptionsButtonEnabled READ getViewActiveOptionsButtonEnabled WRITE setViewActiveOptionsButtonEnabled NOTIFY viewActiveOptionsButtonEnabledChanged)

public:
    explicit ApplicationSettings(QObject *parent = Q_NULLPTR);


    bool getLegacySettingsPossiblyAvailable() const;
    void setLegacySettingsPossiblyAvailable(bool value);


    //timer
    bool getTimerInhibitScreensaverEnabled() const;
    void setTimerInhibitScreensaverEnabled(bool value);

    int getTimerSeconds() const;
    void setTimerSeconds(int value);

    int getTimerFinalizingSeconds() const;
    void setTimerFinalizingSeconds(int value);

    bool getTimerSoundOnResetEnabled() const;
    void setTimerSoundOnResetEnabled(bool value);

    bool getTimerWaveMotionEnabled() const;
    void setTimerWaveMotionEnabled(bool value);

    bool getTimerMotionEnabled() const;
    void setTimerMotionEnabled(bool value);

    float getTimerMotionThreshold() const;
    void setTimerMotionThreshold(float value);

    bool getTimerPauseEnabled() const;
    void setTimerPauseEnabled(bool value);

    bool getTimerAmazfishButtonResetEnabled() const;
    void setTimerAmazfishButtonResetEnabled(bool value);

    bool getTimerAmazfishMusicResetEnabled() const;
    void setTimerAmazfishMusicResetEnabled(bool value);

    int getTimerAmazfishButtonResetPresses() const;
    void setTimerAmazfishButtonResetPresses(int value);

    //privileged commands start
    bool getTimerLockScreenEnabled() const;
    void setTimerLockScreenEnabled(bool value);

    bool getTimerStopAlienEnabled() const;
    void setTimerStopAlienEnabled(bool value);

    bool getTimerAirplaneModeEnabled() const;
    void setTimerAirplaneModeEnabled(bool value);

    bool getTimerDisableWLANEnabled() const;
    void setTimerDisableWLANEnabled(bool value);

    bool getTimerDisableBluetoothEnabled() const;
    void setTimerDisableBluetoothEnabled(bool value);

    bool getTimerRestartOfonoEnabled() const;
    void setTimerRestartOfonoEnabled(bool value);

    //privileged commands end
    bool getTimerKodiPauseEnabled() const;
    void setTimerKodiPauseEnabled(bool value);

    QString getTimerKodiPauseHost() const;
    void setTimerKodiPauseHost(QString value);

    QString getTimerKodiPauseUser() const;
    void setTimerKodiPauseUser(QString value);

    QString getTimerKodiPausePassword() const;
    void setTimerKodiPausePassword(QString value);

    QString getTimerKodiSecondaryCommand() const;
    void setTimerKodiSecondaryCommand(QString value);

    bool getTimerVLCPauseEnabled() const;
    void setTimerVLCPauseEnabled(bool value);

    QString getTimerVLCPauseHost() const;
    void setTimerVLCPauseHost(QString value);

    QString getTimerVLCPauseUser() const;
    void setTimerVLCPauseUser(QString value);

    QString getTimerVLCPausePassword() const;
    void setTimerVLCPausePassword(QString value);

    bool getTimerBTDisconnectEnabled() const;
    void setTimerBTDisconnectEnabled(bool value);

    bool getTimerBTDisconnectOnlyAudioEnabled() const;
    void setTimerBTDisconnectOnlyAudioEnabled(bool value);

    bool getTimerNotificationTriggerEnabled() const;
    void setTimerNotificationTriggerEnabled(bool value);

    bool getTimerFadeEnabled() const;
    void setTimerFadeEnabled(bool value);

    bool getTimerFadeResetEnabled() const;
    void setTimerFadeResetEnabled(bool value);

    bool getTimerFadeSoundEffectEnabled() const;
    void setTimerFadeSoundEffectEnabled(bool value);

    QString getTimerFadeSoundEffectFile() const;
    void setTimerFadeSoundEffectFile(QString value);

    bool getTimerFadeVisualEffectEnabled() const;
    void setTimerFadeVisualEffectEnabled(bool value);

    float getTimerFadeSoundEffectVolume() const;
    void setTimerFadeSoundEffectVolume(float value);

    bool getTimerAutostartOnPlaybackDetection() const;
    void setTimerAutostartOnPlaybackDetection(bool value);

    bool getTimerAutostopOnPlaybackStop() const;
    void setTimerAutostopOnPlaybackStop(bool value);

    float getViewDarkenMainScreenAmount() const;
    void setViewDarkenMainScreenAmount(float value);

    bool getViewDarkenMainSceen() const;
    void setViewDarkenMainSceen(bool value);

    bool getViewTimeFormatShort() const;
    void setViewTimeFormatShort(bool value);

    bool getViewActiveIndicatorEnabled() const;
    void setViewActiveIndicatorEnabled(bool value);

    bool getViewActiveOptionsButtonEnabled() const;
    void setViewActiveOptionsButtonEnabled(bool value);

signals:
    void legacySettingsPossiblyAvailableChanged();
    void timerInhibitScreensaverEnabledChanged();
    void timerSecondsChanged();
    void timerFinalizingSecondsChanged();
    void timerSoundOnResetEnabledChanged();
    void timerMotionEnabledChanged();
    void timerWaveMotionEnabledChanged();
    void timerMotionThresholdChanged();
    void timerPauseEnabledChanged();
    void timerAmazfishButtonResetEnabledChanged();
    void timerAmazfishMusicResetEnabledChanged();
    void timerAmazfishButtonResetPressesChanged();
    void timerLockScreenEnabledChanged();
    void timerStopAlienEnabledChanged();
    void timerAirplaneModeEnabledChanged();
    void timerDisableWLANEnabledChanged();
    void timerDisableBluetoothEnabledChanged();
    void timerRestartOfonoEnabledChanged();
    void timerKodiPauseEnabledChanged();
    void timerKodiPauseHostChanged();
    void timerKodiPauseUserChanged();
    void timerKodiPausePasswordChanged();
    void timerKodiSecondaryCommandChanged();
    void timerVLCPauseEnabledChanged();
    void timerVLCPauseHostChanged();
    void timerVLCPauseUserChanged();
    void timerVLCPausePasswordChanged();
    void timerBTDisconnectEnabledChanged();
    void timerBTDisconnectOnlyAudioEnabledChanged();
    void timerNotificationTriggerEnabledChanged();
    void timerFadeEnabledChanged();
    void timerFadeResetEnabledChanged();
    void timerFadeSoundEffectEnabledChanged();
    void timerFadeSoundEffectFileChanged();
    void timerFadeVisualEffectEnabledChanged();
    void timerFadeSoundEffectVolumeChanged();
    void timerAutostartOnPlaybackDetectionChanged();
    void timerAutostopOnPlaybackStopChanged();
    void viewDarkenMainScreenAmountChanged();
    void viewDarkenMainSceenChanged();
    void viewTimeFormatShortChanged();
    void viewActiveIndicatorEnabledChanged();
    void viewActiveOptionsButtonEnabledChanged();

private:
    QSettings settings;
};

#endif // APPLICATIONSETTINGS_H
