# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will loop through the table header and print out each column header. 

sub main 
{
    # Setup.  We first need to get to the correct tab in our test application
    my $sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject("$sTabWidgetName");
    clickTab("$sTabWidgetName", "Table");
    # We should now be on the "Table" tab

    my $sWidgetName = ":A standard table control_QTableWidget";

    my $obj_QTableWidget = findObject("$sWidgetName");

    my $obj_QAbstractItemModel = $obj_QTableWidget->model();
    my $iNumberOfColumns = $obj_QAbstractItemModel->columnCount();
    test::log("The number of columns is $iNumberOfColumns");

    my $i = 0;
    while ($i < $iNumberOfColumns)
    {
        my $obj_QHeaderView = $obj_QTableWidget->horizontalHeader();
        my $sSection = $obj_QHeaderView->logicalIndex($i);
        test::log("The section is $sSection");
        my $sHeaderData = $obj_QAbstractItemModel->headerData("$sSection", Qt::Horizontal);
        my $sHeaderString = $sHeaderData->toString();
        test::log("The string for the header is $sHeaderString");
        $i++;
    }
}
