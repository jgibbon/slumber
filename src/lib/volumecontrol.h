#ifndef VOLUMECONTROL_H
#define VOLUMECONTROL_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusConnectionInterface>

class VolumeControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int volume READ getVolume WRITE setVolume NOTIFY volumeChanged)
public:
    explicit VolumeControl(QObject *parent = 0);
    int init();
    void setVolume(const uint newVolume);
    uint getVolume();

signals:
    void volumeChanged();

public slots:
//    void changeVolume(bool increase);

private:
    QDBusConnection *pulseAudioBus;
    uint maxVolume;

};

#endif // VOLUMECONTROL_H
