# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will loop through the table header and print out each column header. 

def main(): 
    # Setup.  We first need to get to the correct tab in our test application
    tabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar"
    waitForObject(tabWidgetName)
    clickTab(tabWidgetName, "Table")
    # We should now be on the "Table" tab

    widgetName = ":A standard table control_QTableWidget"

    obj_QTableWidget = findObject(widgetName)

    obj_QAbstractItemModel = obj_QTableWidget.model()
    columnCount = obj_QAbstractItemModel.columnCount()
    test.log("The number of columns is %d" % columnCount)

    for column in range(columnCount):
        obj_QHeaderView = obj_QTableWidget.horizontalHeader()
        section = obj_QHeaderView.logicalIndex(column)
        test.log("The section is %s" % section)
        sHeaderData = obj_QAbstractItemModel.headerData(section, Qt.Horizontal)
        sHeaderString = sHeaderData.toString()
        test.log("The string for the header is %s" % sHeaderString)
