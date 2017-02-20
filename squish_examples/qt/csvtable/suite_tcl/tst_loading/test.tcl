proc main {} {
    startApplication "csvtable"
    source [findFile "scripts" "common.tcl"]
    doFileOpen "suite_tcl/shared/testdata/before.csv"
    set tableWidget [waitForObject {{type='QTableWidget' \
        unnamed='1' visible='1'}}]
    compareTableWithDataFile $tableWidget "before.csv"
}
