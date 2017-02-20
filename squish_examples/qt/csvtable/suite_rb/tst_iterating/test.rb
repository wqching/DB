# encoding: UTF-8
require 'squish'
include Squish

def main
  startApplication("csvtable")
  # Populate the table with some data
  tableWidget = waitForObject("{type='QTableWidget' " +
    "unnamed='1' visible='1'}")
  tableWidget.setRowCount(4)
  tableWidget.setColumnCount(3)
  count = 0
  0.upto(tableWidget.rowCount) do |row|
    0.upto(tableWidget.columnCount) do |column|
      tableItem = QTableWidgetItem.new("Item #{count}")
      count += 1
      if column == 2
        tableItem.setCheckState(Qt::UNCHECKED)
        if row == 1 or row == 3
          tableItem.setCheckState(Qt::CHECKED)
        end
      end
      tableWidget.setItem(row, column, tableItem)
      if count == 6 or count == 10
        tableItem.setSelected(true)
      end
    end
  end
  tableWidget.setRowHidden(2, true)
  # Iterate over all the table's items and print their text and
  # state to the log
  tableWidget = waitForObject("{type='QTableWidget' " +
    "unnamed='1' visible='1'}")
  0.upto(tableWidget.rowCount) do |row|
    if tableWidget.isRowHidden(row)
      Test.log("Skipping hidden row #{row}")
      next
    end
    0.upto(tableWidget.columnCount) do |column|
      tableItem = tableWidget.item(row, column)
      if tableItem == nil
        next
      end
      text = tableItem.text()
      checked = selected = ""
      if tableItem.checkState() == Qt::CHECKED
        checked = " +checked"
      end
      if tableItem.isSelected()
        selected = " +selected"
      end
      Test.log("(%d, %d) '%s'%s%s" % [row, column, text,
        checked, selected])
    end
  end
end
