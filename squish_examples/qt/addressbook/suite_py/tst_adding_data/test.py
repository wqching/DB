def invokeMenuItem(menu, item):
    activateItem(waitForObjectItem("{type='QMenuBar' visible='true'}", menu))
    activateItem(waitForObjectItem("{type='QMenu' title='%s'}" % menu, item))
     
    
def addNameAndAddress(oneNameAndAddress):
    invokeMenuItem("Edit", "Add...")
    for fieldName, text in zip(("Forename", "Surname", "Email", "Phone"), oneNameAndAddress):
        type(waitForObject(":%s:_QLineEdit" % fieldName), text)
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
        
        
def closeWithoutSaving():
    invokeMenuItem("File", "Quit")
    clickButton(waitForObject(":Address Book.No_QPushButton"))


def checkNameAndAddress(table, record):
    waitForObject(table)
    for column in range(len(testData.fieldNames(record))):
        test.compare(table.item(0, column).text(), # New addresses are inserted at the start
                     testData.field(record, column))

def main():
    startApplication("addressbook")
    table = waitForObject(":Address Book_QTableWidget")
    invokeMenuItem("File", "New")
    test.verify(table.rowCount == 0)
    limit = 10 # To avoid testing 100s of rows since that would be boring
    for row, record in enumerate(testData.dataset("MyAddresses.tsv")):
        forename = testData.field(record, "Forename")
        surname = testData.field(record, "Surname")
        email = testData.field(record, "Email")
        phone = testData.field(record, "Phone")
        table.setCurrentCell(0, 0) # always insert at the start
        addNameAndAddress((forename, surname, email, phone)) # pass as a single tuple
        checkNameAndAddress(table, record)
        if row > limit:
            break
    test.compare(table.rowCount, row + 1, "table contains as many rows as added data")
    closeWithoutSaving()
