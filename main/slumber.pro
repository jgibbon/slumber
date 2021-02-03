TEMPLATE = app

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


appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*

INSTALLS += appicons #slumber.desktop


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




