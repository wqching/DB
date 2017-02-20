#ifndef REGULARPOLYGONITEM_H
#define REGULARPOLYGONITEM_H
/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qobject.h>
#include <qgraphicsitem.h>
#include <qgraphicssceneevent.h>


class RegularPolygonItem : public QObject, public QGraphicsPolygonItem
{
    Q_OBJECT
    Q_ENUMS(RegularPolygon)

public:
    enum RegularPolygon{Triangle, Square};

    RegularPolygonItem(QGraphicsItem *parent=0);

    RegularPolygon regularPolygon() const { return m_regularPolygon; }

public slots:
    void setRegularPolygon(RegularPolygon regularPolygon);

protected:
    void contextMenuEvent(QGraphicsSceneContextMenuEvent *event);

private:
    RegularPolygon m_regularPolygon;
};

#endif // REGULARPOLYGONITEM_H
