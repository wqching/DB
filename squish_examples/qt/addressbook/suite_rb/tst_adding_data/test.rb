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
    
def checkNameAndAddress(table, record)
  waitForObject(table)
  for column in 0...TestData.fieldNames(record).length
    Test.compare(table.item(0, column).text(),
		             TestData.field(record, column))
    # New addresses are inserted at the start
  end
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
  limit = 10 # To avoid testing 100s of rows since that would be boring
  rows = 0
  TestData.dataset("MyAddresses.tsv").each_with_index do
      |record, row|
    forename = TestData.field(record, "Forename")
    surname = TestData.field(record, "Surname")
    email = TestData.field(record, "Email")
    phone = TestData.field(record, "Phone")
    table.setCurrentCell(0, 0) # always insert at the start
    addNameAndAddress([forename, surname, email, phone]) # pass as a single Array
    checkNameAndAddress(table, record)
    break if row > limit
    rows += 1
  end
  Test.compare(table.rowCount, rows + 1, "table contains as many rows as added data")
  closeWithoutSaving
end
