
Given "addressbook application is running" {context} {
    startApplication "addressbook"
    waitFor {object exists ":Address Book_MainWindow"} 20000
    test compare [property get [findObject ":Address Book_MainWindow"] enabled] true
}

When "I create a new addressbook" {context} {
    invoke clickButton [waitForObject ":Address Book.New_QToolButton"]
}

Then "addressbook should be empty" {context} {
    waitFor {object exists ":Address Book - Unnamed.File_QTableWidget"} 20000
    test compare [property get [findObject ":Address Book - Unnamed.File_QTableWidget"] rowCount] 0
}

When "I add a new person '|word|','|word|','|any|','|integer|' to address book" {context forename surname email phone} {
    invoke clickButton [waitForObject ":Address Book - Unnamed.Add_QToolButton"]
    invoke type [waitForObject ":Forename:_LineEdit"] $forename
    invoke type [waitForObject ":Surname:_LineEdit"] $surname
    invoke type [waitForObject ":Email:_LineEdit"] $email
    invoke type [waitForObject ":Phone:_LineEdit"] $phone
    invoke clickButton [waitForObject ":Address Book - Add.OK_QPushButton"]
    $context userData [dict create forename $forename surname $surname]
}

Then "'|integer|' entries should be present" {context num} {
   waitFor {object exists ":Address Book - Unnamed.File_QTableWidget"} 20000
   test compare [property get [findObject ":Address Book - Unnamed.File_QTableWidget"] rowCount] $num
}

When "I add new persons to address book" {context} {
    set table [$context table]
    # Drop initial row with column headers
    foreach row [lreplace $table 0 0] {
      foreach {forename surname email phone} $row break
      invoke clickButton [waitForObject ":Address Book - Unnamed.Add_QToolButton"]
      invoke type [waitForObject ":Forename:_LineEdit"] $forename
      invoke type [waitForObject ":Surname:_LineEdit"] $surname
      invoke type [waitForObject ":Email:_LineEdit"] $email
      invoke type [waitForObject ":Phone:_LineEdit"] $phone
      invoke clickButton [waitForObject ":Address Book - Add.OK_QPushButton"]
        
    }
}

Then "previously entered forename and surname shall be at the top" {context} {
    waitFor {object exists ":File.0_0_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_0_QModelIndex"] text] [dict get [$context userData] forename]
    waitFor {object exists ":File.0_1_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_1_QModelIndex"] text] [dict get [$context userData] surname]
}
