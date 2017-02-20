/*
    Copyright (c) 2010 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include <qapplication.h>
#ifdef Q_WS_X11
#  include <qstylefactory.h>
#endif
#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
#include "../../../include/qtbuiltinhook.h"
#endif

int main(int argc, char *argv[])
{
#ifdef Q_WS_X11
    // Avoid Gtk problems
    QStyle *windowsStyle = QStyleFactory::create( QLatin1String( "windows" ) );
    if ( windowsStyle ) {
        QApplication::setStyle( windowsStyle );
    }
#endif
    QApplication app(argc, argv);

#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
    Squish::installBuiltinHook(); // On AIX/VxWorks we must manually install a hook
#endif

    MainWindow window;
    window.show();
    return app.exec();
}
