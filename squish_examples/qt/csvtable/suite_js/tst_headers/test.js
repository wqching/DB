function main()
{
    startApplication("csvtable");
    source(findFile("scripts", "common.js"));
    doFileOpen("suite_js/shared/testdata/before.csv");
    
    var tableWidget = waitForObject("{type='QTableWidget' " +
        "unnamed='1' visible='1'}");
    var horizontalHeader = tableWidget.horizontalHeader();
    var headerModel = horizontalHeader.model();
    for (var column = 0; column < headerModel.columnCount(); ++column) {
        var header = headerModel.headerData(column,
            Qt.Horizontal).toString();
        test.log(column + ": " + header);
    }
}
