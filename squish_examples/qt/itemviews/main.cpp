/*
    Copyright (c) 2008-10 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include <qapplication.h>
#include <qdesktopwidget.h>
#include <qfont.h>
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
#ifdef Q_OS_SOLARIS
    app.setFont( QFont( "Terminal", 12 ) );
#endif

    MainWindow window;
    window.resize(QSize(1200, 900).boundedTo(
                  app.desktop()->availableGeometry().size()));
    window.show();
    return app.exec();
}
