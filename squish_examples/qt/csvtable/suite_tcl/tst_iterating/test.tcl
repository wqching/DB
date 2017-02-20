proc main {} {
    startApplication "csvtable"
    source [findFile "scripts" "common.tcl"]
    # Populate the table with some data
    set tableWidget [waitForObject {{type='QTableWidget' \
        unnamed='1' visible='1'}}]
    invoke $tableWidget setRowCount 4
    invoke $tableWidget setColumnCount 3
    set count 0
    for {set row 0} {$row < [property get $tableWidget rowCount]} \
        {incr row} {
    	for {set column 0} {$column < [property get $tableWidget \
            columnCount]} {incr column} {
    	    set tableItem [construct QTableWidgetItem "Item $count"]
                incr count
                if {$column == 2} {
                    invoke $tableItem setCheckState [enum Qt Unchecked]
                    if {$row == 1 || $row == 3} {
                        invoke $tableItem setCheckState \
                            [enum Qt Checked]
                    }
                }
                invoke $tableWidget setItem $row $column $tableItem
                if {$count == 6 || $count == 10} {
    		invoke $tableItem setSelected 1
                }
    	}
    }
    invoke $tableWidget setRowHidden 2 true
    # Iterate over all the table's items and print their text and 
    # state to the log
    set tableWidget [waitForObject {{type='QTableWidget' \
        unnamed='1' visible='1'}}]
    for {set row 0} {$row < [property get $tableWidget rowCount]} \
        {incr row} {
    	if {[invoke $tableWidget isRowHidden $row]} {
                test log "Skipping hidden row $row"
    	    continue
    	}
    	for {set column 0} {$column < [property get $tableWidget \
            columnCount]} {incr column} {
    	    set tableItem [invoke $tableWidget item $row $column]
            set text [toString [invoke $tableItem text]]
            set checked ""
            set selected ""
            if {[invoke $tableItem checkState] == [enum Qt Checked]} {
                set checked " +checked"
            }
            if {[invoke $tableItem isSelected]} {
                set selected " +selected"
            }
            test log "($row, $column) '$text'$checked$selected"
        }
    }
}
