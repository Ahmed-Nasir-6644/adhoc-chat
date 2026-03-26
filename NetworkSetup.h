#ifndef NETWORKSETTUP_H
#define NETWORKSETTUP_H

#include <QObject>
#include <QString>
#include <QProcess>

class NetworkSetup : public QObject {
    Q_OBJECT

public:
    explicit NetworkSetup(QObject *parent = nullptr);
    
    Q_INVOKABLE void startAdhocSetup();
    Q_INVOKABLE QString getLastError() const;

signals:
    void setupSucceeded();
    void setupFailed(const QString &errorMessage);
    void setupProgress(const QString &message);

private slots:
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProcessError(QProcess::ProcessError error);
    void onProcessStdOut();
    void onProcessStdErr();

private:
    QProcess *m_process;
    QString m_lastError;
    QString m_scriptPath;
};

#endif // NETWORKSETTUP_H
