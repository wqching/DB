function main()
{
    startApplication("itemviews");
    var tableViewName = "{type='QTableView' unnamed='1' visible='1'}";
    var tableView = waitForObject(tableViewName);
    var model = tableView.model();
    for (var row = 0; row < model.rowCount(); ++row) {
        for (var column = 0; column < model.columnCount(); ++column) {
            var index = model.index(row, column);
            var text = model.data(index).toString();
            var tooltip = model.data(index, Qt.ToolTipRole).toString();
            test.log("(" + String(row) + ", " + String(column) + 
                ") text='" + text + "' tooltip='" + tooltip + "'");
        }
    }
}

