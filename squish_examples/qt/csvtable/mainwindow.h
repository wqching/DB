/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qmainwindow.h>
#include <qstring.h>
#include <qstringlist.h>

QT_BEGIN_NAMESPACE
class QListWidget;
class QTableWidget;
class QTabWidget;
class QTreeWidget;
QT_END_NAMESPACE


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent=0);

protected:
    void closeEvent(QCloseEvent *event);

private slots:
    void fileNew();
    void fileOpen();
    bool fileSave();
    bool fileSaveAs();
    void editAppendRow();
    void editInsertRow();
    void editDeleteRow();
    void editSwapColumns();
    void setDirty() { dirty = true; }

private:
    void load(const QString &name);
    bool okToContinue();
    QStringList parseCsvLine(const QString &line);
    QString canonicalized(const QString &text);

    QTableWidget *tableWidget;

    bool dirty;
    QString filename;
};
