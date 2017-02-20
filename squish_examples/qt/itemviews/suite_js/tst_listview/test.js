function main()
{
    startApplication("itemviews");
    var listViewName = "{type='QListView' unnamed='1' visible='1'}";
    var listView = waitForObject(listViewName);
    var model = listView.model();
    var selectionModel = listView.selectionModel();
    for (var row = 0; row < model.rowCount(); ++row) {
        var index = model.index(row, 0);
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
        test.log("(" + String(row) + ") '" + text + "'" + checked +
            selected);
    }
}
