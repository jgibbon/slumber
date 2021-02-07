TEMPLATE = subdirs


privileged_launcher.file = privlaunch/launch.pro
privileged_launcher.target = privileged-launcher


app_src.file = main/slumber.pro
app_src.depends = privileged-launcher



SUBDIRS += \
    app_src \
    privileged_launcher

DISTFILES += \
    main/qml/lib/ProgressShader.qml \
    main/qml/lib/actuators/DisconnectBT.qml \
    main/qml/lib/actuators/MprisPause.qml \
    main/qml/lib/actuators/NetworkBase.qml \
    main/qml/lib/actuators/NetworkKodi.qml \
    main/qml/lib/actuators/NetworkVLC.qml \
    main/qml/lib/actuators/PrivilegedLauncher.qml \
    main/qml/lib/actuators/VoidPlayPause.qml
