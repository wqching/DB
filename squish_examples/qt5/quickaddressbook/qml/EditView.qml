/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GridLayout {
    columns: 2
    id: editViewRoot

    property var modelElement

    states: State {
        name: "save"
        when: editViewRoot.Stack.status == Stack.Deactivating && modelElement !== null
        PropertyChanges {
            target: modelElement
            explicit: true
            restoreEntryValues: false

            firstName: firstNameField.text
            lastName: lastNameField.text
            phoneNumber: phoneNumberField.text
            emailAddress: emailAddressField.text
        }
    }

    Label {
        text: qsTr("First Name:")
    }
    TextField {
        id: firstNameField
        text: modelElement ? modelElement.firstName : ""
        placeholderText: qsTr("First Name")
        Layout.fillWidth: true;
    }

    Label {
        text: qsTr("Last Name:")
    }
    TextField {
        id: lastNameField
        text: modelElement ? modelElement.lastName : ""
        placeholderText: "Last Name"
        Layout.fillWidth: true;
    }

    Label {
        text: qsTr("Telephone:")
    }
    TextField {
        id: phoneNumberField
        text: modelElement ? modelElement.phoneNumber : ""
        placeholderText: qsTr("Telephone Number")
        Layout.fillWidth: true;
    }

    Label {
        text: qsTr("Email Address:")
    }
    TextField {
        id: emailAddressField
        text: modelElement ? modelElement.emailAddress : ""
        placeholderText: qsTr("Email Address")
        Layout.fillWidth: true;
    }
}

