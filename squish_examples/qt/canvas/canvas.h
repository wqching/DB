#ifndef CANVAS_H
#define CANVAS_H

#include <qlist.h>
#include <qwidget.h>
#include <qdatastream.h>

class CanvasModel;
class CanvasView;

class TEST_EXPORT CanvasInterface
{
public:
    virtual ~CanvasInterface() {}

    virtual void draw(QPainter *p, const QRect &clipRect) = 0;

    virtual void handleMousePressEvent(QMouseEvent *e) = 0;
    virtual void handleMouseMoveEvent(QMouseEvent *e) = 0;
    virtual void handleMouseReleaseEvent(QMouseEvent *e) = 0;
    virtual void handleMouseDoubleClickEvent(QMouseEvent *e) = 0;

    virtual bool save(QDataStream &ds) = 0;
    virtual bool load(QDataStream &ds) = 0;

};

class TEST_EXPORT CanvasItem : public CanvasInterface
{
public:
    enum Type {
	TRect
    };

    CanvasItem(CanvasModel *m);

    CanvasModel *canvasModel() { return model; }

    void handleMousePressEvent(QMouseEvent *e);
    void handleMouseMoveEvent(QMouseEvent *e);
    void handleMouseReleaseEvent(QMouseEvent *e);
    void handleMouseDoubleClickEvent(QMouseEvent *e);

    virtual QRect rect() const { return QRect(); }
    virtual bool hit(const QPoint &pos) const = 0;
    virtual void moveBy(const QPoint &pos) = 0;

    void updateContentsSize(const QRect &r = QRect());

    virtual int type() const = 0;

private:
    CanvasModel *model;
    QPoint lastPos;

};

class TEST_EXPORT CanvasRect : public CanvasItem
{
public:
    CanvasRect(CanvasModel *m);
    CanvasRect(const QRect &rect, CanvasModel *m);

    void draw(QPainter *p, const QRect &clipRect);

    QRect rect() const;
    bool hit(const QPoint &pos) const;
    void moveBy(const QPoint &diff);

    bool save(QDataStream &ds);
    bool load(QDataStream &ds);

    virtual int type() const { return TRect; }

private:
    QRect r;

};

class TEST_EXPORT CanvasModel : public QObject,
		    public CanvasInterface
{
    Q_OBJECT

public:
    CanvasModel();

    void draw(QPainter *p, const QRect &clipRect);

    void handleMousePressEvent(QMouseEvent *e);
    void handleMouseMoveEvent(QMouseEvent *e);
    void handleMouseReleaseEvent(QMouseEvent *e);
    void handleMouseDoubleClickEvent(QMouseEvent *e);

    void addItem(CanvasItem *item);
    void takeItem(CanvasItem *item);
    void removeItem(CanvasItem *item);
    void clear();
    bool save(QDataStream &ds);
    bool load(QDataStream &ds);

    int numItems() const;
    CanvasItem *item( int index );

    void update(const QRect &r);
    void setContentsSize(const QSize &s);

    QSize contentsSize() const;

    void addView(CanvasView *v);

signals:
    void updateNotify(const QRect &r);
    void contentsSizeChanged(int w, int h);

private:
    QList<CanvasItem*> items;
    CanvasItem *moveItem;
    QSize cSize;

};

class TEST_EXPORT CanvasView : public QWidget
{
    Q_OBJECT

public:
    CanvasView(CanvasModel *m, QWidget *parent = 0);

    CanvasModel *canvasModel() { return model; }

protected:
    void paintEvent(QPaintEvent *e);
    void mousePressEvent(QMouseEvent *e);
    void mouseReleaseEvent(QMouseEvent *e);
    void mouseMoveEvent(QMouseEvent *e);
    void mouseDoubleClickEvent(QMouseEvent *e);

protected slots:
    void updateContents(const QRect &r);
    void resizeContents(int w, int h);

private:
    CanvasModel *model;

};

#endif

