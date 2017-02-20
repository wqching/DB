# encoding: UTF-8
require 'squish'

include Squish

def main
  startApplication("itemviews")
  tableViewName = "{type='QTableView' unnamed='1' visible='1'}"
  tableView = waitForObject(tableViewName)
  model = tableView.model()
  selectionModel = tableView.selectionModel()
  for row in 0...model.rowCount()
    for column in 0...model.columnCount()
      index = model.index(row, column)
      text = model.data(index).toString()
      checked = selected = ""
      checkState = model.data(index, Qt::CHECK_STATE_ROLE).toInt()
      if checkState == Qt::CHECKED
        checked = " +checked"
      end
      if selectionModel.isSelected(index)
        selected = " +selected"
      end
      Test.log("(#{row}, #{column}) '#{text}'#{checked}#{selected}")
    end
  end
end
