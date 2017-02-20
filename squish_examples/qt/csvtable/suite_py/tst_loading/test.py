def main():
    startApplication("csvtable")
    source(findFile("scripts", "common.py"))
    doFileOpen("suite_py/shared/testdata/before.csv")
    tableWidget = waitForObject("{type='QTableWidget' " +
                                "unnamed='1' visible='1'}")
    compareTableWithDataFile(tableWidget, "before.csv")
