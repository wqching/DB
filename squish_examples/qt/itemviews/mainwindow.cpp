/*
    Copyright (c) 2008-9 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include <qabstractitemmodel.h>
#include <qevent.h>
#include <qlist.h>
#include <qlistwidget.h>
#include <qmenu.h>
#include <qsplitter.h>
#include <qstandarditemmodel.h>
#include <qtablewidget.h>
#include <qtreeview.h>
#include <qtreewidget.h>


// This class is purely to allow for testing context menus.
class TreeView : public QTreeView
{
public:
    TreeView(QWidget *parent=0) : QTreeView(parent) {}

protected:
    void contextMenuEvent(QContextMenuEvent *event)
    {
        const QString &text = model()->data(currentIndex(),
                    Qt::DisplayRole).toString();
        if (text.isEmpty() || !text[0].isLetter())
            return;
        const int A = QChar('A').unicode();
        QMenu menu;
        for (int i = A; i <= text[0].toUpper().unicode(); ++i)
            menu.addAction(QString("&%1 Choice").arg(QChar(i)));
        menu.exec(event->globalPos());
    }
};


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    listView = new QListView;
    listView->setSelectionMode(QAbstractItemView::MultiSelection);
    listWidget = new QListWidget;
    listWidget->setSelectionMode(QAbstractItemView::MultiSelection);
    populateLists();

    tableView = new QTableView;
    tableWidget = new QTableWidget;
    populateTables();

    treeWidget = new QTreeWidget;
    treeView = new TreeView;
    populateTrees();

    QSplitter *listSplitter = new QSplitter(Qt::Vertical);
    listSplitter->addWidget(listView);
    listSplitter->addWidget(listWidget);
    QSplitter *tableSplitter = new QSplitter(Qt::Vertical);
    tableSplitter->addWidget(tableView);
    tableSplitter->addWidget(tableWidget);
    QSplitter *treeSplitter = new QSplitter(Qt::Vertical);
    treeSplitter->addWidget(treeView);
    treeSplitter->addWidget(treeWidget);
    QSplitter *splitter = new QSplitter(Qt::Horizontal);
    splitter->addWidget(listSplitter);
    splitter->addWidget(tableSplitter);
    splitter->addWidget(treeSplitter);
    setCentralWidget(splitter);

    setWindowTitle(tr("Item Views"));
}


void MainWindow::populateLists()
{
    QList<QPersistentModelIndex> indexes;
    QStandardItemModel *listModel = new QStandardItemModel(this);
    foreach (const QString &text, QStringList()
            << tr("All's Well That Ends Well")
            << tr("As You Like It")
            << tr("The Comedy of Errors")
            << tr("Love's Labour's Lost")
            << tr("Measure for Measure")
            << tr("The Merchant of Venice")
            << tr("The Merry Wives of Windsor")
            << tr("A Midsummer Night's Dream")
            << tr("Much Ado About Nothing")
            << tr("Pericles, Prince of Tyre")
            << tr("The Taming of the Shrew")
            << tr("The Tempest")
            << tr("Twelfth Night, or What You Will")
            << tr("The Two Gentlemen of Verona")
            << tr("The Two Noble Kinsmen")
            << tr("The Winter's Tale")) {
        QStandardItem *item = new QStandardItem(text);
        item->setCheckable(true);
        if (!text.startsWith(tr("T")))
            item->setCheckState(Qt::Checked);
        listModel->appendRow(item);
        if (text.contains(tr("You")))
            indexes << item->index();
        QListWidgetItem *item2 = new QListWidgetItem(text);
        if (!text.startsWith(tr("T")))
            item2->setCheckState(Qt::Checked);
        else
            item2->setCheckState(Qt::Unchecked);
        listWidget->addItem(item2);
        if (text.contains(tr("You")))
            item2->setSelected(true);
    }
    listView->setModel(listModel);
    QItemSelectionModel *selectionModel = listView->selectionModel();
    foreach (const QPersistentModelIndex &index, indexes)
        if (index.isValid())
            selectionModel->select(index, QItemSelectionModel::Select);
}


void MainWindow::populateTables()
{
    tableWidget->setColumnCount(5);
    tableWidget->setHorizontalHeaderLabels(QStringList() << tr("One")
            << tr("Two") << tr("Three") << tr("Four") << tr("Five"));
    QStandardItemModel *tableModel = new QStandardItemModel(this);
    tableModel->setHorizontalHeaderLabels(QStringList() << tr("One")
            << tr("Two") << tr("Three") << tr("Four") << tr("Five"));
    tableModel->setColumnCount(5);
    QSet<int> selected;
    selected << 3 << 7 << 9 << 15 << 24;
    QList<QPersistentModelIndex> indexes;
    int count = 0;
    foreach (const QString &text, QStringList()
            << tr("Boron") << tr("Carbon") << tr("Nitrogen")
            << tr("Oxygen") << tr("Florine") << tr("Aluminium")
            << tr("Silicon") << tr("Phosphorus") << tr("Sulphur")
            << tr("Chlorine") << tr("Gallium") << tr("Germanium")
            << tr("Arsenic") << tr("Selenium") << tr("Bromine")
            << tr("Indium") << tr("Tin") << tr("Antimony")
            << tr("Tellurium") << tr("Iodine") << tr("Thallium")
            << tr("Lead") << tr("Bismuth") << tr("Polonium")
            << tr("Astatine")) {
        int row = count / 5;
        int column = count % 5;
        QStandardItem *item = new QStandardItem(text);
        if (!text.startsWith("A")) // Have some _without_ tooltips
            item->setToolTip(tr("Tooltip for %1").arg(text));
        if (column == 4) {
            item->setCheckable(true);
            if (text.startsWith(tr("A")) || text.startsWith(tr("B")))
                item->setCheckState(Qt::Checked);
            else
                item->setCheckState(Qt::Unchecked);
        }
        tableModel->setRowCount(row + 1);
        tableModel->setItem(row, column, item);
        if (selected.contains(count))
            indexes << item->index();
        QTableWidgetItem *item2 = new QTableWidgetItem(text);
        if (!text.startsWith("A")) // Have some _without_ tooltips
            item2->setToolTip(tr("Tooltip for %1").arg(text));
        tableWidget->setRowCount(row + 1);
        if (column == 4) {
            if (text.startsWith(tr("A")) || text.startsWith(tr("B")))
                item2->setCheckState(Qt::Checked);
            else
                item2->setCheckState(Qt::Unchecked);
        }
        tableWidget->setItem(row, column, item2);
        if (selected.contains(count))
            item2->setSelected(true);
        ++count;
    }
    tableView->setModel(tableModel);
    QItemSelectionModel *selectionModel = tableView->selectionModel();
    foreach (const QPersistentModelIndex &index, indexes)
        if (index.isValid())
            selectionModel->select(index, QItemSelectionModel::Select);
}


void MainWindow::populateTrees()
{
    treeWidget->setColumnCount(2);
    QList<QTreeWidgetItem*> items;
    QList<QTreeWidgetItem*> names;
    QTreeWidgetItem *flagged;
    int count = 1000;
    QTreeWidgetItem *bryophytes = 0;
    foreach (const QString &name, QStringList()
            << tr("Green algae") << tr("Bryophytes")
            << tr("Pteridophytes") << tr("Seed plants")) {
        QTreeWidgetItem *item = new QTreeWidgetItem(QStringList() << name);
        if (name == tr("Bryophytes"))
            bryophytes = item;
        names.append(item);
        treeWidget->addTopLevelItem(item);
        items << item;
    }
    QTreeWidgetItem *item = new QTreeWidgetItem(names[0],
                QStringList() << tr("Chlorophytes"));
    items << item;
    (void) new QTreeWidgetItem(item, QStringList()
            << tr("Chlorophyceae") << QString::number(count++));
    (void) new QTreeWidgetItem(item, QStringList()
            << tr("Ulvophyceae") << QString::number(count++));
    (void) new QTreeWidgetItem(item, QStringList()
            << tr("Trebouxiophyceae") << QString::number(count++));
    item = new QTreeWidgetItem(names[0],
                QStringList() << tr("Desmids & Charophytes"));
    items << item;
    flagged = new QTreeWidgetItem(item, QStringList()
            << tr("Closteriaceae") << QString::number(count++));
    flagged->setCheckState(0, Qt::Checked);
    flagged = new QTreeWidgetItem(item, QStringList() << tr("Desmidiaceae")
            << QString::number(count++));
    flagged->setCheckState(0, Qt::Unchecked);
    flagged = new QTreeWidgetItem(item, QStringList()
            << tr("Gonaozygaceae") << QString::number(count++));
    flagged->setSelected(true);
    (void) new QTreeWidgetItem(item, QStringList() << tr("Peniaceae")
            << QString::number(count++));
    item = new QTreeWidgetItem(names[1], QStringList()
            << tr("Liverworts") << QString::number(count++));
    items << item;
    (void) new QTreeWidgetItem(names[1], QStringList() << tr("Hornworts")
            << QString::number(count++));
    (void) new QTreeWidgetItem(names[1], QStringList() << tr("Mosses")
            << QString::number(count++));
    (void) new QTreeWidgetItem(names[2], QStringList()
            << tr("Club Mosses") << QString::number(count++));
    (void) new QTreeWidgetItem(names[2], QStringList() << tr("Ferns")
            << QString::number(count++));
    flagged = new QTreeWidgetItem(names[3], QStringList() << tr("Cycads")
            << QString::number(count++));
    flagged->setCheckState(0, Qt::Checked);
    flagged->setSelected(true);
    (void) new QTreeWidgetItem(names[3], QStringList() << tr("Ginkgo")
            << QString::number(count++));
    (void) new QTreeWidgetItem(names[3], QStringList()
            << tr("Conifers") << QString::number(count++));
    (void) new QTreeWidgetItem(names[3], QStringList()
            << tr("Gnetophytes") << QString::number(count++));
    (void) new QTreeWidgetItem(names[3], QStringList()
            << tr("Flowering Plants") << QString::number(count++));
    treeWidget->expandAll();
    treeWidget->collapseItem(bryophytes); // so we have some of each
    treeWidget->resizeColumnToContents(0);

    QAbstractItemModel *model = treeWidget->model();
    treeView->setModel(model);
    treeView->expandAll();
    QModelIndexList list = model->match(model->index(0, 0),
            Qt::DisplayRole, tr("Bryophytes"));
    if (list.count())
        treeView->collapse(list.at(0));
    treeView->resizeColumnToContents(0);
    QAbstractItemModel *treeModel = treeView->model();
    selectMatchingTreeItem(treeModel, QModelIndex(),
            QSet<QString>() << tr("Gonaozygaceae") << tr("Cycads")
                            << "1005" << "1012");
}


void MainWindow::selectMatchingTreeItem(
        const QAbstractItemModel *treeModel, const QModelIndex &parent,
        const QSet<QString> &texts)
{
    for (int row = 0; row < treeModel->rowCount(parent); ++row) {
        for (int column = 0; column < treeModel->columnCount(parent);
             ++column) {
            const QModelIndex index = treeModel->index(row, column,
                                                       parent);
            if (!index.isValid())
                continue;
            QString text = treeModel->data(index).toString();
            if (texts.contains(text)) {
                QItemSelectionModel *selectionModel =
                        treeView->selectionModel();
                selectionModel->select(index, QItemSelectionModel::Select);
            }
            if (treeModel->hasChildren(index))
                selectMatchingTreeItem(treeModel, index, texts);
        }
    }
}
