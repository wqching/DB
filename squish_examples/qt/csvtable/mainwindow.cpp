/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include <qfile.h>
#include <qfileinfo.h>
#include <qtextstream.h>
#include <qaction.h>
#include <qapplication.h>
#include <qevent.h>
#include <qfiledialog.h>
#include <qinputdialog.h>
#include <qkeysequence.h>
#include <qmenu.h>
#include <qmenubar.h>
#include <qmessagebox.h>
#include <qstatusbar.h>
#include <qtablewidget.h>
#include <qtabwidget.h>
#include <qtoolbar.h>


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), dirty(false)
{
    QString path = ":/images/";
    QAction *fileNewAction = new QAction(QIcon(path + "filenew.png"),
                                         tr("&New"), this);
    fileNewAction->setShortcut(QKeySequence("Ctrl+N"));
    QAction *fileOpenAction = new QAction(QIcon(path + "fileopen.png"),
                                          tr("&Open..."), this);
    fileOpenAction->setShortcut(QKeySequence("Ctrl+O"));
    QAction *fileSaveAction = new QAction(QIcon(path + "filesave.png"),
                                          tr("&Save"), this);
    fileSaveAction->setShortcut(QKeySequence("Ctrl+S"));
    QAction *fileSaveAsAction = new QAction(tr("Save &As..."), this);
    QAction *fileQuitAction = new QAction(QIcon(path + "exit.png"),
                                          tr("&Quit"), this);
    QAction *editAppendRowAction = new QAction(tr("&Append Row"), this);
    QAction *editInsertRowAction = new QAction(tr("&Insert Row"), this);
    QAction *editDeleteRowAction = new QAction(tr("&Delete Row..."), this);
    QAction *editSwapColumnsAction = new QAction(tr("Swap &Columns..."),
                                                 this);
    // Purely for testing enabled/disable menu options
    QAction *disabledAction = new QAction(tr("Disabled"), this);
    disabledAction->setEnabled(false);

    // Purely for testing a context menu
    addActions(QList<QAction*>() << editAppendRowAction
            << editInsertRowAction << editDeleteRowAction
            << disabledAction);
    setContextMenuPolicy(Qt::ActionsContextMenu);
    // end of context menu stuff

    QMenu *fileMenu = menuBar()->addMenu(tr("&File"));
    fileMenu->addAction(fileNewAction);
    fileMenu->addAction(fileOpenAction);
    fileMenu->addAction(fileSaveAction);
    fileMenu->addAction(fileSaveAsAction);
    fileMenu->addSeparator();
    fileMenu->addAction(fileQuitAction);

    QMenu *editMenu = menuBar()->addMenu(tr("&Edit"));
    editMenu->addAction(editAppendRowAction);
    editMenu->addAction(editInsertRowAction);
    editMenu->addAction(editDeleteRowAction);
    editMenu->addSeparator();
    editMenu->addAction(editSwapColumnsAction);
    editMenu->addSeparator();
    editMenu->addAction(disabledAction);

    QToolBar *fileToolBar = addToolBar(tr("File"));
    fileToolBar->addAction(fileNewAction);
    fileToolBar->addAction(fileOpenAction);
    fileToolBar->addAction(fileSaveAction);

    tableWidget = new QTableWidget;
    setCentralWidget(tableWidget);

    connect(fileNewAction, SIGNAL(triggered()), this, SLOT(fileNew()));
    connect(fileOpenAction, SIGNAL(triggered()), this, SLOT(fileOpen()));
    connect(fileSaveAction, SIGNAL(triggered()), this, SLOT(fileSave()));
    connect(fileSaveAsAction, SIGNAL(triggered()),
            this, SLOT(fileSaveAs()));
    connect(fileQuitAction, SIGNAL(triggered()), this, SLOT(close()));
    connect(editAppendRowAction, SIGNAL(triggered()),
            this, SLOT(editAppendRow()));
    connect(editInsertRowAction, SIGNAL(triggered()),
            this, SLOT(editInsertRow()));
    connect(editDeleteRowAction, SIGNAL(triggered()),
            this, SLOT(editDeleteRow()));
    connect(editSwapColumnsAction, SIGNAL(triggered()),
            this, SLOT(editSwapColumns()));
    connect(tableWidget, SIGNAL(itemChanged(QTableWidgetItem*)),
            this, SLOT(setDirty()));

    statusBar()->showMessage("Ready", 5000);
    setWindowTitle(tr("CSV Table"));
}


