/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    objectName: "mainWindow"
    title: qsTr("Quick Addressbook")
    visible: true

    minimumWidth: 500
    minimumHeight: 300

    Action {
        id: addAction
        text: qsTr("Add")
        shortcut: "Ctrl+A"
        enabled: addressBookView.isActive
        onTriggered: {
            addressBookView.currentRow = -1;
            viewStack.push(editView);
            addressBookView.currentRow = addressBookModel.appendNewAddressBookEntry();
        }
    }
    Action {
        id: editAction
        text: qsTr("Edit")
        shortcut: "Ctrl+E"
        enabled: addressBookView.isActive && addressBookView.currentRow != -1
        onTriggered: viewStack.push(editView)
    }
    Action {
        id: removeAction
        text: qsTr("Remove")
        shortcut: "Delete"
        enabled: addressBookView.isActive && addressBookView.currentRow != -1
        onTriggered: addressBookModel.remove(addressBookView.currentRow)
    }
    Action {
        id: backAction;
        text: qsTr("Back")
        shortcut: "Escape"
        enabled: viewStack.depth > 1
        onTriggered: viewStack.pop()
    }
    Action {
        id: aboutAction
        text: qsTr("About")
        enabled: !aboutView.isActive
        onTriggered: viewStack.push(aboutView)
    }

    toolBar: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton { action: backAction; tooltip: "" }
            ToolButton { action: addAction; tooltip: ""; visible: addressBookView.isActive }
            ToolButton { action: editAction; tooltip: ""; visible: addressBookView.isActive }
            ToolButton { action: removeAction; tooltip: ""; visible: addressBookView.isActive }
            Item { Layout.fillWidth: true }
            ToolButton { action: aboutAction; tooltip: ""; visible: !aboutView.isActive }
        }
    }

    AddressBookModel {
        id: addressBookModel
    }

    StackView {
        id: viewStack
        initialItem: addressBookView
        anchors.fill: parent;

        AboutView {
            readonly property bool isActive: Stack.status == Stack.Active
            id: aboutView
            visible: Stack.status === Stack.Active
            aboutText: qsTr("QtQuick addressbook example for Squish/Qt")
        }

        AddressBookView {
            readonly property bool isActive: Stack.status == Stack.Active
            id: addressBookView;
            model: addressBookModel
            visible: Stack.status === Stack.Active
            onDoubleClicked: editAction.trigger()
        }

        EditView {
            readonly property bool isActive: Stack.status == Stack.Active
            id: editView;
            modelElement: addressBookView.currentRow != -1 ? addressBookModel.get(addressBookView.currentRow) : null;
            visible: Stack.status === Stack.Active
        }
    }
}
