def main():
    startApplication("itemviews")
    listWidgetName = "{type='QListWidget' unnamed='1' visible='1'}"
    listWidget = waitForObject(listWidgetName)
    for row in range(listWidget.count):
        item = listWidget.item(row)
        checked = selected = ""
        if item.checkState() == Qt.Checked:
            checked = " +checked"
        if item.isSelected():
            selected = " +selected"
        test.log("(%d) '%s'%s%s" % (row, item.text(), checked, selected))