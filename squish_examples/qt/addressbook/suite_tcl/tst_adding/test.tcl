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


proc main {} {
    startApplication "addressbook"
    set table [waitForObject ":Address Book_QTableWidget"]
    test compare [property get $table rowCount] 0
    invokeMenuItem "File" "New"
    set data [list \
        [list "Andy" "Beach" "andy.beach@nowhere.com" "555 123 6786"] \
        [list "Candy" "Deane" "candy.deane@nowhere.com" "555 234 8765"] \
        [list "Ed" "Fernleaf" "ed.fernleaf@nowhere.com" "555 876 4654"] ]
    for {set i 0} {$i < [llength $data]} {incr i} {
        addNameAndAddress [lindex $data $i]
    }
    waitForObject $table
    test compare [property get $table rowCount] [llength $data] "table contains as many rows as added data"
    closeWithoutSaving
}
