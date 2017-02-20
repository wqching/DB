# encoding: UTF-8
require 'squish'

include Squish

def doFileOpen(path_and_filename)
  chooseMenuOptionByKey("File", "F", "o")
  waitForObject(":fileNameEdit_QLineEdit")
  components = path_and_filename.split("/")
  components.each do |component|
    type(":fileNameEdit_QLineEdit", component)
    waitForObject(":fileNameEdit_QLineEdit")
    type(":_QListView", "<Return>")
  end
end

def chooseMenuOptionByKey(menuTitle, menuKey, optionKey)
  windowName = "{type='MainWindow' unnamed='1' visible='1' " +
  "windowTitle?='CSV Table*'}"
  waitForObject(windowName)
  type(windowName, "<Alt+#{menuKey}>")
  menuName = "{title='#{menuTitle}' type='QMenu' unnamed='1' " +
  "visible='1'}"
  waitForObject(menuName)
  type(menuName, optionKey)
end

def compareTableWithDataFile(tableWidget, filename)
  TestData.dataset(filename).each_with_index do
    |record, row|
    for column in 0...TestData.fieldNames(record).length
      tableItem = tableWidget.item(row, column)
      Test.compare(TestData.field(record, column), tableItem.text())
    end
  end
end

def chooseActionByShortcut(shortcut) # e.g., shortcut="<Ctrl+O>"
  tableName = "{type='QTableWidget' unnamed='1' visible='1'}"
  waitForObject(tableName)
  type(tableName, shortcut)
end

def getObjectByType(obj, type_name, indent="")
  children = obj.children()
  0.upto(children.count()) do |i|
    child = children.at(i)
    meta_object = child.metaObject()
    Test.log("|" + indent + meta_object.className())
    if meta_object.className() == type_name
      return child
    else
      child = getObjectByType(child, type_name, indent + "    ")
      if child != nil
        return child
      end
    end
  end
end
