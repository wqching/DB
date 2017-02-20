proc chooseMenuItem {menu item} {
    invoke activateItem [waitForObjectItem ":Address Book_QMenuBar" $menu]
    invoke activateItem [waitForObjectItem ":Address Book.${menu}_QMenu" $item]
}
    
proc addAddress {forename surname email phone} {
    set oldRowCount [getRowCount]
    chooseMenuItem "Edit" "Add..."
    invoke type [waitForObject ":Forename:_LineEdit"] $forename
    invoke type [waitForObject ":Surname:_LineEdit"] $surname
    invoke type [waitForObject ":Email:_LineEdit"] $email
    invoke type [waitForObject ":Phone:_LineEdit"] $phone
    invoke clickButton [waitForObject ":Address Book - Add.OK_QPushButton"]
    set newRowCount [getRowCount]
    test compare [expr {$oldRowCount + 1}] $newRowCount "row count"
    set row $oldRowCount
    if {$row > 0} {
        set row [expr {$row - 1}]
    }
    checkTableRow $row $forename $surname $email $phone
}
    
proc removeAddress {email} {
    set EMAIL 2
    set tableWidget [waitForObject \
        ":Address Book - Unnamed.File_QTableWidget"]
    set oldRowCount [getRowCount]
    for {set row 0} {$row < $oldRowCount} {incr row} {
        set text [toString [invoke [invoke $tableWidget item $row $EMAIL] text]]
        if {[string equal $text $email]} {
            invoke $tableWidget setCurrentCell $row $EMAIL
            chooseMenuItem "Edit" "Remove..."
            invoke clickButton [waitForObject \
                ":Address Book - Delete.Yes_QPushButton"]
            test log "Removed $email"
            break
        }
    }
    set newRowCount [getRowCount]
    test compare [expr {$oldRowCount - 1}] $newRowCount "row count"
}

proc verifyRowCount {rows} {
    test compare $rows [getRowCount] "row count"
}
    
proc getRowCount {} {
    set tableWidget [waitForObject \
            ":Address Book - Unnamed.File_QTableWidget"]
    return [property get $tableWidget rowCount]
}

proc checkTableRow {row forename surname email phone} {
    set FORENAME 0
    set SURNAME 1
    set EMAIL 2
    set PHONE 3
    set tableWidget [waitForObject \
            ":Address Book - Unnamed.File_QTableWidget"]
    set text [invoke [invoke $tableWidget item $row $FORENAME] text]
    test compare $forename $text "forename"
    set text [invoke [invoke $tableWidget item $row $SURNAME] text]
    test compare $surname $text "surname"
    set text [invoke [invoke $tableWidget item $row $EMAIL] text]
    test compare $email $text "email"
    set text [invoke [invoke $tableWidget item $row $PHONE] text]
    test compare $phone $text "phone"
}
    
proc terminate {} {
    chooseMenuItem "File" "Quit"
    invoke clickButton [waitForObject ":Address Book.No_QPushButton"]
}
