# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-slumber

CONFIG += sailfishapp

SOURCES += src/slumber.cpp

appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*
INSTALLS += appicons

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
#    qml/pages/SecondPage.qml \
    rpm/slumber.changes.in \
    rpm/slumber.yaml \
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
    rpm/harbour-slumber.spec \
    qml/harbour-slumber.qml \
    qml/assets/sound/sea-waves.wav \
    qml/pages/Options_TimerReset.qml \
    qml/pages/Options_TimerEnd.qml \
    qml/pages/Options_Appearance.qml \
    qml/assets/moon.png \
    qml/lib/DBusPauseMediaplayers.qml \
    qml/lib/ActionNetworkKodi.qml \
    qml/lib/ActionNetwork.qml \
    qml/lib/ActionNetworkVLC.qml \
    qml/lib/ActionLockScreen.qml \
    qml/lib/ActionDisableBluetooth.qml \
    qml/lib/ScreenBlank.qml \
    appicons/86x86/apps/harbour-slumber.png \
    appicons/108x108/apps/harbour-slumber.png \
    appicons/128x128/apps/harbour-slumber.png \
    appicons/256x256/apps/harbour-slumber.png
#    qml/lib/VolumeFade.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/harbour-slumber-de.ts \
    translations/harbour-slumber-sv.ts


