def main():
    startApplication("itemviews")
    tableViewName = "{type='QTableView' unnamed='1' visible='1'}"
    tableView = waitForObject(tableViewName)
    model = tableView.model()
    selectionModel = tableView.selectionModel()
    for row in range(model.rowCount()):
        for column in range(model.columnCount()):
            index = model.index(row, column)
            text = model.data(index).toString()
            checked = selected = ""
            checkState = model.data(index, Qt.CheckStateRole).toInt()
            if checkState == Qt.Checked:
                checked = " +checked"
            if selectionModel.isSelected(index):
                selected = " +selected"
            test.log("(%d, %d) '%s'%s%s" % (row, column, text, checked,
                                            selected))
