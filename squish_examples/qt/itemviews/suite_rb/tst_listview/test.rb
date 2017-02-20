# encoding: UTF-8
require 'squish'

include Squish

def main
  startApplication("itemviews")
  listViewName = "{type='QListView' unnamed='1' visible='1'}"
  listView = waitForObject(listViewName)
  model = listView.model()
  selectionModel = listView.selectionModel()
  for row in 0...model.rowCount() do
    index = model.index(row, 0)
    text = model.data(index).toString()
    checked = selected = ""
    checkState = model.data(index, Qt::CHECK_STATE_ROLE).toInt()
    if checkState == Qt::CHECKED
      checked = " +checked"
    end
    if selectionModel.isSelected(index)
      selected = " +selected"
    end
    Test.log("(#{row}) '#{text}'#{checked}#{selected}")
  end
end
