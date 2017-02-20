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
    var data = new Array(
        new Array("Andy", "Beach", "andy.beach@nowhere.com", "555 123 6786"),
        new Array("Candy", "Deane", "candy.deane@nowhere.com", "555 234 8765"),
        new Array("Ed", "Fernleaf", "ed.fernleaf@nowhere.com", "555 876 4654"));
    for (var row = 0; row < data.length; ++row)
        addNameAndAddress(data[row]);
    waitForObject(table);
    test.compare(table.rowCount, data.length, "table contains as many rows as added data");
    closeWithoutSaving();
}

