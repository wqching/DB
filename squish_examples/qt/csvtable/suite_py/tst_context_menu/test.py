def main():
    startApplication("csvtable")
    waitForObject(":CSV Table.File_QTableWidget")
    openContextMenu(":CSV Table.File_QTableWidget", 400, 168, 2)
    contextMenu = waitForObject(":CSV Table.File_QMenu_2")
    actions = contextMenu.actions()
    for i in range(actions.count()):
        action = actions.at(i)
        if action.text == "Disabled":
            if action.isEnabled():
                test.fail("disabled menu item isn't disabled")
            else:
                test.passes("disabled menu item is disabled")
        else:
            test.passes("%s is enabled" % action.text)
    activateItem(":CSV Table.File_QMenu_2", "Append Row")
    waitForObject(":CSV Table_QMenuBar")
    activateItem(":CSV Table_QMenuBar", "File")
    waitForObject(":CSV Table.File_QMenu")
    activateItem(":CSV Table.File_QMenu", "Quit")
    waitForObject(":CSV Table.No_QPushButton")
    clickButton(":CSV Table.No_QPushButton")

