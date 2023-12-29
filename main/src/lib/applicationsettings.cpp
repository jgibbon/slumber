#include "applicationsettings.h"

ApplicationSettings::ApplicationSettings(QObject *parent) : QObject(parent), settings("harbour-slumber", "settings")
{

}

bool ApplicationSettings::getLegacySettingsPossiblyAvailable() const
{
    return settings.value("legacySettingsPossiblyAvailable", true).toBool();
}

void ApplicationSettings::setLegacySettingsPossiblyAvailable(bool value)
{
  if(getLegacySettingsPossiblyAvailable() != value) {
    settings.setValue("legacySettingsPossiblyAvailable", value);
    emit legacySettingsPossiblyAvailableChanged();
  }
}

//timer
bool ApplicationSettings::getTimerInhibitScreensaverEnabled() const
{
  return settings.value("timerInhibitScreensaverEnabled", false).toBool();
}
void ApplicationSettings::setTimerInhibitScreensaverEnabled(bool value)
{
  if(getTimerInhibitScreensaverEnabled() != value) {
    settings.setValue("timerInhibitScreensaverEnabled", value);
    emit timerInhibitScreensaverEnabledChanged();
  }
}

int ApplicationSettings::getTimerSeconds() const
{
  return settings.value("timerSeconds", 900).toInt();
}
void ApplicationSettings::setTimerSeconds(int value)
{
  if(getTimerSeconds() != value && value > getTimerFinalizingSeconds()) {
    settings.setValue("timerSeconds", value);
    emit timerSecondsChanged();
  }
}

int ApplicationSettings::getTimerFinalizingSeconds() const
{
    return settings.value("timerFinalizingSeconds", 10).toInt();
}

void ApplicationSettings::setTimerFinalizingSeconds(int value)
{
  if(getTimerFinalizingSeconds() != value && value < getTimerSeconds()) {
    settings.setValue("timerFinalizingSeconds", value);
    emit timerFinalizingSecondsChanged();
  }
}

bool ApplicationSettings::getTimerSoundOnResetEnabled() const
{
    return settings.value("timerSoundOnResetEnabled", false).toBool();
}

void ApplicationSettings::setTimerSoundOnResetEnabled(bool value)
{
    if(getTimerSoundOnResetEnabled() != value) {
      settings.setValue("timerSoundOnResetEnabled", value);
      emit timerSoundOnResetEnabledChanged();
    }
}

bool ApplicationSettings::getTimerMotionEnabled() const
{
  return settings.value("timerMotionEnabled", false).toBool();
}
void ApplicationSettings::setTimerMotionEnabled(bool value)
{
  if(getTimerMotionEnabled() != value) {
    settings.setValue("timerMotionEnabled", value);
    emit timerMotionEnabledChanged();
  }
}

bool ApplicationSettings::getTimerWaveMotionEnabled() const
{
  return settings.value("timerWaveMotionEnabled", false).toBool();
}
void ApplicationSettings::setTimerWaveMotionEnabled(bool value)
{
  if(getTimerWaveMotionEnabled() != value) {
    settings.setValue("timerWaveMotionEnabled", value);
    emit timerWaveMotionEnabledChanged();
  }
}

float ApplicationSettings::getTimerMotionThreshold() const
{
  return settings.value("timerMotionThreshold", 0).toFloat();
}
void ApplicationSettings::setTimerMotionThreshold(float value)
{
  if(getTimerMotionThreshold() != value) {
    settings.setValue("timerMotionThreshold", value);
    emit timerMotionThresholdChanged();
  }
}

bool ApplicationSettings::getTimerPauseEnabled() const
{
  return settings.value("timerPauseEnabled", true).toBool();
}
void ApplicationSettings::setTimerPauseEnabled(bool value)
{
  if(getTimerPauseEnabled() != value) {
    settings.setValue("timerPauseEnabled", value);
    emit timerPauseEnabledChanged();
  }
}

bool ApplicationSettings::getTimerAmazfishButtonResetEnabled() const
{
  return settings.value("timerAmazfishButtonResetEnabled", false).toBool();
}
void ApplicationSettings::setTimerAmazfishButtonResetEnabled(bool value)
{
  if(getTimerAmazfishButtonResetEnabled() != value) {
    settings.setValue("timerAmazfishButtonResetEnabled", value);
    emit timerAmazfishButtonResetEnabledChanged();
  }
}

bool ApplicationSettings::getTimerAmazfishMusicResetEnabled() const
{
    return settings.value("timerAmazfishMusicResetEnabled", false).toBool();
}

