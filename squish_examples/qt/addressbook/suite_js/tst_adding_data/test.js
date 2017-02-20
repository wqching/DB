function invokeMenuItem(menu, item)
{
    activateItem(waitForObjectItem("{type='QMenuBar' visible='true'}", menu));
    activateItem(waitForObjectItem("{type='QMenu' title='" + menu + "'}", item));
}
    
    
function addNameAndAddress(oneNameAndAddress)
{
    invokeMenuItem("Edit", "Add...");
    var fieldNames = new Array("Forename", "Surname", "Email", "Phone");
    for (var i = 0; i < oneNameAndAddress.length; ++i) {
        var fieldName = fieldNames[i];
        var text = oneNameAndAddress[i];
        type(waitForObject(":" + fieldName + ":_QLineEdit"), text);
    }
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"));
}
        
        
function checkNameAndAddress(table, record)
{
    waitForObject(table);
    for (var column = 0; column < testData.fieldNames(record).length; ++column)
        test.compare(table.item(0, column).text(), // New addresses are inserted at the start
                     testData.field(record, column));
}


function closeWithoutSaving()
{
    invokeMenuItem("File", "Quit");
    clickButton(waitForObject(":Address Book.No_QPushButton"));
}


function main()
{
    startApplication("addressbook");
    var table = waitForObject(":Address Book_QTableWidget");
    invokeMenuItem("File", "New");
    test.verify(table.rowCount == 0);
    var limit = 10; // To avoid testing 100s of rows since that would be boring
    var records = testData.dataset("MyAddresses.tsv");
    for (var row = 0; row < records.length; ++row) {
        var record = records[row];
        var forename = testData.field(record, "Forename");
        var surname = testData.field(record, "Surname");
        var email = testData.field(record, "Email");
        var phone = testData.field(record, "Phone");
        table.setCurrentCell(0, 0); // always insert at the start
        addNameAndAddress(new Array(forename, surname, email, phone));
        checkNameAndAddress(table, record);
        if (row > limit)
            break;
    }
    test.compare(table.rowCount, row + 1, "table contains as many rows as added data");
    closeWithoutSaving();
}
