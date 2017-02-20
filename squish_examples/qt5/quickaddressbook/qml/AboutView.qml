/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
    property string aboutText;

    Label {
        text: aboutText;
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
