function checkAnItem(indent, item, root)
{
    if (indent > -1) {
        var checked = "";
        var selected = "";
        if (item.checkState(0) == Qt.Checked) {
            checked = " +checked";
        }
        if (item.isSelected()) {
            selected = " +selected";
        }
        var pad = "";
        for (var i = 0; i < indent; ++i) {
            pad += " ";
        }
        test.log("|" + pad + "'" + item.text(0) + "'" + checked +
            selected);
    }
    else {
        indent = -4;
    }
    // Only show visible child items
    if (item != root && item.isExpanded() || item == root) {
        for (var row = 0; row < item.childCount(); ++row) {
            checkAnItem(indent + 4, item.child(row), root);
        }
    }
}

function main()
{
    startApplication("itemviews");
    var treeWidgetName = "{type='QTreeWidget' unnamed='1' visible='1'}";
    var treeWidget = waitForObject(treeWidgetName);
    var root = treeWidget.invisibleRootItem();
    checkAnItem(-1, root, root);
}