void ApplicationSettings::setTimerAmazfishMusicResetEnabled(bool value)
{

    if(getTimerAmazfishMusicResetEnabled() != value) {
      settings.setValue("timerAmazfishMusicResetEnabled", value);
      emit timerAmazfishMusicResetEnabledChanged();
    }
}

int ApplicationSettings::getTimerAmazfishButtonResetPresses() const
{
  return settings.value("timerAmazfishButtonResetPresses", 1).toInt();
}
void ApplicationSettings::setTimerAmazfishButtonResetPresses(int value)
{
  if(getTimerAmazfishButtonResetPresses() != value) {
    settings.setValue("timerAmazfishButtonResetPresses", value);
    emit timerAmazfishButtonResetPressesChanged();
  }
}

//privileged commands start
bool ApplicationSettings::getTimerLockScreenEnabled() const
{
  return settings.value("timerLockScreenEnabled", false).toBool();
}
void ApplicationSettings::setTimerLockScreenEnabled(bool value)
{
  if(getTimerLockScreenEnabled() != value) {
    settings.setValue("timerLockScreenEnabled", value);
    emit timerLockScreenEnabledChanged();
  }
}

bool ApplicationSettings::getTimerStopAlienEnabled() const
{
  return settings.value("timerStopAlienEnabled", false).toBool();
}
void ApplicationSettings::setTimerStopAlienEnabled(bool value)
{
  if(getTimerStopAlienEnabled() != value) {
    settings.setValue("timerStopAlienEnabled", value);
    emit timerStopAlienEnabledChanged();
  }
}

bool ApplicationSettings::getTimerAirplaneModeEnabled() const
{
  return settings.value("timerAirplaneModeEnabled", false).toBool();
}
void ApplicationSettings::setTimerAirplaneModeEnabled(bool value)
{
  if(getTimerAirplaneModeEnabled() != value) {
    settings.setValue("timerAirplaneModeEnabled", value);
    emit timerAirplaneModeEnabledChanged();
  }
}

bool ApplicationSettings::getTimerDisableWLANEnabled() const
{
  return settings.value("timerDisableWLANEnabled", false).toBool();
}
void ApplicationSettings::setTimerDisableWLANEnabled(bool value)
{
  if(getTimerDisableWLANEnabled() != value) {
    settings.setValue("timerDisableWLANEnabled", value);
    emit timerDisableWLANEnabledChanged();
  }
}

bool ApplicationSettings::getTimerDisableBluetoothEnabled() const
{
  return settings.value("timerDisableBluetoothEnabled", false).toBool();
}
void ApplicationSettings::setTimerDisableBluetoothEnabled(bool value)
{
  if(getTimerDisableBluetoothEnabled() != value) {
    settings.setValue("timerDisableBluetoothEnabled", value);
    emit timerDisableBluetoothEnabledChanged();
  }
}

bool ApplicationSettings::getTimerRestartOfonoEnabled() const
{
  return settings.value("timerRestartOfonoEnabled", false).toBool();
}
void ApplicationSettings::setTimerRestartOfonoEnabled(bool value)
{
  if(getTimerRestartOfonoEnabled() != value) {
    settings.setValue("timerRestartOfonoEnabled", value);
    emit timerRestartOfonoEnabledChanged();
  }
}

//privileged commands end
bool ApplicationSettings::getTimerKodiPauseEnabled() const
{
  return settings.value("timerKodiPauseEnabled", false).toBool();
}
void ApplicationSettings::setTimerKodiPauseEnabled(bool value)
{
  if(getTimerKodiPauseEnabled() != value) {
    settings.setValue("timerKodiPauseEnabled", value);
    emit timerKodiPauseEnabledChanged();
  }
}

QString ApplicationSettings::getTimerKodiPauseHost() const
{
  return settings.value("timerKodiPauseHost", "").toString();
}
void ApplicationSettings::setTimerKodiPauseHost(QString value)
{
  if(getTimerKodiPauseHost() != value) {
    settings.setValue("timerKodiPauseHost", value);
    emit timerKodiPauseHostChanged();
  }
}

QString ApplicationSettings::getTimerKodiPauseUser() const
{
  return settings.value("timerKodiPauseUser", "").toString();
}
void ApplicationSettings::setTimerKodiPauseUser(QString value)
{
  if(getTimerKodiPauseUser() != value) {
    settings.setValue("timerKodiPauseUser", value);
    emit timerKodiPauseUserChanged();
  }
}

