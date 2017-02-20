#ifndef MAIN_H
#define MAIN_H

#include <qwidget.h>

class WidgetDemoPage : public QWidget
{
    Q_OBJECT
public:
    WidgetDemoPage( const QString &text, QWidget *w, QWidget *parent = 0 );
};

#endif // !defined(MAIN_H)

