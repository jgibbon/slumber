#include "volumefade.h"

namespace {
    const QString DBUS_SERVICE("org.PulseAudio1");
    const QString DBUS_LOOKUP_PATH("/org/pulseaudio/server_lookup1");
    const QString DBUS_LOOKUP_IFACE("org.PulseAudio.ServerLookup1");
    const QString DBUS_RESTORE_PATH("/org/pulseaudio/stream_restore1");
    const QString DBUS_RESTORE_IFACE("org.PulseAudio.Ext.StreamRestore1");
    const QString DBUS_RESTORE_ENTRY_IFACE("org.PulseAudio.Ext.StreamRestore1.RestoreEntry");
    const QString DBUS_PROPERTIES_IFACE("org.freedesktop.DBus.Properties");
    const QString METHOD_RESTORE_GET_ENTRY_BY_NAME("GetEntryByName");
    const QString METHOD_GET("Get");
    const QString METHOD_SET("Set");
    const QString PROPERTY_ADDRESS("Address");
    const QString PROPERTY_VOLUME("Volume");
    const QString ROLE_NAME("sink-input-by-media-role:x-maemo");
}

VolumeFade::VolumeFade(QObject *parent) : QObject(parent)
{
    QDBusConnection bus = QDBusConnection::sessionBus();

    QDBusMessage call = QDBusMessage::createMethodCall(DBUS_SERVICE, DBUS_LOOKUP_PATH, DBUS_PROPERTIES_IFACE, METHOD_GET);
    call << DBUS_LOOKUP_IFACE << PROPERTY_ADDRESS;
    QDBusReply<QDBusVariant> lookupReply = bus.call(call);
    if (lookupReply.isValid())
    {
        pulseAudioBus = new QDBusConnection(QDBusConnection::connectToPeer(lookupReply.value().variant().toString(), DBUS_SERVICE));
    }
    else
    {
        qWarning() << "slumber volume init: D-Bus error" << lookupReply.error().message();
    }
}

uint VolumeFade::getVolume()
{
    // we assume getVolume() gets called before each fade
    setCurrentStreamPath();
    volumeInterface = new QDBusInterface(DBUS_SERVICE,
                                         currentStreamPath.path(),
                                         DBUS_PROPERTIES_IFACE,
                                         *pulseAudioBus,
                                         this);

    if (volumeInterface->isValid()) {
        QDBusReply<QVariant> reply = volumeInterface->call(
                    METHOD_GET,
                    DBUS_RESTORE_ENTRY_IFACE,
                    PROPERTY_VOLUME);
        if (reply.isValid()) {
            startVolume.clear();
            const QDBusArgument volumeArg = reply.value().value<QDBusArgument>();
            volumeArg.beginArray();
            while(!volumeArg.atEnd()) {
                volumeArg >> startVolume;
            }
            volumeArg.endArray();
            qDebug() << PROPERTY_VOLUME << startVolume;
        }
        else
            qWarning() << "[FAILED] getVolume[message=invalidReply]: " << reply.error();
    }
    else
        qWarning() << "[FAILED] getVolume[message=invalidInterface]: " << pulseAudioBus->lastError();
    return startVolume.value(1);
}

void VolumeFade::setVolume(uint volume)
{
    // qDebug() << "set volume" << volume;
    QVariant var;
    PAVolumeArray t;
    PAVolume vv(0, volume);
    t.add(vv);
    var.setValue(t);
    QDBusVariant dbusVar(var);
    QDBusReply<void> reply = volumeInterface->call(
                METHOD_SET,
                DBUS_RESTORE_ENTRY_IFACE,
                PROPERTY_VOLUME,
                QVariant::fromValue(dbusVar));
    if (!reply.isValid()) {
        qWarning() << "[FAILED] setVolume[message=invalidReply]: " << reply.error();
    }
}

void VolumeFade::setCurrentStreamPath()
{
    QDBusInterface streamRestoreInterface(DBUS_SERVICE,
                                          DBUS_RESTORE_PATH,
                                          DBUS_RESTORE_IFACE,
                                          *pulseAudioBus,
                                          this);
    if (streamRestoreInterface.isValid()) {
        QDBusReply<QDBusObjectPath> reply = streamRestoreInterface.call(
                    METHOD_RESTORE_GET_ENTRY_BY_NAME,
                    ROLE_NAME);
        if (reply.isValid()) {
            currentStreamPath = reply.value();
            // qDebug() << "setting currentStreamPath" << currentStreamPath.path();
        }
        else
            qWarning() << "setCurrentStreamPath invalid reply: " << reply.error();
    }
    else
        qWarning() << "setCurrentStreamPath invalid interface: " << pulseAudioBus->lastError();
}
