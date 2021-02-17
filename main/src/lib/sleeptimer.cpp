#include "sleeptimer.h"
#include <QDebug>

SleepTimer::SleepTimer(QObject *parent, ApplicationSettings *appsettings) : QTimer(parent),
  settings(appsettings),
  finalizing(false),
  remainingSeconds(settings->getTimerSeconds()),
  remainingFactor(1.0),
  finalizeSeconds(settings->getTimerFinalizingSeconds())
{

    setTimerType(Qt::PreciseTimer);
    setInterval(1000);
    setDurationFromSettings();

    connect(this, SIGNAL(timeout()), this, SLOT(onTimeout()));

    connect(settings, SIGNAL(timerSecondsChanged()), this, SLOT(setDurationFromSettings()));
    connect(settings, SIGNAL(timerFinalizingSecondsChanged()), this, SLOT(setFinalizingDurationFromSettings()));
}

SleepTimer::~SleepTimer()
{
}

int SleepTimer::getFinalizeSeconds() const
{
    return finalizeSeconds;
}

int SleepTimer::getRemainingSeconds() const
{
    return remainingSeconds;
}

void SleepTimer::setFinalizeSeconds(int value)
{
    if(isActive()) {
        stop();
    }
    if(value != finalizeSeconds && value < interval()) {
        finalizeSeconds = value;
        emit finalizeMillisecondsChanged();
    }
}

void SleepTimer::setDurationSeconds(int value)
{

    qDebug() << "setDurationSeconds" << value << "previous" << durationSeconds;
    qDebug() << " -> new?" << (value != durationSeconds) << "getFinalizeSeconds()" << getFinalizeSeconds();
    if(isActive()) {
        stop();
    }
    if(value != interval() && value > getFinalizeSeconds()) {

        qDebug() << "setDurationSeconds valid change. active?" << isActive();
        if(isActive()) {
            stop();
        }
        durationSeconds = value;
        remainingSeconds = value;

        qDebug() << "setInterval" << interval();

        emit remainingSecondsChanged();
        emit durationSecondsChanged();
    }
}

void SleepTimer::start()
{
    bool wasActive = isActive();
    qDebug() << "start" << "was active?" << wasActive;
    if(wasActive) {
        stop();
    } else {
        resetRemainingSeconds();
    }
    QTimer::start();
    emit isActiveChanged();
}

void SleepTimer::stop()
{
    if(isActive()) {
        QTimer::stop();
        emit isActiveChanged();
        resetRemainingSeconds();
        if(finalizing) {
            finalizing = false;
            emit finalizingChanged();
        }
    }
}

bool SleepTimer::getFinalizing()
{
    return finalizing;
}

void SleepTimer::setDurationFromSettings()
{
    setDurationSeconds(settings->getTimerSeconds());
}
void SleepTimer::setFinalizingDurationFromSettings()
{
    setFinalizeSeconds(settings->getTimerFinalizingSeconds());
}

void SleepTimer::resetRemainingSeconds()
{
    if(remainingSeconds != durationSeconds) {
        remainingSeconds = durationSeconds;
        emit remainingSecondsChanged();
        remainingFactor = 1.0;
        emit remainingFactorChanged();
    }
}

double SleepTimer::getRemainingFactor() const
{
    return remainingFactor;
}

// slots
void SleepTimer::onTimeout()
{
    remainingSeconds -= 1;
    remainingFactor = remainingSeconds / (double)durationSeconds;

    if(remainingSeconds == 0) {
        stop();
        emit triggered();
    } else {
        emit remainingSecondsChanged();
        emit remainingFactorChanged();
        if(!finalizing && remainingSeconds <= finalizeSeconds) {
            finalizing = true;
            emit finalizingChanged();
        }
    }
}
