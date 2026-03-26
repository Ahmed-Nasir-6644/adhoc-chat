#include "NetworkSetup.h"
#include <QDebug>
#include <QStandardPaths>
#include <QCoreApplication>

NetworkSetup::NetworkSetup(QObject *parent)
    : QObject(parent), m_process(nullptr)
{
    // Resolve script path relative to application
    m_scriptPath = QCoreApplication::applicationDirPath() + "/../backend/setup-adhoc-network.sh";
}

void NetworkSetup::startAdhocSetup() {
    if (m_process && m_process->state() != QProcess::NotRunning) {
        m_lastError = "Setup already in progress";
        emit setupFailed(m_lastError);
        return;
    }

    if (m_process) {
        delete m_process;
    }

    m_process = new QProcess(this);

    // Connect signals
    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &NetworkSetup::onProcessFinished);
    connect(m_process, static_cast<void (QProcess::*)(QProcess::ProcessError)>(&QProcess::errorOccurred),
            this, &NetworkSetup::onProcessError);
    connect(m_process, &QProcess::readyReadStandardOutput,
            this, &NetworkSetup::onProcessStdOut);
    connect(m_process, &QProcess::readyReadStandardError,
            this, &NetworkSetup::onProcessStdErr);

    // Make script executable and run with sudo
    QStringList arguments;
    arguments << "bash" << m_scriptPath;

    qDebug() << "Starting ad-hoc setup with script:" << m_scriptPath;
    m_process->start("sudo", arguments);

    if (!m_process->waitForStarted()) {
        m_lastError = "Failed to start setup process";
        emit setupFailed(m_lastError);
    } else {
        emit setupProgress("Setup started...");
    }
}

QString NetworkSetup::getLastError() const {
    return m_lastError;
}

void NetworkSetup::onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus) {
    if (exitStatus == QProcess::NormalExit && exitCode == 0) {
        qDebug() << "Ad-hoc network setup completed successfully";
        emit setupSucceeded();
    } else {
        m_lastError = QString("Setup failed with exit code: %1").arg(exitCode);
        qDebug() << m_lastError;
        emit setupFailed(m_lastError);
    }
}

void NetworkSetup::onProcessError(QProcess::ProcessError error) {
    m_lastError = QString("Process error: %1").arg(error);
    qDebug() << m_lastError;
    emit setupFailed(m_lastError);
}

void NetworkSetup::onProcessStdOut() {
    QString output = QString::fromUtf8(m_process->readAllStandardOutput());
    qDebug() << "STDOUT:" << output;
    emit setupProgress(output);
}

void NetworkSetup::onProcessStdErr() {
    QString output = QString::fromUtf8(m_process->readAllStandardError());
    qDebug() << "STDERR:" << output;
    emit setupProgress(output);
}
