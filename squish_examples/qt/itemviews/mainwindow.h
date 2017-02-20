/*
    Copyright (c) 2008 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qmainwindow.h>
#include <qset.h>

QT_BEGIN_NAMESPACE
class QAbstractItemModel;
class QListView;
class QListWidget;
class QModelIndex;
class QTableView;
class QTableWidget;
class QTreeWidget;
QT_END_NAMESPACE
class TreeView;


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent=0);

private:
    void populateLists();
    void populateTables();
    void populateTrees();
    void selectMatchingTreeItem(const QAbstractItemModel *treeModel,
            const QModelIndex &parent, const QSet<QString> &texts);

    QListView *listView;
    QListWidget *listWidget;
    QTableView *tableView;
    QTableWidget *tableWidget;
    TreeView *treeView;
    QTreeWidget *treeWidget;
};
