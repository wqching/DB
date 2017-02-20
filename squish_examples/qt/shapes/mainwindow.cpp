/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include "regularpolygonitem.h"
#include <qgraphicsgridlayout.h>
#include <qgraphicsitem.h>
#include <qgraphicsproxywidget.h>
#include <qgraphicsscene.h>
#include <qgraphicsview.h>
#include <qinputdialog.h>
#include <qlabel.h>
#include <qlcdnumber.h>
#include <qmessagebox.h>
#include <qpoint.h>
#include <qpushbutton.h>
#include <qspinbox.h>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), itemCount(0)
{
    createSceneAndView();
    createWidgets();
    createProxyWidgets();
    offset = QPoint(150, 10);
    setWindowTitle(tr("Shapes"));
}


void MainWindow::createSceneAndView()
{
    view = new QGraphicsView;
    view->setDragMode(QGraphicsView::RubberBandDrag);
    scene = new QGraphicsScene(this);
    scene->setSceneRect(0, 0, 500, 500);
    connect(scene, SIGNAL(selectionChanged()),
            this, SLOT(selectionChanged()));
    view->setScene(scene);
    setCentralWidget(view);

}


void MainWindow::createWidgets()
{
    addBoxButton = new QPushButton(tr("Add &Box"));
    connect(addBoxButton, SIGNAL(clicked()), this, SLOT(addBox()));
    addPolygonButton = new QPushButton(tr("Add &Polygon"));
    connect(addPolygonButton, SIGNAL(clicked()),
            this, SLOT(addRegularPolygon()));
    addTextButton = new QPushButton(tr("Add &Text..."));
    connect(addTextButton, SIGNAL(clicked()), this, SLOT(addText()));
    deleteButton = new QPushButton(tr("&Delete..."));
    deleteButton->setEnabled(false);
    connect(deleteButton, SIGNAL(clicked()),
            this, SLOT(deleteSelected()));
    quitButton = new QPushButton(tr("&Quit"));
    connect(quitButton, SIGNAL(clicked()), this, SLOT(close()));
    zLabel = new QLabel(tr("&Z:"));
    zSpinBox = new QSpinBox;
    zSpinBox->setRange(-100, 100);
    zSpinBox->setValue(0);
    zSpinBox->setEnabled(false);
    connect(zSpinBox, SIGNAL(valueChanged(int)), this, SLOT(setZ(int)));
    zLabel->setBuddy(zSpinBox);
    countLabel = new QLabel(tr("Count"));
    countLCDNumber = new QLCDNumber;
    countLCDNumber->setSegmentStyle(QLCDNumber::Flat);
    countLCDNumber->display(0);
}


void MainWindow::createProxyWidgets()
{
    QGraphicsProxyWidget *addBoxButtonProxy = scene->addWidget(
            addBoxButton);
    QGraphicsProxyWidget *addPolygonButtonProxy = scene->addWidget(
            addPolygonButton);
    QGraphicsProxyWidget *addTextButtonProxy = scene->addWidget(
            addTextButton);
    QGraphicsProxyWidget *deleteButtonProxy = scene->addWidget(
            deleteButton);
    QGraphicsProxyWidget *zLabelProxy = scene->addWidget(zLabel);
    QGraphicsProxyWidget *zSpinBoxProxy = scene->addWidget(zSpinBox);
    QGraphicsProxyWidget *countLabelProxy = scene->addWidget(countLabel);
    QGraphicsProxyWidget *countLCDNumberProxy = scene->addWidget(
            countLCDNumber);
    QGraphicsProxyWidget *quitButtonProxy = scene->addWidget(quitButton);

    QGraphicsGridLayout *layout = new QGraphicsGridLayout;
    layout->addItem(addBoxButtonProxy, 0, 0, 1, 2);
    layout->addItem(addPolygonButtonProxy, 1, 0, 1, 2);
    layout->addItem(addTextButtonProxy, 2, 0, 1, 2);
    layout->addItem(deleteButtonProxy, 3, 0, 1, 2);
    layout->addItem(zLabelProxy, 4, 0);
    layout->addItem(zSpinBoxProxy, 4, 1);
    layout->addItem(countLabelProxy, 5, 0);
    layout->addItem(countLCDNumberProxy, 5, 1);
    layout->setColumnMinimumWidth(3, 200);
    layout->addItem(quitButtonProxy, 6, 0, 1, 2);

    QGraphicsProxyWidget *widgetProxy = new QGraphicsProxyWidget;
    widgetProxy->setLayout(layout);
    scene->addItem(widgetProxy);

    setMinimumSize(static_cast<int>(layout->preferredWidth()),
                   static_cast<int>(layout->preferredHeight()));
}