QString ApplicationSettings::getTimerKodiPausePassword() const
{
  return settings.value("timerKodiPausePassword", "").toString();
}
void ApplicationSettings::setTimerKodiPausePassword(QString value)
{
  if(getTimerKodiPausePassword() != value) {
    settings.setValue("timerKodiPausePassword", value);
    emit timerKodiPausePasswordChanged();
  }
}

QString ApplicationSettings::getTimerKodiSecondaryCommand() const
{
  return settings.value("timerKodiSecondaryCommand", "").toString(); // System.Shutdown, System.Suspend
}
void ApplicationSettings::setTimerKodiSecondaryCommand(QString value)
{
  if(getTimerKodiSecondaryCommand() != value) {
    settings.setValue("timerKodiSecondaryCommand", value);
    emit timerKodiSecondaryCommandChanged();
  }
}

bool ApplicationSettings::getTimerVLCPauseEnabled() const
{
  return settings.value("timerVLCPauseEnabled", false).toBool();
}
void ApplicationSettings::setTimerVLCPauseEnabled(bool value)
{
  if(getTimerVLCPauseEnabled() != value) {
    settings.setValue("timerVLCPauseEnabled", value);
    emit timerVLCPauseEnabledChanged();
  }
}

QString ApplicationSettings::getTimerVLCPauseHost() const
{
  return settings.value("timerVLCPauseHost", "").toString();
}
void ApplicationSettings::setTimerVLCPauseHost(QString value)
{
  if(getTimerVLCPauseHost() != value) {
    settings.setValue("timerVLCPauseHost", value);
    emit timerVLCPauseHostChanged();
  }
}

QString ApplicationSettings::getTimerVLCPauseUser() const
{
  return settings.value("timerVLCPauseUser", "").toString();
}
void ApplicationSettings::setTimerVLCPauseUser(QString value)
{
  if(getTimerVLCPauseUser() != value) {
    settings.setValue("timerVLCPauseUser", value);
    emit timerVLCPauseUserChanged();
  }
}

QString ApplicationSettings::getTimerVLCPausePassword() const
{
  return settings.value("timerVLCPausePassword", "").toString();
}
void ApplicationSettings::setTimerVLCPausePassword(QString value)
{
  if(getTimerVLCPausePassword() != value) {
    settings.setValue("timerVLCPausePassword", value);
    emit timerVLCPausePasswordChanged();
  }
}

bool ApplicationSettings::getTimerBTDisconnectEnabled() const
{
  return settings.value("timerBTDisconnectEnabled", false).toBool();
}
void ApplicationSettings::setTimerBTDisconnectEnabled(bool value)
{
  if(getTimerBTDisconnectEnabled() != value) {
    settings.setValue("timerBTDisconnectEnabled", value);
    emit timerBTDisconnectEnabledChanged();
  }
}

bool ApplicationSettings::getTimerBTDisconnectOnlyAudioEnabled() const
{
  return settings.value("timerBTDisconnectOnlyAudioEnabled", false).toBool();
}
void ApplicationSettings::setTimerBTDisconnectOnlyAudioEnabled(bool value)
{
  if(getTimerBTDisconnectOnlyAudioEnabled() != value) {
    settings.setValue("timerBTDisconnectOnlyAudioEnabled", value);
    emit timerBTDisconnectOnlyAudioEnabledChanged();
  }
}

bool ApplicationSettings::getTimerNotificationTriggerEnabled() const
{
  return settings.value("timerNotificationTriggerEnabled", false).toBool();
}
void ApplicationSettings::setTimerNotificationTriggerEnabled(bool value)
{
  if(getTimerNotificationTriggerEnabled() != value) {
    settings.setValue("timerNotificationTriggerEnabled", value);
    emit timerNotificationTriggerEnabledChanged();
  }
}

bool ApplicationSettings::getTimerFadeEnabled() const
{
  return settings.value("timerFadeEnabled", true).toBool();
}
void ApplicationSettings::setTimerFadeEnabled(bool value)
{
  if(getTimerFadeEnabled() != value) {
    settings.setValue("timerFadeEnabled", value);
    emit timerFadeEnabledChanged();
  }
}

bool ApplicationSettings::getTimerFadeResetEnabled() const
{
  return settings.value("timerFadeResetEnabled", true).toBool();
}
void ApplicationSettings::setTimerFadeResetEnabled(bool value)
{
  if(getTimerFadeResetEnabled() != value) {
    settings.setValue("timerFadeResetEnabled", value);
    emit timerFadeResetEnabledChanged();
  }
}

bool ApplicationSettings::getTimerFadeSoundEffectEnabled() const
{
  return settings.value("timerFadeSoundEffectEnabled", true).toBool();
}
void ApplicationSettings::setTimerFadeSoundEffectEnabled(bool value)
{
  if(getTimerFadeSoundEffectEnabled() != value) {
    settings.setValue("timerFadeSoundEffectEnabled", value);
    emit timerFadeSoundEffectEnabledChanged();
  }
}