void MainWindow::fileNew()
{
    if (!okToContinue())
        return;
    bool ok;
    QString line = QInputDialog::getText(this,
            tr("CSV Table - Column Names"),
            tr("Enter a comma-separated list of column names"),
            QLineEdit::Normal, QString(), &ok);
    if (!ok)
        return;
    tableWidget->clear();
    tableWidget->setRowCount(1);
    QStringList fields = parseCsvLine(line);
    tableWidget->setColumnCount(fields.count());
    tableWidget->setHorizontalHeaderLabels(fields);
    dirty = true;
    filename.clear();
    setWindowTitle(tr("CSV Table - Unnamed"));
}


void MainWindow::fileOpen()
{
    if (!okToContinue())
        return;
    QString name = QFileDialog::getOpenFileName(this,
            tr("CSV Table - Choose File"), ".", tr("CSV Files (*.csv)"));
    if (name.isEmpty())
        return;
    load(name);
}


void MainWindow::load(const QString &name)
{
    QFile file(name);
    if (!file.open(QIODevice::ReadOnly|QIODevice::Text)) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Failed to read file: %1").arg(file.errorString()));
        return;
    }
    tableWidget->clear();
    tableWidget->setRowCount(0);
    QTextStream in(&file);
    in.setCodec("utf8");
    if (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = parseCsvLine(line);
        tableWidget->setColumnCount(fields.count());
        tableWidget->setHorizontalHeaderLabels(fields);
    }
    int row = 0;
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = parseCsvLine(line);
        tableWidget->setRowCount(row + 1);
        QTableWidgetItem *item = 0;
        bool ok;
        for (int column = 0; column < fields.count(); ++column) {
            const QString &field = fields[column];
            item = new QTableWidgetItem(field);
            (void) field.toDouble(&ok);
            if (ok) {
                item->setTextAlignment(Qt::AlignVCenter|Qt::AlignRight);
            }
            tableWidget->setItem(row, column, item);
        }
        ++row;
    }
    file.close();
    tableWidget->resizeColumnsToContents();
    filename = name;
    dirty = false;
    setWindowTitle(tr("CSV Table - %1")
                   .arg(QFileInfo(filename).fileName()));
    statusBar()->showMessage(tr("Loaded %1").arg(filename), 5000);
}


QStringList MainWindow::parseCsvLine(const QString &line)
{
    QStringList fields;
    QString field;
    QChar quote;
    foreach (const QChar &c, line) {
        if (c == '"' || c == '\'') {
            if (quote == c) { // End of quoted field
                quote = '\0';
            }
            else if (!quote.isNull()) { // Different quote in quoted field
                field.append(c);
            }
            else { // Start of quoted field
                if (!field.isEmpty()) {
                    fields.append(field);
                    field.clear();
                }
                quote = c;
            }
        }
        else if (c == ',' && quote.isNull()) { // Field separator
            fields.append(field);
            field.clear();
        }
        else { // In quoted field
            field.append(c);
        }
    }
    if (!field.isEmpty())
        fields.append(field);
    return fields;
}


bool MainWindow::okToContinue()
{
    if (!dirty)
        return true;
    int reply = QMessageBox::question(this, tr("CSV Table"),
            tr("Save unsaved changes?"),
            QMessageBox::Yes|QMessageBox::No|QMessageBox::Cancel);
    if (reply == QMessageBox::Yes)
        return fileSave();
    if (reply == QMessageBox::Cancel)
        return false;
    return true;
}


void MainWindow::closeEvent(QCloseEvent *event)
{
    if (!okToContinue())
        event->ignore();
    else
        event->accept();
}


