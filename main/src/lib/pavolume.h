#ifndef PAVOLUME_H
#define PAVOLUME_H

#include <QtDBus>

class PAVolume
{
public:
    PAVolume();
    PAVolume(uint type, uint volume);
    ~PAVolume();

    friend QDBusArgument &operator<<(QDBusArgument &dbusarg, PAVolume const & volume);
    friend const QDBusArgument &operator>>(QDBusArgument const & dbusarg, PAVolume &volume);

    static void registerMetaTypes();

private:
    uint type;
    uint volume;
};

class PAVolumeArray
{
public:
    PAVolumeArray();
    ~PAVolumeArray();

    friend QDBusArgument &operator<<(QDBusArgument &dbusarg, PAVolumeArray const & arr);
    friend const QDBusArgument &operator>>(QDBusArgument const & dbusarg, PAVolumeArray &arr);

    int count() const;
    PAVolume get(int index) const;
    void add(PAVolume const &vol);

private:
    QVector<PAVolume> pavolumearr;
};

Q_DECLARE_METATYPE(PAVolume)
Q_DECLARE_METATYPE(PAVolumeArray)

#endif // PAVOLUME_H
