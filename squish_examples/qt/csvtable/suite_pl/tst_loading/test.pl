sub main
{
    startApplication("csvtable");
    source(findFile("scripts", "common.pl"));
    doFileOpen("suite_pl/shared/testdata/before.csv");
    my $tableWidget = waitForObject("{type='QTableWidget' " .
        "unnamed='1' visible='1'}");
    compareTableWithDataFile($tableWidget, "before.csv");
}
