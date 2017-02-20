def doFileOpen(path_and_filename):
    chooseMenuOptionByKey("File", "F", "o")
    waitForObject(":fileNameEdit_QLineEdit")
    components = path_and_filename.split("/")
    for component in components:
        type(":fileNameEdit_QLineEdit", component)
        waitForObject(":fileNameEdit_QLineEdit")
        type(":_QListView", "<Return>")
    

def chooseMenuOptionByKey(menuTitle, menuKey, optionKey):
    windowName = ("{type='MainWindow' unnamed='1' visible='1' "
                  "windowTitle?='CSV Table*'}")
    waitForObject(windowName)
    type(windowName, "<Alt+%s>" % menuKey)
    menuName = ("{title='%s' type='QMenu' unnamed='1' " +
                "visible='1'}") % menuTitle
    waitForObject(menuName)
    type(menuName, optionKey)

    
def compareTableWithDataFile(tableWidget, filename):
    for row, record in enumerate(testData.dataset(filename)):
        for column, name in enumerate(testData.fieldNames(record)):
            tableItem = tableWidget.item(row, column)
            test.compare(testData.field(record, name), tableItem.text())

    
def chooseActionByShortcut(shortcut): # e.g., shortcut="<Ctrl+O>"
    tableName = "{type='QTableWidget' unnamed='1' visible='1'}"
    waitForObject(tableName)
    type(tableName, shortcut)
    

def getObjectByType(obj, type_name, indent=u""):
    children = obj.children()
    for i in range(children.count()):
        child = children.at(i)
        meta_object = child.metaObject()
        test.log("|" + indent + meta_object.className())
        if meta_object.className() == unicode(type_name):
            return child
        else:
            child = getObjectByType(child, type_name, indent + u"    ")
            if child is not None:
                return child
    return None
