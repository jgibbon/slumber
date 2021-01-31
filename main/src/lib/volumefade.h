#ifndef VOLUMEFADE_H
#define VOLUMEFADE_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>
#include "pavolume.h"

class VolumeFade : public QObject
{
    Q_OBJECT
public:
    explicit VolumeFade(QObject *parent = nullptr);

    Q_INVOKABLE uint getVolume();
    Q_INVOKABLE void setVolume(uint volume);
private:
    void setCurrentStreamPath();
    QDBusConnection *pulseAudioBus;
    QDBusObjectPath currentStreamPath;
    QDBusInterface *volumeInterface;
    QList<uint> startVolume;

};

#endif // VOLUMEFADE_H
