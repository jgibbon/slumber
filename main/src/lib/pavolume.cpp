#include "pavolume.h"

PAVolume::PAVolume() :
    type(0),
    volume(1)
{
}

PAVolume::PAVolume(uint type, uint volume) :
    type(type), volume(volume)
{
}

PAVolume::~PAVolume()
{
}

void PAVolume::registerMetaTypes()
{
    qRegisterMetaType<PAVolume>("PAVolume");
    qDBusRegisterMetaType<PAVolume>();
    qRegisterMetaType<PAVolumeArray>("PAVolumeArray");
    qDBusRegisterMetaType<PAVolumeArray>();
}

QDBusArgument &operator<<(QDBusArgument &dbusarg, const PAVolume &volume)
{
    dbusarg.beginStructure();
    dbusarg << volume.type;
    dbusarg << volume.volume;
    dbusarg.endStructure();
    return dbusarg;
}

const QDBusArgument &operator>>(const QDBusArgument &dbusarg, PAVolume &volume)
{
    dbusarg.beginStructure();
    dbusarg >> volume.type;
    dbusarg >> volume.volume;
    dbusarg.endStructure();
    return dbusarg;
}

PAVolumeArray::PAVolumeArray()
{
}

PAVolumeArray::~PAVolumeArray()
{
}

PAVolume PAVolumeArray::get(int index) const
{
    if (index < pavolumearr.size()) {
        return pavolumearr[index];
    }
    return PAVolume();
}

void PAVolumeArray::add(PAVolume const &vol)
{
    pavolumearr.push_back(vol);
}

QDBusArgument &operator<<(QDBusArgument &dbusarg, const PAVolumeArray &arr)
{
    dbusarg.beginArray(qMetaTypeId<PAVolume>());
    for (int index = 0; index < arr.pavolumearr.size(); ++index) {
        PAVolume item = arr.get(index);
        dbusarg << item;
    }
    dbusarg.endArray();
    return dbusarg;
}

const QDBusArgument &operator>>(const QDBusArgument &dbusarg, PAVolumeArray &arr)
{
    dbusarg.beginArray();
    while (!dbusarg.atEnd()) {
        PAVolume item;
        dbusarg >> item;
        arr.pavolumearr.push_back(item);
    }
    dbusarg.endArray();
    return dbusarg;
}
