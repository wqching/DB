function main()
{
    startApplication("itemviews");
    var tableViewName = "{type='QTableView' unnamed='1' visible='1'}";
    var tableView = waitForObject(tableViewName);
    var model = tableView.model();
    var selectionModel = tableView.selectionModel();
    for (var row = 0; row < model.rowCount(); ++row) {
        for (var column = 0; column < model.columnCount(); ++column) {
            var index = model.index(row, column);
            var text = model.data(index).toString();
            var checked = "";
            var selected = "";
            var checkState = model.data(index, Qt.CheckStateRole).toInt();
            if (checkState == Qt.Checked) {
                checked = " +checked";
            }
            if (selectionModel.isSelected(index)) {
                selected = " +selected";
            }
            test.log("(" + String(row) + ", " + String(column) + ") '" +
                     text + "'" + checked + selected);
        }
    }
}