bool MainWindow::fileSave()
{
    if (filename.isEmpty())
        return fileSaveAs();
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly|QIODevice::Text)) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Failed to write file: %1").arg(file.errorString()));
        return false;
    }
    QTextStream out(&file);
    out.setCodec("utf8");
    QTableWidgetItem *item = 0;
    QStringList fields;
    for (int column = 0; column < tableWidget->columnCount(); ++column) {
        item = tableWidget->horizontalHeaderItem(column);
        fields.append(item ? canonicalized(item->text()) : QString());
    }
    out << fields.join(",") << "\n";
    for (int row = 0; row < tableWidget->rowCount(); ++row) {
        fields.clear();
        for (int column = 0; column < tableWidget->columnCount();
             ++column) {
            item = tableWidget->item(row, column);
            fields.append(item ? canonicalized(item->text()) : QString());
        }
        out << fields.join(",") << "\n";
    }
    file.close();
    dirty = false;
    setWindowTitle(tr("CSV Table - %1")
                   .arg(QFileInfo(filename).fileName()));
    statusBar()->showMessage(tr("Saved %1").arg(filename), 5000);
    return true;
}


QString MainWindow::canonicalized(const QString &text)
{
    QString field(text);
    field = field.replace("\"", "'");
    if (field.contains("'") || field.contains(","))
        return QString("\"%1\"").arg(field);
    return field;
}


bool MainWindow::fileSaveAs()
{
    QString name = QFileDialog::getSaveFileName(this,
            tr("CSV Table - Save As"), ".", tr("CSV Files (*.csv)"));
    if (name.isEmpty())
        return false;
    if (!name.toLower().endsWith(".csv"))
        name += ".csv";
    filename = name;
    return fileSave();
}


void MainWindow::editInsertRow()
{
    int row = tableWidget->currentRow();
    tableWidget->insertRow(row);
    tableWidget->setCurrentCell(row, 0);
    dirty = true;
}


void MainWindow::editAppendRow()
{
    int row = tableWidget->rowCount();
    tableWidget->insertRow(row);
    tableWidget->setCurrentCell(row, 0);
    dirty = true;
}


void MainWindow::editDeleteRow()
{
    int row = tableWidget->currentRow();
    if (row < 0 || row >= tableWidget->rowCount())
        return;
    if (QMessageBox::question(this, tr("CSV Table - Delete Row"),
            tr("Delete row #%1?").arg(row + 1),
            QMessageBox::Yes|QMessageBox::No) == QMessageBox::No)
        return;
    tableWidget->removeRow(row);
    dirty = true;
}


void MainWindow::editSwapColumns()
{
    bool ok;
    QString line = QInputDialog::getText(this,
            tr("CSV Table - Swap Columns"),
            tr("Enter the comma-separated names of the two columns "
               "to be swapped swapped"),
            QLineEdit::Normal, QString(), &ok);
    if (!ok)
        return;
    QStringList fields = parseCsvLine(line);
    if (fields.count() != 2) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Must enter exactly two comma-separated field names"));
        return;
    }
    if (fields[0] == fields[1]) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Must enter two different field names"));
        return;
    }
    int columnA = -1;
    int columnB = -1;
    QTableWidgetItem *item = 0;
    for (int column = 0; column < tableWidget->columnCount(); ++column) {
        item = tableWidget->horizontalHeaderItem(column);
        if (item) {
            if (item->text() == fields[0])
                columnA = column;
            else if (item->text() == fields[1])
                columnB = column;
        }
    }
    if (columnA == -1) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Failed to find the first field name"));
        return;
    }
    if (columnB == -1) {
        QMessageBox::warning(this, tr("CSV Table - Error"),
                tr("Failed to find the second field name"));
        return;
    }

    QTableWidgetItem *itemA = 0;
    QTableWidgetItem *itemB = 0;
    for (int row = 0; row < tableWidget->rowCount(); ++row) {
        itemA = tableWidget->takeItem(row, columnA);
        itemB = tableWidget->takeItem(row, columnB);
        tableWidget->setItem(row, columnA, itemB);
        tableWidget->setItem(row, columnB, itemA);
    }
    itemA = tableWidget->takeHorizontalHeaderItem(columnA);
    itemB = tableWidget->takeHorizontalHeaderItem(columnB);
    tableWidget->setHorizontalHeaderItem(columnA, itemB);
    tableWidget->setHorizontalHeaderItem(columnB, itemA);

    dirty = true;
}

