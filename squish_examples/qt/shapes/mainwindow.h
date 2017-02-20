#ifndef MAINWINDOW_H
#define MAINWINDOW_H
/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qmainwindow.h>

QT_BEGIN_NAMESPACE
class QGraphicsItem;
class QGraphicsProxyWidget;
class QGraphicsScene;
class QGraphicsView;
class QLabel;
class QLCDNumber;
class QPushButton;
class QSpinBox;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent=0);

private slots:
    void addBox();
    void addRegularPolygon();
    void addText();
    void deleteSelected();
    void setZ(int z);
    void selectionChanged();

private:
    void createSceneAndView();
    void createWidgets();
    void createProxyWidgets();
    void addItem(QGraphicsItem *item);
    QColor colorForX(int x);

    QPushButton *addBoxButton;
    QPushButton *addPolygonButton;
    QPushButton *addTextButton;
    QPushButton *deleteButton;
    QPushButton *quitButton;
    QLabel *zLabel;
    QSpinBox *zSpinBox;
    QLabel *countLabel;
    QLCDNumber *countLCDNumber;
    QGraphicsProxyWidget *addButtonProxy;

    QGraphicsScene *scene;
    QGraphicsView *view;
    int itemCount;
    QPoint offset;
};

#endif // MAINWINDOW_H
