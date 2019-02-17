#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QProcess>
#include <QByteArray>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileInfo>

class Launcher : public QObject
{
    Q_OBJECT

    QString runDevelSu(const QString &password, const QStringList &command);
public:
    explicit Launcher(QObject *parent = 0);
    ~Launcher();
    Q_INVOKABLE QString launch(const QString &program);
    Q_INVOKABLE bool preparePrivilegedLauncher(const QString &rootpw);
    Q_INVOKABLE bool checkPrivilegedLauncher();
    Q_INVOKABLE QString launchPrivileged(const QString &program);
    Q_INVOKABLE bool checkRootPassword(const QString &rootpw);
    Q_INVOKABLE void revokePrivilegedLauncher();

protected:
    QProcess *m_process;
    QString m_privilegedLauncherLocation;
    QString m_dataDirectory;
};

#endif // LAUNCHER_H
