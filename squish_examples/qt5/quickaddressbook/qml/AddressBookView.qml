/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.0

TableView {
    id: tableView

    style: TableViewStyle {
        rowDelegate: Rectangle {
            height: Math.round(TextSingleton.implicitHeight * 1.4) // increase padding
            property color selectedColor: styleData.hasActiveFocus ? "#07c" : "#999"
            color: styleData.selected ? selectedColor : alternateBackgroundColor
        }
    }

    function columnWidth(ratio) {
        return Math.round(tableView.width * ratio) - 1;
    }

    TableViewColumn{ role: "firstName"  ; title: "First" ; width: columnWidth(0.2) }
    TableViewColumn{ role: "lastName" ; title: "Last" ; width: columnWidth(0.2) }
    TableViewColumn{ role: "emailAddress" ; title: "Email" ; width: columnWidth(0.3) }
    TableViewColumn{ role: "phoneNumber" ; title: "Phone" ; width: columnWidth(0.3) }
}
