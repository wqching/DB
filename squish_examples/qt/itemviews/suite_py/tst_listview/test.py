def main():
    startApplication("itemviews")
    listViewName = "{type='QListView' unnamed='1' visible='1'}"
    listView = waitForObject(listViewName)
    model = listView.model()
    selectionModel = listView.selectionModel()
    for row in range(model.rowCount()):
        index = model.index(row, 0)
        text = model.data(index).toString()
        checked = selected = ""
        checkState = model.data(index, Qt.CheckStateRole).toInt()
        if checkState == Qt.Checked:
            checked = " +checked"
        if selectionModel.isSelected(index):
            selected = " +selected"
        test.log("(%d) '%s'%s%s" % (row, text, checked, selected))