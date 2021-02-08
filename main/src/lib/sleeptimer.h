#ifndef SLEEPTIMER_H
#define SLEEPTIMER_H

#include <QObject>
#include <QTimer>
#include "applicationsettings.h"

class SleepTimer : public QTimer
{
    Q_OBJECT
//    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(int finalizeSeconds READ getFinalizeSeconds WRITE setFinalizeSeconds NOTIFY finalizeMillisecondsChanged)
    Q_PROPERTY(bool running READ isActive NOTIFY isActiveChanged)
    Q_PROPERTY(bool finalizing READ getFinalizing NOTIFY finalizingChanged)
//    Q_PROPERTY(int remainingTime READ getRemainingTime NOTIFY remainingTimeChanged)
    Q_PROPERTY(int remainingSeconds READ getRemainingSeconds NOTIFY remainingSecondsChanged)

public:
    explicit SleepTimer(QObject *parent = nullptr, ApplicationSettings *appsettings = nullptr);
    ~SleepTimer();

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

    bool getFinalizing();
    int getFinalizeSeconds() const;
    int getRemainingSeconds() const;
    void setFinalizeSeconds(int value);
    void setDurationSeconds(int value);

signals:
//    void remainingTimeChanged();
    void remainingSecondsChanged();
    void durationSecondsChanged();
    void finalizingChanged();
    void finalizeMillisecondsChanged();
    void isActiveChanged();
    void triggered();
    //void reset(); we use activeChanged.

private slots:
//    void onTickTimeout();
    void onTimeout();
    void setDurationFromSettings();
    void setFinalizingDurationFromSettings();
private:
    void resetRemainingSeconds();

private:
    ApplicationSettings *settings;
//    QTimer *tickTimer;
    bool finalizing;
//    int remainingTime;
    int remainingSeconds;
    int finalizeSeconds;
    int durationSeconds;
//    int remainingMilliseconds;
};

#endif // SLEEPTIMER_H
