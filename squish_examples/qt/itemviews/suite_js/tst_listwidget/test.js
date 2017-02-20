function main()
{
    startApplication("itemviews");
    var listWidgetName = "{type='QListWidget' unnamed='1' visible='1'}";
    var listWidget = waitForObject(listWidgetName);
    for (var row = 0; row < listWidget.count; ++row) {
        var item = listWidget.item(row);
        var checked = "";
        var selected = "";
        if (item.checkState() == Qt.Checked) {
            checked = " +checked";
        }
        if (item.isSelected()) {
            selected = " +selected";
        }   
        test.log("(" + String(row) + ") '" + item.text() + "'" + 
            checked + selected);
    }
}
