/*
    Copyright (c) 2013 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

import QtQuick 2.1

ListModel {
    ListElement {
        firstName: "Tommy";
        lastName: "Tester"
        emailAddress: "tommy@example.com"
        phoneNumber: "+1 23 45 67"
    }
    ListElement {
        firstName: "Daryl"
        lastName: "Tester"
        emailAddress: "daryl@example.com"
        phoneNumber: "+66 77 88 99"
    }

    function getEmptyAddressBookEntry()
    {
        return { firstName: "", lastName: "", emailAddress: "", phoneNumber: "" };
    }

    function appendNewAddressBookEntry()
    {
        append(getEmptyAddressBookEntry());
        return count - 1;
    }
}
