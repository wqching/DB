/*
    Copyright (c) 2009-11 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.

    Note that the icons used are from KDE (www.kde.org) and subject to
    the KDE's license.

    The Qt translations are copied from Qt 4.6.3 and subject to Qt's
    licenses.
*/

#include "mainwindow.h"
#include <qapplication.h>
#include <qfont.h>
#include <qtextstream.h>
#include <qtranslator.h>
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

    QTranslator qtTranslator;
    QTranslator appTranslator;
    if (argc == 2) {
        QString arg(argv[1]);
        if (arg == "-h" || arg == "--help" ||
            !(arg == "de" || arg == "fr")) {
            QTextStream out(stderr);
            out << "usage: addressbook [de|fr]\n";
            return 1;
        }
        qtTranslator.load(":/qt_" + arg);
        appTranslator.load(":/addressbook_" + arg);
        app.installTranslator(&qtTranslator);
        app.installTranslator(&appTranslator);
    }

    MainWindow mainWindow;
#ifndef Q_OS_ANDROID
    mainWindow.resize(640, 480);
#endif
    mainWindow.show();
    return app.exec();
}
