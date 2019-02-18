#CONFIG += sailfishapp
#QT += dbus core quick

#QT -= gui

#TARGET = harbour-slumber-launch
TEMPLATE = app

SOURCES += \
    privlaunch.cpp

#target.path=/usr/share/harbour-slumber/lib
#INSTALLS += target

defineReplace(copyToDir) {
    files = $$1
    DIR = $$2
    LINK =

    for(FILE, files) {
        LINK += $$QMAKE_COPY $$shell_path($$FILE) $$shell_path($$DIR) $$escape_expand(\\n\\t)
    }
    return($$LINK)
}

#defineReplace(copyToBuilddir) {
#    return($$copyToDir($$1, $$OUT_PWD))
#}
defineReplace(copyToMainSrcdir) {
    return($$copyToDir($$1, $$_PRO_FILE_PWD_/../main/))
}

#message("OUT_PWD")
#message($$OUT_PWD)
#message("_PRO_FILE_PWD_")
#message($$_PRO_FILE_PWD_)

QMAKE_POST_LINK += $$copyToMainSrcdir($$OUT_PWD/launch)
