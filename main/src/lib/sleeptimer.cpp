#include "sleeptimer.h"
#include <QDebug>

SleepTimer::SleepTimer(QObject *parent, ApplicationSettings *appsettings) : QTimer(parent),
  settings(appsettings),
  finalizing(false),
  finalizeMilliseconds(10000)
{
    tickTimer = new QTimer(this);
    tickTimer->setInterval(1000);
    connect(tickTimer, SIGNAL(timeout()), this, SLOT(onTickTimeout()));

    setSingleShot(true);
    setTimerType(Qt::PreciseTimer);
    setInterval(settings->getTimerSeconds() * 1000);

    connect(this, SIGNAL(timeout()), this, SLOT(onTimeout()));

    connect(settings, SIGNAL(timerSecondsChanged()), this, SLOT(setIntervalFromSettings()));
}

SleepTimer::~SleepTimer()
{
}

int SleepTimer::getFinalizeMilliseconds() const
{
    return finalizeMilliseconds;
}

int SleepTimer::getRemainingTime() const
{
    return remainingMilliseconds;
}

int SleepTimer::getRemainingSeconds() const
{
    return remainingSeconds;
}

void SleepTimer::setFinalizeMilliseconds(int value)
{
    if(value != finalizeMilliseconds && value < interval()) {
        finalizeMilliseconds = value;
        emit finalizeMillisecondsChanged();
    }
}

void SleepTimer::setInterval(int value)
{

    qDebug() << "setInterval" << value << "previous" << interval();
    qDebug() << " -> new?" << (value != interval()) << "getFinalizeMilliseconds()" << getFinalizeMilliseconds();
    if(value != interval() && value > getFinalizeMilliseconds()) {

        qDebug() << "setInterval valid change. active?" << isActive();
        if(isActive()) {
            stop();
        }
        QTimer::setInterval(value);
        if(value > 1000000) { // is this even necessary?
            setTimerType(Qt::PreciseTimer);
        } else {
            setTimerType(Qt::CoarseTimer);
        }
        updateRemainingTime();

        qDebug() << "setInterval" << interval();
        emit intervalChanged();
    }
}

void SleepTimer::start()
{
    bool wasActive = isActive();
    qDebug() << "start" << "was active?" << wasActive;
    if(wasActive) {
        stop();
    }

    tickTimer->start();
    QTimer::start();
    emit isActiveChanged();

    updateRemainingTime();
}

void SleepTimer::stop()
{
    if(isActive()) {
        QTimer::stop();
        tickTimer->stop();
        emit isActiveChanged();
        updateRemainingTime();
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

// slots
void SleepTimer::onTickTimeout()
{
    if(isActive()) {
        updateRemainingTime();
        qDebug() << "tick timeout" << remainingMilliseconds;
        if(!finalizing && remainingMilliseconds < finalizeMilliseconds) {
            finalizing = true;
            emit finalizingChanged();
        }
    }
}
void SleepTimer::onTimeout()
{
    tickTimer->stop();
    emit isActiveChanged();
    updateRemainingTime();
    if(finalizing) {
        finalizing = false;
        emit finalizingChanged();
    }
}

void SleepTimer::setIntervalFromSettings()
{
    this->setInterval(settings->getTimerSeconds() * 1000);
}

void SleepTimer::updateRemainingTime()
{
    int mseconds = remainingTime();
    if(mseconds <= 0) {
        mseconds = interval();
    }
    if(mseconds != remainingMilliseconds) {
        remainingMilliseconds = mseconds;
        double secondsDouble = mseconds / 1000.0;
        int seconds = qRound(secondsDouble);
        if(seconds != remainingSeconds) {
            remainingSeconds = seconds;
            emit remainingTimeChanged();
            emit remainingSecondsChanged();
        }

    }
}
