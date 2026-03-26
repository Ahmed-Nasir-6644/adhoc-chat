#include <QGuiApplication>
#include <QUrl>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Qt 6.4 compatibility: load the entry QML directly from resources.
    engine.load(QUrl(QStringLiteral("qrc:/chatApp/Main.qml")));

    return app.exec();
}
