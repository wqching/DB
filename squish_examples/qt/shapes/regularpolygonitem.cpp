/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "regularpolygonitem.h"
#include <qmap.h>
#include <qmenu.h>
#include <qpolygon.h>


RegularPolygonItem::RegularPolygonItem(QGraphicsItem *parent)
    : QObject(), QGraphicsPolygonItem(parent)
{
    setRegularPolygon(Triangle);
}


void RegularPolygonItem::setRegularPolygon(RegularPolygon regularPolygon)
{
    m_regularPolygon = regularPolygon;
    QPolygonF polygon;
    if (m_regularPolygon == Triangle) {
        polygon << QPointF(-50.0, 50.0) << QPointF(0.0, -50.0)
                << QPointF(50.0, 50.0);
    }
    else if (m_regularPolygon == Square) {
        polygon << QPointF(-50.0, -50.0) << QPointF(-50.0, 50.0)
                << QPointF(50.0, 50.0) << QPointF(50.0, -50.0);
    }
    setPolygon(polygon);
}


void RegularPolygonItem::contextMenuEvent(
        QGraphicsSceneContextMenuEvent *event)
{
    QMap<QAction*, int> actions;
    QMenu menu;
    actions.insert(menu.addAction(tr("&Triangle")),
                   static_cast<int>(Triangle));
    actions.insert(menu.addAction(tr("&Square")),
                   static_cast<int>(Square));
    QAction *chosen = menu.exec(event->screenPos());
    if (chosen)
        setRegularPolygon(static_cast<RegularPolygon>(
                          actions.value(chosen)));
}
