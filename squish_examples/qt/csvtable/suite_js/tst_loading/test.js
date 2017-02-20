function main()
{
    startApplication("csvtable");
    source(findFile("scripts", "common.js"));
    doFileOpen("suite_js/shared/testdata/before.csv");
    tableWidget = waitForObject("{type='QTableWidget' unnamed='1' " +
        "visible='1'}");
    compareTableWithDataFile(tableWidget, "before.csv");
}