void MainWindow::addBox()
{
    QGraphicsRectItem *item = new QGraphicsRectItem(offset.x(),
                                                    offset.y(), 100, 34);
    item->setBrush(colorForX(itemCount));
    item->setPen(Qt::NoPen);
    addItem(item);
}


QColor MainWindow::colorForX(int x)
{
    static QList<QColor> colors;
    if (colors.isEmpty())
        colors << Qt::black << Qt::red << Qt::darkRed << Qt::green
               << Qt::darkGreen << Qt::blue << Qt::darkBlue << Qt::cyan
               << Qt::darkCyan << Qt::magenta << Qt::darkMagenta
               << Qt::yellow << Qt::darkYellow << Qt::gray
               << Qt::darkGray << Qt::lightGray;
    return colors.at(x % colors.count());
}


void MainWindow::addRegularPolygon()
{
    RegularPolygonItem *item = new RegularPolygonItem;
    item->setBrush(colorForX(itemCount));
    item->setPen(Qt::NoPen);
    item->setPos(offset.x(), offset.y());
    addItem(item);
}


void MainWindow::addText()
{
    bool ok;
    QString text = QInputDialog::getText(this, tr("Shapes - Add Text"),
            tr("Text:"), QLineEdit::Normal, "", &ok);
    if (ok && !text.isEmpty()) {
        QGraphicsTextItem *item = new QGraphicsTextItem;
        QFont font = item->font();
        font.setPointSize(20);
        item->setFont(font);
        item->setPlainText(text);
        item->setPos(offset.x(), offset.y());
        addItem(item);
    }
}


void MainWindow::addItem(QGraphicsItem *item)
{
    item->setFlags(QGraphicsItem::ItemIsMovable|
                   QGraphicsItem::ItemIsSelectable);
    scene->addItem(item);
    scene->clearSelection();
    item->setSelected(true);
    item->setZValue(itemCount);
    countLCDNumber->display(++itemCount);
    offset += QPoint(5, 5);
    selectionChanged();
}


void MainWindow::deleteSelected()
{
    QList<QGraphicsItem*> items = scene->selectedItems();
    if (!items.count())
        return;
    QMessageBox::StandardButton reply =
            QMessageBox::question(this, tr("Shapes - Delete"),
                    tr("Delete %n selected item(s)?", "", items.count()),
                    QMessageBox::No|(items.count() == 1
                            ? QMessageBox::Yes : QMessageBox::YesToAll));
    if (reply == QMessageBox::No)
        return;
    itemCount -= items.count();
    QListIterator<QGraphicsItem*> i(items);
    while (i.hasNext()) {
        QGraphicsItem *item = i.next();
        scene->removeItem(item);
        delete item;
    }
    countLCDNumber->display(itemCount);
}


void MainWindow::setZ(int z)
{
    foreach (QGraphicsItem *item, scene->selectedItems())
        item->setZValue(z);
}


void MainWindow::selectionChanged()
{
    QList<QGraphicsItem*> items = scene->selectedItems();
    bool enabled = items.count() > 0;
    deleteButton->setEnabled(enabled);
    zSpinBox->setEnabled(enabled);
    int value = items.count() == 1 ? qRound(items.at(0)->zValue()) : 0;
    zSpinBox->blockSignals(true);
    zSpinBox->setValue(value);
    zSpinBox->blockSignals(false);
}
