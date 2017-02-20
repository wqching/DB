/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qfont.h>
#include <qguiapplication.h>
#include <qqmlapplicationengine.h>
#include <qqmlcontext.h>
#include <qstylehints.h>
#include <qurl.h>

#if defined(Q_OS_WIN32)
#  include <windows.h>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app( argc, argv );

#if defined(Q_OS_WIN32)
    if ( ::GetSystemMetrics( SM_REMOTESESSION ) ) {
        ::MessageBoxA( NULL,
                "This example application does not\nwork in Remote Desktop sessions.",
                "RDP not supported",
                MB_OK | MB_ICONEXCLAMATION
                );
        return 1;
    }
#endif

    if ( app.styleHints()->showIsFullScreen() ) {
        // Increase fonts size on fullscreen devices
        QFont appFont = app.font();
        appFont.setPointSize( appFont.pointSize() + 1 );
        app.setFont( appFont );
    }

    QQmlApplicationEngine engine;

    // Used by example testsuite to demonstrate access to context properties
    engine.rootContext()->setContextProperty( "appContextProperty", &app );

    engine.load( QUrl( QStringLiteral( "qrc:///qml/main.qml" ) ) );
    return engine.rootObjects().empty() ? 1 : app.exec();
}
