#include "launcher.h"
#include <QDebug>

Launcher::Launcher(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    m_dataDirectory = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    m_privilegedLauncherLocation =  m_dataDirectory + "/launchy";
}

QString Launcher::launch(const QString &program)
{
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAll();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}
QString Launcher::launchPrivileged(const QString &program)
{
    if(this->checkPrivilegedLauncher()) {
        QString result = this->launch(m_privilegedLauncherLocation + " \"" + program + "\"");
        return result;
    } else {
        qDebug() << "privileged launch failed";
        return "";
    }
}
bool Launcher::checkPrivilegedLauncher()
{
    QFileInfo privileged(m_privilegedLauncherLocation);
    qDebug().noquote() << "check stat: " << this->launch("stat -c %a \""+m_privilegedLauncherLocation+"\"");
    return privileged.exists() && privileged.owner() == "root" && this->launch("stat -c %a \""+m_privilegedLauncherLocation+"\"") == "6771\n";
}

QString Launcher::runDevelSu(const QString &password, const QStringList &command)
{
    QProcess develSuProcess;
    develSuProcess.start("devel-su", command);

    if( !develSuProcess.waitForStarted() )
    {
        qCritical() << "error starting devel-su";
        return "error";
    }

    develSuProcess.write((password + "\n").toLatin1());
    develSuProcess.waitForFinished();

    if( !(develSuProcess.exitCode() == 0) )
    {
        qDebug() << "Command failed:"
                 << develSuProcess.readAllStandardError();
    }

    QByteArray bytes = develSuProcess.readAll();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}

bool Launcher::checkRootPassword(const QString &rootpw)
{
    QStringList args;
    args << "whoami";
    QString output = this->runDevelSu(rootpw, args);
    qDebug().noquote() << "test out:" << output;
    return output == "root\n";
}
bool Launcher::preparePrivilegedLauncher(const QString &rootpw)
{
    if(this->checkPrivilegedLauncher()) {
        return true;
    }
    if(!this->checkRootPassword(rootpw)) {
        return false;
    }
    QFile binDest(m_privilegedLauncherLocation);
    if(binDest.exists()) {
        QStringList rmCommand;
        rmCommand << "bash" <<  "-c" << "rm " + m_privilegedLauncherLocation;
        qDebug().noquote() << "launcher already exists. removing.";
        qDebug() << this->runDevelSu(rootpw, rmCommand);
    }
    QDir dataDir(m_dataDirectory);
    if(!dataDir.exists()) { //should already exist, but just in case:
        dataDir.mkpath(m_dataDirectory);
    }
    QFile::copy(":/launch" , m_privilegedLauncherLocation);
    QStringList launcherPermissionCommand;
    launcherPermissionCommand << "bash" << "-c" << "chown root " + m_privilegedLauncherLocation + "; chmod 6771 " + m_privilegedLauncherLocation + "";
    this->runDevelSu(rootpw, launcherPermissionCommand);
    return checkPrivilegedLauncher();
}

void Launcher::revokePrivilegedLauncher() {
    qDebug().noquote() << this->launch("rm \"" + m_privilegedLauncherLocation + "\"");
}

Launcher::~Launcher() {

}
