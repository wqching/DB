import __builtin__

FORENAME, SURNAME, EMAIL, PHONE = range(4)

def chooseMenuItem(menu, item):
    activateItem(waitForObjectItem(":Address Book_QMenuBar", menu))
    activateItem(waitForObjectItem(":Address Book.%s_QMenu" % menu, item))
    
def addAddress(forename, surname, email, phone):
    oldRowCount = getRowCount()
    chooseMenuItem("Edit", "Add...")
    type(waitForObject(":Forename:_LineEdit"), forename)
    type(waitForObject(":Surname:_LineEdit"), surname)
    type(waitForObject(":Email:_LineEdit"), email)
    type(waitForObject(":Phone:_LineEdit"), phone)
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
    newRowCount = getRowCount()
    test.verify(oldRowCount + 1 == newRowCount, "row count")
    row = oldRowCount # The first item is inserted at row 0;
    if row > 0:       # subsequent ones at row rowCount - 1
        row -= 1
    checkTableRow(row, forename, surname, email, phone)
    
def removeAddress(email):
    tableWidget = waitForObject(
        ":Address Book - Unnamed.File_QTableWidget")
    oldRowCount = getRowCount()
    for row in range(oldRowCount):
        if tableWidget.item(row, EMAIL).text() == email:
            tableWidget.setCurrentCell(row, EMAIL)
            chooseMenuItem("Edit", "Remove...")
            clickButton(waitForObject(
                ":Address Book - Delete.Yes_QPushButton"))
            test.log("Removed %s" % email)
            break
    newRowCount = getRowCount()
    test.verify(oldRowCount - 1 == newRowCount, "row count")

def verifyRowCount(rows):
    test.verify(__builtin__.int(rows) == getRowCount(), "row count")
    
def getRowCount():
    tableWidget = waitForObject(
            ":Address Book - Unnamed.File_QTableWidget")
    return tableWidget.rowCount

def checkTableRow(row, forename, surname, email, phone):
    tableWidget = waitForObject(
            ":Address Book - Unnamed.File_QTableWidget")
    test.compare(forename, tableWidget.item(row, FORENAME).text(),
            "forename")
    test.compare(surname, tableWidget.item(row, SURNAME).text(), "surname")
    test.compare(email, tableWidget.item(row, EMAIL).text(), "email")
    test.compare(phone, tableWidget.item(row, PHONE).text(), "phone")
    
def terminate():
    chooseMenuItem("File", "Quit")
    clickButton(waitForObject(":Address Book.No_QPushButton"))
