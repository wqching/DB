#include "canvas.h"
#include <qdatastream.h>
#include <qevent.h>
#include <qpainter.h>
#include <qrect.h>


using namespace Qt;

CanvasRect::CanvasRect(CanvasModel *m)
    : CanvasItem(m)
{
}

CanvasRect::CanvasRect(const QRect &rect, CanvasModel *m)
    : CanvasItem(m), r(rect)
{
    updateContentsSize(r);
    m->update(r);
}

void CanvasRect::draw(QPainter *p, const QRect &)
{
    p->setPen(black);
    p->setBrush(NoBrush);
    p->drawRect(r);
}

QRect CanvasRect::rect() const
{
    return r;
}

bool CanvasRect::hit(const QPoint &pos) const
{
    return r.contains(pos);
}

void CanvasRect::moveBy(const QPoint &diff)
{
    QRect old = r;
    r.translate(diff.x(), diff.y());
#if QT_VERSION < 0x040200
    canvasModel()->update(old.unite(r));
#else
    canvasModel()->update(old.united(r));
#endif
}

bool CanvasRect::save(QDataStream &ds)
{
    ds << r;
    return true;
}

bool CanvasRect::load(QDataStream &ds)
{
    ds >> r;
    updateContentsSize(r);
    canvasModel()->update(r);
    return true;
}



CanvasItem::CanvasItem(CanvasModel *m)
    : model(m)
{
    m->addItem(this);
}

void CanvasItem::updateContentsSize(const QRect &r)
{
    QRect _r = r;
    if (_r.isNull())
	_r = rect();
    QSize oldSize = canvasModel()->contentsSize();
    QSize newSize = QSize(qMax(oldSize.width(), _r.right()),
			  qMax(oldSize.height(), _r.bottom()));
    canvasModel()->setContentsSize(newSize);
}

void CanvasItem::handleMousePressEvent(QMouseEvent *e)
{
    lastPos = e->pos();
}

void CanvasItem::handleMouseMoveEvent(QMouseEvent *e)
{
    moveBy(e->pos() - lastPos);
    updateContentsSize();
    lastPos = e->pos();
}

void CanvasItem::handleMouseReleaseEvent(QMouseEvent *)
{
}

void CanvasItem::handleMouseDoubleClickEvent(QMouseEvent *)
{
}



CanvasModel::CanvasModel()
    : moveItem(0)
{
}

void CanvasModel::draw(QPainter *p, const QRect &clipRect)
{
    QListIterator<CanvasItem*> it(items);
    while (it.hasNext()) {
	CanvasItem *i = it.next();
	if (i->rect().intersects(clipRect))
	    i->draw(p, clipRect);
    }
}

void CanvasModel::handleMousePressEvent(QMouseEvent *e)
{
    QListIterator<CanvasItem*> it(items);
    while (it.hasNext()) {
	CanvasItem *i = it.next();
	if (!i->hit(e->pos()))
	    continue;
	moveItem = i;
	moveItem->handleMousePressEvent(e);
	return;
    }

    new CanvasRect(QRect(e->x(), e->y(), 50, 70), this);
}

void CanvasModel::handleMouseMoveEvent(QMouseEvent *e)
{
    if (!moveItem)
	return;
    moveItem->handleMouseMoveEvent(e);
}

void CanvasModel::handleMouseReleaseEvent(QMouseEvent *e)
{
    if (moveItem)
	moveItem->handleMouseReleaseEvent(e);
    moveItem = 0;
}

void CanvasModel::handleMouseDoubleClickEvent(QMouseEvent *)
{
}

void CanvasModel::addItem(CanvasItem *item)
{
    items.append(item);
}

void CanvasModel::takeItem(CanvasItem *item)
{
    items.removeAt(items.indexOf(item));
}

void CanvasModel::removeItem(CanvasItem *item)
{
    takeItem(item);
    delete item;
}

void CanvasModel::clear()
{
    items.clear();
}

int CanvasModel::numItems() const
{
    return items.count();
}

CanvasItem *CanvasModel::item( int index )
{
    return items.at(index);
}

bool CanvasModel::save(QDataStream &ds)
{
    QListIterator<CanvasItem*> it(items);
    while (it.hasNext()) {
	CanvasItem *i = it.next();
	ds << i->type();
	i->save(ds);
    }
    return true;
}

bool CanvasModel::load(QDataStream &ds)
{
    while (!ds.atEnd()) {
	int type;
	ds >> type;
	CanvasItem *i = 0;
	switch (type) {
	case CanvasItem::TRect:
	    i = new CanvasRect(this);
	    break;
	default:
	    break;
	}
	if (i)
	    i->load(ds);
	else
	    return false;
    }
    return true;
}

void CanvasModel::update(const QRect &r)
{
    emit updateNotify(r.adjusted(0, 0, 1, 1));
}

void CanvasModel::setContentsSize(const QSize &s)
{
    cSize = s;
    emit contentsSizeChanged(cSize.width(), cSize.height());
}

QSize CanvasModel::contentsSize() const
{
    return cSize;
}

void CanvasModel::addView(CanvasView *)
{
}


CanvasView::CanvasView(CanvasModel *m, QWidget *parent)
    : QWidget(parent), model(m)
{
    setObjectName("CanvasView");

    connect(m, SIGNAL(updateNotify(const QRect &)),
	     this, SLOT(updateContents(const QRect &)));
    connect(m, SIGNAL(contentsSizeChanged(int, int)),
	     this, SLOT(resizeContents(int, int)));
    setBackgroundRole(QPalette::Base);
    setFocusPolicy(WheelFocus);
    setFocus();
    m->addView(this);
}

void CanvasView::paintEvent(QPaintEvent *e)
{
    QPainter p(this);
    model->draw(&p, e->rect());
}

void CanvasView::mousePressEvent(QMouseEvent *e)
{
    model->handleMousePressEvent(e);
}

void CanvasView::mouseReleaseEvent(QMouseEvent *e)
{
    model->handleMouseReleaseEvent(e);
}

void CanvasView::mouseMoveEvent(QMouseEvent *e)
{
    model->handleMouseMoveEvent(e);
}

void CanvasView::mouseDoubleClickEvent(QMouseEvent *e)
{
    model->handleMouseDoubleClickEvent(e);
}

void CanvasView::updateContents(const QRect &r)
{
    update(r);
}

void CanvasView::resizeContents(int w, int h)
{
    resize(w, h);
}
