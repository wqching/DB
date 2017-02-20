function main()
{
    startApplication("csvtable");
    source(findFile("scripts", "common.js"));
    // Populate the table with some data
    var tableWidget = waitForObject("{type='QTableWidget' " +
        "unnamed='1' visible='1'}");
    tableWidget.setRowCount(4);
    tableWidget.setColumnCount(3);
    var count = 0;
    for (var row = 0; row < tableWidget.rowCount; ++row) {
        for (var column = 0; column < tableWidget.columnCount; ++column) {
            tableItem = new QTableWidgetItem("Item " + new String(count));
            ++count;
            if (column == 2) {
                tableItem.setCheckState(Qt.Unchecked);
                if (row == 1 || row == 3) {
                    tableItem.setCheckState(Qt.Checked);
                }
            }
            tableWidget.setItem(row, column, tableItem);
            if (count == 6 || count == 10) {
                tableItem.setSelected(true);
            }
        }
    }
    tableWidget.setRowHidden(2, true);
    // Iterate over all the table's items and print their text 
    // and state to the log
    tableWidget = waitForObject("{type='QTableWidget' " +
        "unnamed='1' visible='1'}");
    for (var row = 0; row < tableWidget.rowCount; ++row) {
        if (tableWidget.isRowHidden(row)) {
            test.log("Skipping hidden row " + String(row));
            continue;
        }
        for (var column = 0; column < tableWidget.columnCount; ++column) {
            tableItem = tableWidget.item(row, column);
            var text = new String(tableItem.text());
            var checked = "";
            var selected = "";
            if (tableItem.checkState() == Qt.Checked) {
                checked = " +checked";
            }
            if (tableItem.isSelected()) {
                selected = " +selected";
            }
            test.log("(" + String(row) + ", " + String(column) + ") '" +
                text + "' " + checked + selected);
        }
    }
}
