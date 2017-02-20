
function addContact(firstName, lastName, phoneNumber, emailAddress) {
    mouseClick(waitForObject(":Add_Button"));

    // Focus first input field
    mouseClick(waitForObject(":editView.firstNameField_TextField"));

    type(waitForObject(":editView.textInput_TextInput"), firstName);
    type(waitForObject(":editView.textInput_TextInput"), "<Tab>");
    type(waitForObject(":editView.textInput_TextInput_2"), lastName);
    type(waitForObject(":editView.textInput_TextInput_2"), "<Tab>");
    type(waitForObject(":editView.textInput_TextInput_3"), phoneNumber);
    type(waitForObject(":editView.textInput_TextInput_3"), "<Tab>");
    type(waitForObject(":editView.textInput_TextInput_4"), emailAddress);

    mouseClick(waitForObject(":Back_Button"));
}

function main() {
    startApplication("quickaddressbook");

    var table = waitForObject(":addressBookView.listView_ListView");

    test.verify(table.count == 2);
    addContact("First","Last","+49 40 12 34 56","email@address");
    test.verify(table.count == 3);

    closeWindow(":Quick Addressbook_QQuickWindowQmlImpl");
}

