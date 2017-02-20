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


def main():
    startApplication("addressbook")
    table = waitForObject(":Address Book_QTableWidget")
    invokeMenuItem("File", "New")
    test.verify(table.rowCount == 0)
    data = [("Andy", "Beach", "andy.beach@nowhere.com", "555 123 6786"),
            ("Candy", "Deane", "candy.deane@nowhere.com", "555 234 8765"),
            ("Ed", "Fernleaf", "ed.fernleaf@nowhere.com", "555 876 4654")]
    for oneNameAndAddress in data:
        addNameAndAddress(oneNameAndAddress)
    waitForObject(table);
    test.compare(table.rowCount, len(data), "table contains as many rows as added data")
    closeWithoutSaving()
