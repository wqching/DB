// This test case will use the demo Qt4 application called widgets from the squish distribution.
// You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
//
// The test case will loop through the table header and print out each column header. 

function main() 
{
    // Setup.  We first need to get to the correct tab in our test application
    var sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject(sTabWidgetName);
    clickTab(sTabWidgetName, "Table");
    // We should now be on the "Table" tab

    var sWidgetName = ":A standard table control_QTableWidget";

    var obj_QTableWidget = findObject(sWidgetName);

    var obj_QAbstractItemModel = obj_QTableWidget.model();
    var iNumberOfColumns = obj_QAbstractItemModel.columnCount();
    test.log("The number of columns is " + iNumberOfColumns);

    i = 0;
    while (i < iNumberOfColumns)
    {
        var obj_QHeaderView = obj_QTableWidget.horizontalHeader();
        var sSection = obj_QHeaderView.logicalIndex(i);
        test.log("The section is " + sSection);
        var sHeaderData = obj_QAbstractItemModel.headerData(sSection, Qt.Horizontal);
        var sHeaderString = sHeaderData.toString();
        test.log("The string for the header is " + sHeaderString);
        i++;
    }
}
