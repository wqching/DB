def main():
    startApplication("csvtable")
    source(findFile("scripts", "common.py"))
    # Populate the table with some data
    tableWidget = waitForObject("{type='QTableWidget' " +
                                "unnamed='1' visible='1'}")
    tableWidget.setRowCount(4)
    tableWidget.setColumnCount(3)
    count = 0
    for row in range(tableWidget.rowCount):
        for column in range(tableWidget.columnCount):
            tableItem = QTableWidgetItem("Item %d" % count)
            count += 1
            if column == 2:
                tableItem.setCheckState(Qt.Unchecked)
                if row == 1 or row == 3:
                    tableItem.setCheckState(Qt.Checked)
            tableWidget.setItem(row, column, tableItem)
            if count in (6, 10):
                tableItem.setSelected(True)
    tableWidget.setRowHidden(2, True)
    # Iterate over all the table's items and print their text and
    # state to the log
    tableWidget = waitForObject("{type='QTableWidget' " +
                                "unnamed='1' visible='1'}")
    for row in range(tableWidget.rowCount):
        if tableWidget.isRowHidden(row):
            test.log("Skipping hidden row %d" % row)
            continue
        for column in range(tableWidget.columnCount):
            tableItem = tableWidget.item(row, column)
            text = unicode(tableItem.text())
            checked = selected = ""
            if tableItem.checkState() == Qt.Checked:
                checked = " +checked"
            if tableItem.isSelected():
                selected = " +selected"
            test.log("(%d, %d) '%s'%s%s" % (row, column, text,
                                            checked, selected))    
