TEMPLATE = app

# The name of your application
TARGET = harbour-slumber

CONFIG += sailfishapp

SOURCES += src/slumber.cpp \
    src/lib/volumecontrol.cpp \
    src/lib/launcher.cpp
QT += dbus

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
#    qml/pages/SecondPage.qml \
    ../rpm/harbour-slumber.changes \
    ../rpm/harbour-slumber.yaml \
    ../rpm/harbour-slumber.spec \
    translations/*.ts \
    qml/lib/AccelerometerTrigger.qml \
    qml/lib/CountDownTimer.qml \
#    qml/lib/ImageLabelButton.qml \
    qml/lib/InlineNotification.qml \
#    qml/lib/Options.qml \
    qml/lib/PersistentObject.qml \
    qml/pages/Options.qml \
    qml/pages/About.qml \
    qml/lib/TimerProgressButton.qml \
    qml/lib/PersistentObjectStore.js \
    qml/lib/Globals.qml \
    qml/assets/sound/cassette-noise.wav \
    qml/assets/sound/clock-ticking.wav \
    qml/assets/sound/sea-waves.wav \
    qml/assets/sound/void.mp3 \
    qml/assets/sound/LICENSE.txt \
    harbour-slumber.desktop \
    qml/harbour-slumber.qml \
    qml/pages/Options_TimerReset.qml \
    qml/pages/Options_TimerEnd.qml \
    qml/pages/Options_Appearance.qml \
    qml/assets/moon.png \
    qml/lib/ActionNetworkKodi.qml \
    qml/lib/ActionNetwork.qml \
    qml/lib/ActionNetworkVLC.qml \
    qml/lib/ActionLockScreen.qml \
    qml/lib/ScreenBlank.qml \
    appicons/86x86/apps/harbour-slumber.png \
    appicons/108x108/apps/harbour-slumber.png \
    appicons/128x128/apps/harbour-slumber.png \
    appicons/256x256/apps/harbour-slumber.png \
    translations/*
#    qml/lib/VolumeFade.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/harbour-slumber-*.ts


appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*

#slumber.desktop.path = /usr/share/applications/
#slumber.desktop.files = harbour-slumber.desktop

INSTALLS += appicons #slumber.desktop


DISTFILES += \
    qml/lib/ImageLabelButton.qml \
    qml/lib/Options.qml \
    qml/lib/VolumeFade.qml \
    qml/lib/TimerNotificationTrigger.qml \
    qml/lib/ActionDBusPauseMediaplayers.qml \
    qml/lib/ActionLaunchProgram.qml \
    qml/lib/MprisPlayingScanner.qml \
    qml/pages/Options_TimerEnd_Privileged.qml \
    qml/lib/ActionPrivilegedLauncher.qml

HEADERS += \
    src/lib/volumecontrol.h \
    src/lib/launcher.h

RESOURCES += \
    privileged.qrc



