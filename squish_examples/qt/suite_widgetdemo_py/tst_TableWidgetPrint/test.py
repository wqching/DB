# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will loop through each item in a table widget and print out each cell. 

def main(): 
    # Setup.  We first need to get to the correct tab in our test application
    tabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar"
    waitForObject(tabWidgetName)
    clickTab(tabWidgetName, "Table")
    # We should now be on the "Table" tab

    widgetName = ":A standard table control_QTableWidget"

    waitForObject(widgetName)
    obj_QTableWidget = findObject(widgetName)
    obj_QAbstratItemModel = obj_QTableWidget.model()  
    rowCount = obj_QAbstratItemModel.rowCount()
    columnCount = obj_QAbstratItemModel.columnCount()

    test.log("The table has %d row(s)" % rowCount) 
    test.log("The table has %d column(s)" % columnCount)


    for row in range(rowCount):
        test.log("We are in row %d" % row)
        for column in range(columnCount):
            test.log("We are in column %d" % column)
            obj_QTableWidgetItem = obj_QTableWidget.item(row, column)
            keyColumnText = obj_QTableWidgetItem.text()
            test.log("The cell value at (%d,%d) is %s" % (row, column, keyColumnText))
