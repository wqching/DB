function main()
{
    startApplication("csvtable");
    waitForObject(":CSV Table.File_QTableWidget");
    type(":CSV Table.File_QTableWidget", "<Alt+F>");
    waitForObject(":CSV Table.File_QMenu");
    type(":CSV Table.File_QMenu", "o");

    type(":fileNameEdit_QLineEdit", "suite_js");    
    waitForObject(":_QListView");
    type(":_QListView", "<Down>");
    waitForObject(":_QListView");
    type(":_QListView", "<Return>");
    waitForObject(":fileNameEdit_QLineEdit");
    type(":fileNameEdit_QLineEdit", "s");
    waitForObject(":_QListView");
    type(":_QListView", "<Down>");
    waitForObject(":_QListView");
    type(":_QListView", "<Return>");
    waitForObject(":fileNameEdit_QLineEdit");
    type(":fileNameEdit_QLineEdit", "t");
    waitForObject(":_QListView");
    type(":_QListView", "<Down>");
    waitForObject(":_QListView");
    type(":_QListView", "<Return>");
    waitForObject(":fileNameEdit_QLineEdit");
    type(":fileNameEdit_QLineEdit", "b");
    waitForObject(":_QListView");
    type(":_QListView", "<Down>");
    waitForObject(":_QListView");
    type(":_QListView", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "d");
    waitForObject(":CSV Table - Delete Row.Yes_QPushButton");
    type(":CSV Table - Delete Row.Yes_QPushButton", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Down>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "d");
    waitForObject(":CSV Table - Delete Row.Yes_QPushButton");
    type(":CSV Table - Delete Row.Yes_QPushButton", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "d");
    waitForObject(":CSV Table - Delete Row.Yes_QPushButton");
    type(":CSV Table - Delete Row.Yes_QPushButton", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "i");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    doubleClickItem(":CSV Table - before.csv.File_QTableWidget", 
        "0/0", 16, 8, 0, Qt.LeftButton);
    waitForObject(":CSV Table - before.csv.0_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_0_QExpandingLineEdit", "CO");
    waitForObject(":CSV Table - before.csv.0_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_0_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.0_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_1_QExpandingLineEdit", "Primary");
    waitForObject(":CSV Table - before.csv.0_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_1_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.0_2_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_2_QExpandingLineEdit", "10 ppm");
    waitForObject(":CSV Table - before.csv.0_2_QExpandingLineEdit"); 
    type(":CSV Table - before.csv.0_2_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.0_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_3_QExpandingLineEdit", "1-hour");
    waitForObject(":CSV Table - before.csv.0_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_3_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.0_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_4_QExpandingLineEdit", 
        "test data #1");
    waitForObject(":CSV Table - before.csv.0_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.0_4_QExpandingLineEdit", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "a");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    doubleClickItem(":CSV Table - before.csv.File_QTableWidget",
        "10/0", 22, 20, 0, Qt.LeftButton);
    waitForObject(":CSV Table - before.csv.10_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_0_QExpandingLineEdit", "CO");
    waitForObject(":CSV Table - before.csv.10_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_0_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.10_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_1_QExpandingLineEdit", "Secondary");
    waitForObject(":CSV Table - before.csv.10_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_1_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.10_2_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_2_QExpandingLineEdit", "12 ppm");
    waitForObject(":CSV Table - before.csv.10_2_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_2_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.10_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_3_QExpandingLineEdit", "2-hour");
    waitForObject(":CSV Table - before.csv.10_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_3_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.10_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_4_QExpandingLineEdit",
        "test data #2");
    waitForObject(":CSV Table - before.csv.10_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.10_4_QExpandingLineEdit", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Up>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "i");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    doubleClickItem(":CSV Table - before.csv.File_QTableWidget", 
        "4/0", 29, 10, 0, Qt.LeftButton);
    waitForObject(":CSV Table - before.csv.4_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_0_QExpandingLineEdit", "CO");
    waitForObject(":CSV Table - before.csv.4_0_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_0_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.4_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_1_QExpandingLineEdit", "Primary");
    waitForObject(":CSV Table - before.csv.4_1_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_1_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.4_2_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_2_QExpandingLineEdit", "14 ppm");
    waitForObject(":CSV Table - before.csv.4_2_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_2_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.4_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_3_QExpandingLineEdit", "3-hour");
    waitForObject(":CSV Table - before.csv.4_3_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_3_QExpandingLineEdit", "<Tab>");
    waitForObject(":CSV Table - before.csv.4_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_4_QExpandingLineEdit", "test data #3");
    waitForObject(":CSV Table - before.csv.4_4_QExpandingLineEdit");
    type(":CSV Table - before.csv.4_4_QExpandingLineEdit", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "c");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns " +
        "to be swapped swapped_QLineEdit", "Pollutant,Averaging Time");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns to " +
        "be swapped swapped_QLineEdit", "<Return>");
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "c");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns " +
        "to be swapped swapped_QLineEdit", "Regulatory Citation,Type");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns " +
        "to be swapped swapped_QLineEdit", "<Return>");
    // Extra tests
    source(findFile("scripts", "common.js"));
    tableWidget = waitForObject("{type='QTableWidget' " +
        "unnamed='1' visible='1'}");
    test.verify(tableWidget.rowCount == 12);
    test.verify(tableWidget.columnCount == 5);
    // End of extra tests
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+E>");
    waitForObject(":CSV Table - before.csv.Edit_QMenu");
    type(":CSV Table - before.csv.Edit_QMenu", "c");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns " +
        "to be swapped swapped_QLineEdit", "Regulatory Citation,Standard");
    waitForObject(":Enter the comma-separated names of the two " +
        "columns to be swapped swapped_QLineEdit");
    type(":Enter the comma-separated names of the two columns " +
        "to be swapped swapped_QLineEdit", "<Return>");
    // Added by hand
    source(findFile("scripts", "common.js"));
    tableWidget = waitForObject("{type='QTableWidget' " +
        "unnamed='1' visible='1'}");
    compareTableWithDataFile(tableWidget, "after.csv");
    // End of added by hand
    waitForObject(":CSV Table - before.csv.File_QTableWidget");
    type(":CSV Table - before.csv.File_QTableWidget", "<Alt+F>");
    waitForObject(":CSV Table - before.csv.File_QMenu");
    type(":CSV Table - before.csv.File_QMenu", "q");
    waitForObject("{type='QPushButton' unnamed='1' text='No'}");
    clickButton("{type='QPushButton' unnamed='1' text='No'}");
}
