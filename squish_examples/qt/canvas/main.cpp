#include <qapplication.h>
#include <qmainwindow.h>
#include <qscrollarea.h>
#include "canvas.h"

#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
#include "../../../include/qtbuiltinhook.h"
#endif

int main(int argc, char **argv)
{
    QApplication a(argc, argv);

#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
    Squish::installBuiltinHook(); // On AIX/VxWorks we must manually install a hook
#endif

    // create main widget
    QMainWindow *mw = new QMainWindow;
    mw->setWindowTitle("Canvas");
    mw->resize(700, 500);

    // set up canvas
    CanvasModel *canvasModel = new CanvasModel;
    CanvasView *canvas = new CanvasView(canvasModel);
    QScrollArea *scroll = new QScrollArea;
    scroll->setWidget(canvas);
    scroll->setWidgetResizable(true);
    mw->setCentralWidget(scroll);

    mw->show();
    a.connect(&a, SIGNAL(lastWindowClosed()), &a, SLOT(quit()));
    return a.exec();
}
