proc doFileOpen {path_and_filename} {
    chooseMenuOptionByKey "File" "F" "o"
    waitForObject ":fileNameEdit_QLineEdit"
    set components [split $path_and_filename "/"]
    foreach component $components {
        invoke type ":fileNameEdit_QLineEdit" $component
        waitForObject ":fileNameEdit_QLineEdit"
	invoke type ":fileNameEdit_QLineEdit" "<Return>"
    }
}
    

proc chooseMenuOptionByKey {menuTitle menuKey optionKey} {
    set windowName "{type='MainWindow' unnamed='1' visible='1' \
        windowTitle?='CSV Table*'}"
    waitForObject $windowName
    invoke type $windowName "<Alt+$menuKey>"
    set menuName "{title='$menuTitle' type='QMenu' unnamed='1' \
        visible='1'}"
    waitForObject $menuName
    invoke type $menuName $optionKey
}

    
proc compareTableWithDataFile {tableWidget filename} {
    set data [testData dataset $filename]
    for {set row 0} {$row < [llength $data]} {incr row} {
	set columnNames [testData fieldNames [lindex $data $row]]
	for {set column 0} {$column < [llength $columnNames]} {incr column} {
            set tableItem [invoke $tableWidget item $row $column]
            test compare [testData field [lindex $data $row] $column] \
                [invoke $tableItem text]
	}
    }
}
