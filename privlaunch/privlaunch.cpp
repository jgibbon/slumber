#include <QCoreApplication>
#include <QProcess>
#include <QCommandLineParser>
#include <QDebug>
#include <QTextStream>
#include <QRegExp>


#include <unistd.h> // getppid…


int main(int argc, char *argv[])
{

    QCoreApplication::setSetuidAllowed(true);
    QCoreApplication app(argc, argv);
    QCoreApplication::setApplicationName("slumber-privileged");
    QCoreApplication::setApplicationVersion("1.0");
    QCommandLineParser parser;
    QTextStream out(stdout);
    setuid(geteuid());

    parser.setApplicationDescription("slumber helper");
    parser.addHelpOption();
    parser.addVersionOption();

    parser.addPositionalArgument("program", "program to run");

    // Process the actual command line arguments given by the user
    parser.process(app);
    QStringList args = parser.positionalArguments();

    // get parent process:
    QProcess *proc = new QProcess();


    int parentId = getppid();
    // parent check 1: from command line/sdk deployment
    proc->start(QString("readlink -f /proc/%1/exe").arg(parentId));
    proc->waitForFinished();
    QString parentName = QString::fromLocal8Bit(proc->readAll());
    bool parentIsValid = parentName == "/usr/bin/harbour-slumber\n"; // || parentName.contains("booster-silica-qt5");
    out << "Authentication \n" << parentName << "\n";

    if(!parentIsValid) {
        proc->start(QString("pstree -p %1").arg(parentId));
        proc->waitForFinished();
        parentName = QString::fromLocal8Bit(proc->readAll());
        QRegExp rx("harbour-slumber\\((\\d+)\\)");
        parentIsValid = rx.indexIn(parentName) != -1;

        out << "Authentication2 \n" << parentName << "\n";
    }
    if(parentIsValid) {
        if(args.length() > 0) {
            QString program = parser.positionalArguments().at(0);
//            out << program << "\n" << geteuid() << "\n";
            proc->start(program);
            proc->waitForFinished(-1);
            QByteArray bytes = proc->readAllStandardOutput();
            QByteArray errbytes = proc->readAllStandardError();
            QString output = QString::fromLocal8Bit(bytes);
            QString erroutput = QString::fromLocal8Bit(errbytes);
            out << output;
            out << erroutput;

        } else {
            out << "no program specified!\n";
        }
    } else {
        out << "Authentication error.\n";
    }
}
