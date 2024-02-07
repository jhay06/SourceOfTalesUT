/*
 * Mana Mobile
 * Copyright (C) 2010  Thorbjørn Lindeijer
 * Copyright (C) 2012  Erik Schilling
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, see <http://www.gnu.org/licenses/>.
 */

#include <QDebug>
#include <QDir>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QScreen>
#include <QCommandLineParser>

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_LINUX_TIZEN)
static QString adjustSharePath(const QString &path)
{
#if defined(Q_OS_MAC)
    if (!QDir::isAbsolutePath(path))
        return QString::fromLatin1("%1/../Resources/%2")
                .arg(QCoreApplication::applicationDirPath(), path);
#elif defined(Q_OS_QNX)
    if (!QDir::isAbsolutePath(path))
        return QString::fromLatin1("app/native/%1").arg(path);
#elif (defined(Q_OS_UNIX) || defined(Q_OS_WIN)) && !defined(Q_OS_ANDROID)
    const QString pathInInstallDir =
            QString::fromLatin1("%1/../share/tales-client/%2").arg(QCoreApplication::applicationDirPath(), path);
    if (QFileInfo(pathInInstallDir).exists())
        return pathInInstallDir;
#endif
    return path;
}
#endif

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

#ifdef Q_OS_ANDROID
    engine.addImportPath(QLatin1String("assets:/qml"));
    engine.addPluginPath(QDir::homePath() + "/../lib");
    engine.load(QUrl(QLatin1String("assets:/qml/main/mobile.qml")));
#elif defined(Q_OS_LINUX_TIZEN)
    engine.addImportPath(QLatin1String("../data/qml"));
    engine.load(app.applicationDirPath() +
                QLatin1String("/../data/qml/main/mobile.qml"));
#else
#ifdef Q_OS_OSX
    const QString importPath = "/../Resources/qml/";
#else
    const QString importPath = "/../lib/libmana/qml/";
#endif
    engine.addImportPath(adjustSharePath(app.applicationDirPath() +
                         importPath));
    engine.load(adjustSharePath(QLatin1String("qml/main/mobile.qml")));
#endif

    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
    if (!window) {
        qWarning() << "no window";
        return -1;
    }

    window->setClearBeforeRendering(false);

#ifdef Q_OS_LINUX_TIZEN
    window->setProperty("contentFollowsContentOrientation", true);
    window->screen()->setOrientationUpdateMask(Qt::LandscapeOrientation |
                                               Qt::InvertedLandscapeOrientation);
#endif

#if defined(Q_WS_SIMULATOR) || defined(Q_OS_QNX)
    window->showFullScreen();
#else
    if (commandLineParser.isSet("fullscreen"))
        window->showFullScreen();
    else
        window->show();
#endif

    return app.exec();
}

#ifdef Q_OS_LINUX_TIZEN
extern "C" int OspMain(int argc, char *argv[])
{
#ifdef Q_OS_LINUX_TIZEN_SIMULATOR
    qputenv("QSG_RENDER_LOOP", "windows");
#endif
    return main(argc, argv);
}
#endif
