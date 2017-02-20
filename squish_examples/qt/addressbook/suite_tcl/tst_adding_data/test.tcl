proc invokeMenuItem {menu item} {
    invoke activateItem [waitForObjectItem "{type='QMenuBar' visible='true'}" $menu]
    invoke activateItem [waitForObjectItem "{type='QMenu' title='$menu'}" $item]
}

proc addNameAndAddress {oneNameAndAddress} {
    invokeMenuItem "Edit" "Add..."
    set fieldNames [list "Forename" "Surname" "Email" "Phone"]
    for {set field 0} {$field < [llength $fieldNames]} {incr field} {
        set fieldName [lindex $fieldNames $field]
        set text [lindex $oneNameAndAddress $field]
        invoke type [waitForObject ":${fieldName}:_QLineEdit"] $text
    }
    invoke clickButton [waitForObject ":Address Book - Add.OK_QPushButton"]
}
        

proc closeWithoutSaving {} {
    invokeMenuItem "File" "Quit"
    invoke clickButton [waitForObject ":Address Book.No_QPushButton"]
}


proc checkNameAndAddress {table record} {
    waitForObject $table
    set columns [llength [testData fieldNames $record]]
    for {set column 0} {$column < $columns} {incr column} {
        set value [invoke [invoke $table item 0 $column] text]
        test compare $value [testData field $record $column]
    }
}


proc main {} {
    startApplication "addressbook"
    set table [waitForObject ":Address Book_QTableWidget"]
    test compare [property get $table rowCount] 0
    invokeMenuItem "File" "New"
    set limit 10
    set data [testData dataset "MyAddresses.tsv"]
    set columns [llength [testData fieldNames [lindex $data 0]]]
    set row 0
    for {} {$row < [llength $data]} {incr row} {
        set record [lindex $data $row]
        set forename [testData field $record "Forename"]
        set surname [testData field $record "Surname"]
        set email [testData field $record "Email"]
        set phone [testData field $record "Phone"]
        set details [list $forename $surname $email $phone]
        invoke $table setCurrentCell 0 0
        addNameAndAddress $details
        checkNameAndAddress $table $record
        if {$row > $limit} {
            break
        }
    }
    test compare [property get $table rowCount] [expr $row + 1]
    closeWithoutSaving
}
