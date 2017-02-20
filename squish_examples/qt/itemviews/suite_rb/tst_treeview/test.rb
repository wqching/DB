# encoding: UTF-8
require 'squish'

include Squish

def checkAnItem(indent, index, treeView, model, selectionModel)
  if indent > -1 and index.isValid()
    text = model.data(index).toString()
    checked = selected = ""
    checkState = model.data(index, Qt::CHECK_STATE_ROLE).toInt()
    if checkState == Qt::CHECKED
      checked = " +checked"
    end
    if selectionModel.isSelected(index)
      selected = " +selected"
    end
    Test.log("|%s'#{text}'#{checked}#{selected}" % (" " * indent))
  else
    indent = -4
  end
  # Only show visible child items
  if index.isValid() and treeView.isExpanded(index) or not index.isValid()
    for row in 0...model.rowCount(index)
      checkAnItem(indent + 4, model.index(row, 0, index), treeView, model, selectionModel)
    end
  end
end

def main
  startApplication("itemviews")
  treeViewName = "{type='QTreeView' unnamed='1' visible='1'}"
  treeView = waitForObject(treeViewName)
  model = treeView.model()
  selectionModel = treeView.selectionModel()
  checkAnItem(-1, QModelIndex.new, treeView, model, selectionModel)
end
