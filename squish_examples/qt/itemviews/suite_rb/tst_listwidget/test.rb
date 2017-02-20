# encoding: UTF-8
require 'squish'

include Squish

def main
  startApplication("itemviews")
  listWidgetName = "{type='QListWidget' unnamed='1' visible='1'}"
  listWidget = waitForObject(listWidgetName)
  for row in 0...listWidget.count do
    item = listWidget.item(row)
    checked = selected = ""
    if item.checkState() == Qt::CHECKED
      checked = " +checked"
    end
    if item.isSelected()
      selected = " +selected"
    end
    Test.log("(#{row}) '#{item.text()}'#{checked}#{selected}")
  end
end
