QT *= quick
SOURCES += main.cpp
RESOURCES += quickaddressbook.qrc

# Include Squish/Qt if a Squish installation prefix was provided to qmake
!isEmpty(SQUISH_PREFIX) {
    message("Including Squish/Qt files")
    android {
        SQUISH_ATTACH_PORT=4711
    }
    include($$SQUISH_PREFIX/qtbuiltinhook.pri)
}

boot2qt {
    target.path = /data/user/qt/$$TARGET
    INSTALLS += target
}
