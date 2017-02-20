# encoding: UTF-8
require 'squish'

include Squish

def checkAnItem(indent, item, root)
  if indent > -1
    checked = selected = ""
    if item.checkState(0) == Qt::CHECKED
      checked = " +checked"
    end
    if item.isSelected()
      selected = " +selected"
    end
    Test.log("|%s'#{item.text(0)}'#{checked}#{selected}" % (" " * indent))
  else
    indent = -4
  end
  # Only show visible child items
  if item != root and item.isExpanded() or item == root
    for row in 0...item.childCount()
      checkAnItem(indent + 4, item.child(row), root)
    end
  end
end

def main
  startApplication("itemviews")
  treeWidgetName = "{type='QTreeWidget' unnamed='1' visible='1'}"
  treeWidget = waitForObject(treeWidgetName)
  root = treeWidget.invisibleRootItem()
  checkAnItem(-1, root, root)
end
