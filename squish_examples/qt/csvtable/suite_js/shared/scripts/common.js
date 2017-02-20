function doFileOpen(path_and_filename) {
    chooseMenuOptionByKey("File", "F", "o");
    mouseClick(waitForObject(":CSV Table - Choose File_Edit"), 162, 7, MouseButton.PrimaryButton);
    mouseClick(waitForObject(":CSV Table - Choose File_Edit"), 205, 13, MouseButton.PrimaryButton);

    waitForObject(":fileNameEdit_QLineEdit");
    components = path_and_filename.split("/");
    for (var i = 0; i < components.length; ++i) {
        type(":fileNameEdit_QLineEdit", components[i]);
        waitForObject(":fileNameEdit_QLineEdit");
        type(":fileNameEdit_QLineEdit", "<Return>");
    }
}

function chooseMenuOptionByKey(menuTitle, menuKey, optionKey) {
    windowName = "{type='MainWindow' unnamed='1' visible='1' " + "windowTitle?='CSV Table*'}";
    waitForObject(windowName);
    type(windowName, "<Alt+" + menuKey + ">");
    menuName = "{title='" + menuTitle + "' type='QMenu' unnamed='1' " + "visible='1'}";
    waitForObject(menuName);
    type(menuName, optionKey);
}

function compareTableWithDataFile(tableWidget, filename) {
    records = testData.dataset(filename);
    for (var row = 0; row < records.length; ++row) {
        columnNames = testData.fieldNames(records[row]);
        for (var column = 0; column < columnNames.length; ++column) {
            tableItem = tableWidget.item(row, column);
            test.compare(testData.field(records[row], column),
                tableItem.text());
        }
    }    
}


