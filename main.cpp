#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include <QFontDatabase>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>
#include <QFileInfo>
#include <QSysInfo>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("Source of Tales");
    app.setOrganizationDomain("sourceoftales.org");
    app.setOrganizationName(QLatin1String("tales"));
    app.setApplicationVersion("0.1");

    QFontDatabase::addApplicationFont("://fonts/DejaVuSerifCondensed.ttf");
    QFontDatabase::addApplicationFont("://fonts/DejaVuSerifCondensed-Italic.ttf");
    QFontDatabase::addApplicationFont("://fonts/DejaVuSerifCondensed-Bold.ttf");
    QFontDatabase::addApplicationFont("://fonts/DejaVuSerifCondensed-BoldItalic.ttf");
    app.setFont(QFont("DejaVu Serif"));

    QQmlApplicationEngine engine;

    QCommandLineParser commandLineParser;

    commandLineParser.setApplicationDescription(
        QGuiApplication::tr("Source of Tales client"));
    commandLineParser.addVersionOption();
    commandLineParser.addHelpOption();

    commandLineParser.addOptions({
                                  { "fullscreen", QGuiApplication::tr("Start in fullscreen mode") },
                                  { "serverlist", QGuiApplication::tr("Use the serverlist path <path>"),
                                   QGuiApplication::tr("path") },
                                  { "server",
                                   QGuiApplication::tr("Automatically connect to the ip <server>"),
                                   QGuiApplication::tr("server"), "server.sourceoftales.org" },
                                  { "port", QGuiApplication::tr("Automatically connect to the <port>"),
                                   QGuiApplication::tr("port"), "9601" },
                                  { "username", QGuiApplication::tr("Automatically login as <username>"),
                                   QGuiApplication::tr("username") },
                                  { "password",
                                   QGuiApplication::tr("Automatically login with <password>"),
                                   QGuiApplication::tr("password") },
                                  { "character",
                                   QGuiApplication::tr(
                                       "Automatically select the character <character index>"),
                                   QGuiApplication::tr("character index"), "-1" },
                                  });

    commandLineParser.process(app);

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("customServerListPath",
                                commandLineParser.value("serverlist"));
    context->setContextProperty("customServer",
                                commandLineParser.value("server"));
    context->setContextProperty("customPort",
                                commandLineParser.value("port").toInt());
    context->setContextProperty("userName",
                                commandLineParser.value("username"));
    context->setContextProperty("password",
                                commandLineParser.value("password"));
    context->setContextProperty(
        "characterIndex", commandLineParser.value("character").toInt());

    QString arch = QSysInfo::buildCpuArchitecture();

    const QString importPath = "share/main";

    engine.addImportPath(importPath);
   // engine.load(adjustSharePath(QLatin1String("qml/main/mobile.qml")));
    engine.load(importPath+"/mobile.qml");

    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
    if (!window) {
        qWarning() << "no window";
        return -1;
    }

    window->setClearBeforeRendering(false);


    if (commandLineParser.isSet("fullscreen"))
        window->showFullScreen();
    else
        window->show();


    return app.exec();

}
