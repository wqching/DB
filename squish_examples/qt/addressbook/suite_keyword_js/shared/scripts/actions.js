var FORENAME = 0;
var SURNAME = 1;
var EMAIL = 2;
var PHONE = 3;

function chooseMenuItem(menu, item)
{
    activateItem(waitForObjectItem(":Address Book_QMenuBar", menu));
    activateItem(waitForObjectItem(":Address Book." + menu + "_QMenu",
                item));
}
    
function addAddress(forename, surname, email, phone)
{
    var oldRowCount = getRowCount();
    chooseMenuItem("Edit", "Add...");
    type(waitForObject(":Forename:_LineEdit"), forename);
    type(waitForObject(":Surname:_LineEdit"), surname);
    type(waitForObject(":Email:_LineEdit"), email);
    type(waitForObject(":Phone:_LineEdit"), phone);
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"));
    var newRowCount = getRowCount();
    test.verify(oldRowCount + 1 == newRowCount, "row count");
    var row = oldRowCount // The first item is inserted at row 0;
    if (row > 0) {        // subsequent ones at row rowCount - 1
        --row;
    }
    checkTableRow(row, forename, surname, email, phone);
}
    
function removeAddress(email) {
    tableWidget = waitForObject(
        ":Address Book - Unnamed.File_QTableWidget")
    var oldRowCount = getRowCount();
    for (var row = 0; row < oldRowCount; ++row) {
        if (tableWidget.item(row, EMAIL).text() == email) {
            tableWidget.setCurrentCell(row, EMAIL);
            chooseMenuItem("Edit", "Remove...");
            clickButton(waitForObject(
                    ":Address Book - Delete.Yes_QPushButton"))
            test.log("Removed " + email);
            break;
        }
    }
    var newRowCount = getRowCount();
    test.verify(oldRowCount - 1 == newRowCount, "row count");
}

function verifyRowCount(rows)
{
    rows = parseInt(rows)
    test.verify(rows == getRowCount(), "row count");
}
    
function getRowCount()
{
    tableWidget = waitForObject(
        ":Address Book - Unnamed.File_QTableWidget");
    return tableWidget.rowCount;
}

function checkTableRow(row, forename, surname, email, phone)
{
    tableWidget = waitForObject(
        ":Address Book - Unnamed.File_QTableWidget");
    test.compare(forename, tableWidget.item(row, FORENAME).text(),
        "forename");
    test.compare(surname, tableWidget.item(row, SURNAME).text(),
        "surname");
    test.compare(email, tableWidget.item(row, EMAIL).text(), "email");
    test.compare(phone, tableWidget.item(row, PHONE).text(), "phone");
}
    
function terminate()
{
    chooseMenuItem("File", "Quit");
    clickButton(waitForObject(":Address Book.No_QPushButton"));
}
