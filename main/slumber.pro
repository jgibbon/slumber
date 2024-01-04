#TEMPLATE = app

# The name of your application
TARGET = harbour-slumber


QT += core qml dbus

CONFIG += sailfishapp sailfishapp_i18n

HEADERS += \
    src/lib/applicationsettings.h \
    src/lib/pavolume.h \
    src/lib/launcher.h \
    src/lib/sleeptimer.h \
    src/lib/volumefade.h

SOURCES += src/slumber.cpp \
    src/lib/applicationsettings.cpp \
    src/lib/pavolume.cpp \
    src/lib/launcher.cpp \
    src/lib/sleeptimer.cpp \
    src/lib/volumefade.cpp

DISTFILES += qml/assets/moon.png \
    qml/assets/sound/cassette-noise.wav \
    qml/assets/sound/clock-ticking.wav \
    qml/assets/sound/LICENSE.txt \
    qml/assets/sound/sea-waves.wav \
    qml/assets/sound/void.mp3 \
    qml/cover/CoverPage.qml \
    qml/harbour-slumber.qml \
    qml/lib/AccelerometerTrigger.qml \
    qml/lib/ActuatorManager.qml \
    qml/lib/actuators/ActuatorBase.qml \
    qml/lib/actuators/DisconnectBT.qml \
    qml/lib/actuators/MprisPause.qml \
    qml/lib/actuators/NetworkBase.qml \
    qml/lib/actuators/NetworkKodi.qml \
    qml/lib/actuators/NetworkVLC.qml \
    qml/lib/actuators/PrivilegedLauncher.qml \
    qml/lib/actuators/Test.qml \
    qml/lib/actuators/VoidPlayPause.qml \
    qml/lib/AmazfitButtonTrigger.qml \
    qml/lib/Globals.qml \
    qml/lib/HighlightImageButton.qml \
    qml/lib/ImageLabelButton.qml \
    qml/lib/InlineNotification.qml \
    qml/lib/LegacyOptions.qml \
    qml/lib/MprisPlayingScanner.qml \
    qml/lib/ScreenBlank.qml \
    qml/lib/SettingsGrid.qml \
    qml/lib/SettingsSectionButton.qml \
    qml/lib/SlumberCircle.qml \
    qml/lib/TimerNotificationTrigger.qml \
    qml/lib/TimerProgressIndicator.qml \
    qml/lib/TimerText.qml \
    qml/lib/VolumeFade.qml \
    qml/pages/About.qml \
    qml/pages/FirstPage.qml \
    qml/pages/Options_Appearance.qml \
    qml/pages/Options_Finalize.qml \
    qml/pages/Options_SoundEffects.qml \
    qml/pages/Options_TimerControl_Amazfish.qml \
    qml/pages/Options_TimerControl.qml \
    qml/pages/Options_TimerEnd_NetworkPlayers.qml \
    qml/pages/Options_TimerEnd_Privileged.qml \
    qml/pages/Options_TimerEnd.qml \
    qml/pages/Options.qml


appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*


slumber.desktop.path = /usr/share/applications/
slumber.desktop.files = harbour-slumber.desktop


INSTALLS += appicons slumber.desktop


RESOURCES += \
    privileged.qrc

TRANSLATIONS += \
    translations/harbour-slumber-de.ts \
    translations/harbour-slumber-en.ts \
    translations/harbour-slumber-es.ts \
    translations/harbour-slumber-fi.ts \
    translations/harbour-slumber-fr.ts \
    translations/harbour-slumber-hu.ts \
    translations/harbour-slumber-it.ts \
    translations/harbour-slumber-nl.ts \
    translations/harbour-slumber-nl_BE.ts \
    translations/harbour-slumber-pl.ts \
    translations/harbour-slumber-ru.ts \
    translations/harbour-slumber-sl_SI.ts \
    translations/harbour-slumber-sv.ts \
    translations/harbour-slumber-zh.ts




