// This test case will use the demo Qt4 application called widgets from the squish distribution.
// You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
//
// The test case will loop through each item in a table widget and print out each cell. 

function main()
{
    // Setup.  We first need to get to the correct tab in our test application
    var sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject(sTabWidgetName);
    clickTab(sTabWidgetName, "Table");
    // We should now be on the "Table" tab

    var sWidgetName = ":A standard table control_QTableWidget";

    waitForObject(sWidgetName);
    var obj_QTableWidget = findObject(sWidgetName);
    var obj_QAbstratItemModel = obj_QTableWidget.model();  
    var iRowCount = obj_QAbstratItemModel.rowCount();
    var iColumnCount = obj_QAbstratItemModel.columnCount();

    test.log("The table has " + iRowCount + " row(s)"); 
    test.log("The table has " + iColumnCount + " column(s)");

    // Lets loop through all the rows.    
    var i = 0;
    while (i < iRowCount)
    {
        test.log("We are in row " + i);
        // Lets loop through each column in each row
        var j = 0;
        while (j < iColumnCount)
        {
            test.log("We are in column " + j);
            var obj_QTableWidgetItem = obj_QTableWidget.item(i,j);
            var sKeyColumnText = obj_QTableWidgetItem.text();

            test.log("The cell value at (" + i + "," + j + ") is " + sKeyColumnText);
            j++;
        }
        i++;
    }
}
