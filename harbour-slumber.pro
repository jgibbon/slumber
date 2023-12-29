TEMPLATE = subdirs


privileged_launcher.file = privlaunch/launch.pro
privileged_launcher.target = privileged-launcher


app_src.file = main/slumber.pro
app_src.depends = privileged-launcher

DISTFILES += rpm/harbour-slumber.changes \
rpm/harbour-slumber.spec \


SUBDIRS += \
    app_src \
    privileged_launcher