QString ApplicationSettings::getTimerFadeSoundEffectFile() const
{
  return settings.value("timerFadeSoundEffectFile", "cassette-noise").toString();
}
void ApplicationSettings::setTimerFadeSoundEffectFile(QString value)
{
  if(getTimerFadeSoundEffectFile() != value) {
    settings.setValue("timerFadeSoundEffectFile", value);
    emit timerFadeSoundEffectFileChanged();
  }
}

bool ApplicationSettings::getTimerFadeVisualEffectEnabled() const
{
  return settings.value("timerFadeVisualEffectEnabled", false).toBool();
}
void ApplicationSettings::setTimerFadeVisualEffectEnabled(bool value)
{
  if(getTimerFadeVisualEffectEnabled() != value) {
    settings.setValue("timerFadeVisualEffectEnabled", value);
    emit timerFadeVisualEffectEnabledChanged();
  }
}

float ApplicationSettings::getTimerFadeSoundEffectVolume() const
{
  return settings.value("timerFadeSoundEffectVolume", 0.5).toFloat();
}
void ApplicationSettings::setTimerFadeSoundEffectVolume(float value)
{
  if(getTimerFadeSoundEffectVolume() != value) {
    settings.setValue("timerFadeSoundEffectVolume", value);
    emit timerFadeSoundEffectVolumeChanged();
  }
}

bool ApplicationSettings::getTimerAutostartOnPlaybackDetection() const
{
  return settings.value("timerAutostartOnPlaybackDetection", true).toBool();
}
void ApplicationSettings::setTimerAutostartOnPlaybackDetection(bool value)
{
  if(getTimerAutostartOnPlaybackDetection() != value) {
    settings.setValue("timerAutostartOnPlaybackDetection", value);
    emit timerAutostartOnPlaybackDetectionChanged();
  }
}

bool ApplicationSettings::getTimerAutostopOnPlaybackStop() const
{
  return settings.value("timerAutostopOnPlaybackStop", true).toBool();
}
void ApplicationSettings::setTimerAutostopOnPlaybackStop(bool value)
{
  if(getTimerAutostopOnPlaybackStop() != value) {
    settings.setValue("timerAutostopOnPlaybackStop", value);
    emit timerAutostopOnPlaybackStopChanged();
  }
}

float ApplicationSettings::getViewDarkenMainScreenAmount() const
{
  return settings.value("viewDarkenMainScreenAmount", 0.7).toFloat();
}
void ApplicationSettings::setViewDarkenMainScreenAmount(float value)
{
  if(getViewDarkenMainScreenAmount() != value) {
    settings.setValue("viewDarkenMainScreenAmount", value);
    emit viewDarkenMainScreenAmountChanged();
  }
}

bool ApplicationSettings::getViewDarkenMainSceen() const
{
  return settings.value("viewDarkenMainSceen", false).toBool();
}
void ApplicationSettings::setViewDarkenMainSceen(bool value)
{
  if(getViewDarkenMainSceen() != value) {
    settings.setValue("viewDarkenMainSceen", value);
    emit viewDarkenMainSceenChanged();
  }
}

bool ApplicationSettings::getViewTimeFormatShort() const
{
  return settings.value("viewTimeFormatShort", false).toBool();
}
void ApplicationSettings::setViewTimeFormatShort(bool value)
{
  if(getViewTimeFormatShort() != value) {
    settings.setValue("viewTimeFormatShort", value);
    emit viewTimeFormatShortChanged();
  }
}

bool ApplicationSettings::getViewActiveIndicatorEnabled() const
{
  return settings.value("viewActiveIndicatorEnabled", true).toBool();
}
void ApplicationSettings::setViewActiveIndicatorEnabled(bool value)
{
  if(getViewActiveIndicatorEnabled() != value) {
    settings.setValue("viewActiveIndicatorEnabled", value);
    emit viewActiveIndicatorEnabledChanged();
  }
}

bool ApplicationSettings::getViewActiveOptionsButtonEnabled() const
{
  return settings.value("viewActiveOptionsButtonEnabled", false).toBool();
}
void ApplicationSettings::setViewActiveOptionsButtonEnabled(bool value)
{
  if(getViewActiveOptionsButtonEnabled() != value) {
    settings.setValue("viewActiveOptionsButtonEnabled", value);
    emit viewActiveOptionsButtonEnabledChanged();
  }
}
