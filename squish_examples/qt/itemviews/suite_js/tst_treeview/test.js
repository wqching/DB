function checkAnItem(indent, index, treeView, model, selectionModel)
{
    if (indent > -1 && index.isValid()) {
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
        var pad = "";
        for (var i = 0; i < indent; ++i) {
            pad += " ";
        }
        test.log("|" + pad + "'" + text + "'" + checked + selected);
    }
    else {
        indent = -4;
    }
    // Only show visible child items
    if (index.isValid() && treeView.isExpanded(index) ||
            !index.isValid()) {
        for (var row = 0; row < model.rowCount(index); ++row) {
            checkAnItem(indent + 4, model.index(row, 0, index), 
                treeView, model, selectionModel);
        }
    }
}

function main()
{
    startApplication("itemviews");
    var treeViewName = "{type='QTreeView' unnamed='1' visible='1'}";
    var treeView = waitForObject(treeViewName);
    var model = treeView.model();
    var selectionModel = treeView.selectionModel();
    checkAnItem(-1, new QModelIndex(), treeView, model, selectionModel);
}
