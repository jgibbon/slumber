#include <stdio.h>
#include "volumecontrol.h"

VolumeControl::VolumeControl(QObject *parent) :
    QObject(parent)
{
    pulseAudioBus = NULL;
}

int VolumeControl::init()
{
    if (pulseAudioBus != NULL)
    {
        printf("slumber volume: volumecontrol is already initialised\n");
        return EXIT_FAILURE;
    }

    QDBusConnection bus = QDBusConnection::sessionBus();

    QDBusMessage call = QDBusMessage::createMethodCall("org.PulseAudio1", "/org/pulseaudio/server_lookup1", "org.freedesktop.DBus.Properties", "Get" );
    call << "org.PulseAudio.ServerLookup1" << "Address";
    QDBusReply<QDBusVariant> lookupReply = bus.call(call);

    if (lookupReply.isValid())
    {
        pulseAudioBus = new QDBusConnection(QDBusConnection::connectToPeer(lookupReply.value().variant().toString(), "org.PulseAudio1"));
    }
    else
    {
        printf("slumber volume: Can not find pulseaudio from dbus\n");
        return EXIT_FAILURE;
    }

    call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2", "org.freedesktop.DBus.Properties", "Get");
    call << "com.Meego.MainVolume2" << "StepCount";
    QDBusReply<QDBusVariant> volumeMaxReply = pulseAudioBus->call(call);

    if (volumeMaxReply.isValid())
    {
        maxVolume = volumeMaxReply.value().variant().toUInt();
    }
    else
    {
        printf("slumber volume: Could not read volume max, cannot adjust volume: %s\n", qPrintable(volumeMaxReply.error().message()));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

uint VolumeControl::getVolume()
{

    printf("getVolume\n");
    uint volume = 0;
    if (pulseAudioBus == NULL)
    {
        printf("slumber volume: volumecontrol not properly initialised\n");
        return volume;
    }

    QDBusMessage call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2", "org.freedesktop.DBus.Properties", "Get");
    call << "com.Meego.MainVolume2" << "CurrentStep";
    QDBusReply<QDBusVariant> volumeReply = pulseAudioBus->call(call);

    if (volumeReply.isValid())
    {
        uint volume = volumeReply.value().variant().toUInt();
        return volume;
    }
    return volume;
}

void VolumeControl::setVolume(const uint newVolume)
{
    if (pulseAudioBus == NULL)
    {
        printf("slumber volume: volumecontrol not properly initialised\n");
        return;
    }

    printf("slumber volume: Setting volume to %d\n", newVolume);

    QDBusMessage call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2", "org.freedesktop.DBus.Properties", "Set");
    call << "com.Meego.MainVolume2" << "CurrentStep" << QVariant::fromValue(QDBusVariant(newVolume));

    QDBusError err = pulseAudioBus->call(call);

    if (err.isValid())
    {
        printf("buttonjackd: Volume change throw error %s\n", qPrintable(err.message()));
    }

}
