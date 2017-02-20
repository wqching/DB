# encoding: UTF-8
require 'squish'
include Squish

def invokeMenuItem(menu, item)
  activateItem(waitForObjectItem("{type='QMenuBar' visible='true'}", menu))
  activateItem(waitForObjectItem("{type='QMenu' title='%s'}" % menu, item))
end
  
  
def addNameAndAddress(oneNameAndAddress)
  invokeMenuItem("Edit", "Add...")
  ["Forename", "Surname", "Email", "Phone"].each_with_index do
    |fieldName, index|
    text = oneNameAndAddress[index]
    type(waitForObject(":%s:_QLineEdit" % fieldName), text)
  end
  clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
end
    
    
def closeWithoutSaving
  invokeMenuItem("File", "Quit")
  clickButton(waitForObject(":Address Book.No_QPushButton"))
end


def main
  startApplication("addressbook")
  table = waitForObject(":Address Book_QTableWidget")
  invokeMenuItem("File", "New")
  Test.verify(table.rowCount == 0)
  data = [["Andy", "Beach", "andy.beach@nowhere.com", "555 123 6786"],
          ["Candy", "Deane", "candy.deane@nowhere.com", "555 234 8765"],
          ["Ed", "Fernleaf", "ed.fernleaf@nowhere.com", "555 876 4654"]]
  data.each do |oneNameAndAddress|
    addNameAndAddress(oneNameAndAddress)
  end
  waitForObject(table)
  Test.compare(table.rowCount, data.length, "table contains as many rows as added data")
  closeWithoutSaving
end
