# encoding: UTF-8
require 'squish'

include Squish

FORENAME = 0
SURNAME = 1
EMAIL = 2
PHONE = 3

def chooseMenuItem(menu, item)
  activateItem(waitForObjectItem(":Address Book_QMenuBar", menu))
  activateItem(waitForObjectItem(":Address Book.#{menu}_QMenu", item))
end

def addAddress(forename, surname, email, phone)
  oldRowCount = getRowCount()
  chooseMenuItem("Edit", "Add...")
  type(waitForObject(":Forename:_LineEdit"), forename)
  type(waitForObject(":Surname:_LineEdit"), surname)
  type(waitForObject(":Email:_LineEdit"), email)
  type(waitForObject(":Phone:_LineEdit"), phone)
  clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
  newRowCount = getRowCount()
  Test.verify(oldRowCount + 1 == newRowCount, "row count")
  row = oldRowCount # The first item is inserted at row 0;
  if row > 0        # subsequent ones at row rowCount - 1
    row -= 1
  end
  checkTableRow(row, forename, surname, email, phone)
end

def removeAddress(email)
  tableWidget = waitForObject(
  ":Address Book - Unnamed.File_QTableWidget")
  oldRowCount = getRowCount()
  for row in 0...oldRowCount
    if tableWidget.item(row, EMAIL).text() == email
      tableWidget.setCurrentCell(row, EMAIL)
      chooseMenuItem("Edit", "Remove...")
      clickButton(waitForObject(
      ":Address Book - Delete.Yes_QPushButton"))
      Test.log("Removed #{email}")
      break
    end
  end
  newRowCount = getRowCount()
  Test.verify(oldRowCount - 1 == newRowCount, "row count")
end

def verifyRowCount(rows)
  Test.verify(rows.to_i == getRowCount(), "row count")
end

def getRowCount
  tableWidget = waitForObject(
  ":Address Book - Unnamed.File_QTableWidget")
  tableWidget.rowCount
end

def checkTableRow(row, forename, surname, email, phone)
  tableWidget = waitForObject(
  ":Address Book - Unnamed.File_QTableWidget")
  Test.compare(forename, tableWidget.item(row, FORENAME).text(),
  "forename")
  Test.compare(surname, tableWidget.item(row, SURNAME).text(), "surname")
  Test.compare(email, tableWidget.item(row, EMAIL).text(), "email")
  Test.compare(phone, tableWidget.item(row, PHONE).text(), "phone")
end

def terminate
  chooseMenuItem("File", "Quit")
  clickButton(waitForObject(":Address Book.No_QPushButton"))
end
