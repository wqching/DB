proc main {} {
    startApplication "addressbook"
    invoke activateItem [waitForObjectItem ":Address Book_QMenuBar" "File"]
    invoke activateItem [waitForObjectItem ":Address Book.File_QMenu" "Open..."]
    invoke clickButton [waitForObject ":Address Book - Choose File.detailModeButton_QToolButton"]
    waitForObjectItem ":stackedWidget.treeView_QTreeView" "MyAddresses\\.adr"
    invoke clickItem ":stackedWidget.treeView_QTreeView" "MyAddresses\\.adr" 73 7 0 [enum Qt LeftButton]
    invoke clickButton [waitForObject ":Address Book - Choose File.Open_QPushButton"]
    waitForObjectItem ":Address Book - MyAddresses.adr.File_QTableWidget" "1/1"
    invoke clickItem ":Address Book - MyAddresses.adr.File_QTableWidget" "1/1" 52 7 0 [enum Qt LeftButton]
    set table [waitForObject ":Address Book - MyAddresses.adr.File_QTableWidget"]
    test compare [property get $table rowCount] 125
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr_QMenuBar" "Edit"]
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr.Edit_QMenu" "Add..."]
    invoke type [waitForObject ":Forename:_LineEdit"] "Jane" 
    invoke type [waitForObject ":Forename:_LineEdit"] "<Tab>" 
    invoke type [waitForObject ":Surname:_LineEdit"] "Doe" 
    invoke type [waitForObject ":Surname:_LineEdit"] "<Tab>" 
    invoke type [waitForObject ":Email:_LineEdit"] "jane.doe@nowhere.com" 
    invoke type [waitForObject ":Email:_LineEdit"] "<Tab>" 
    invoke type [waitForObject ":Phone:_LineEdit"] "555 123 4567" 
    invoke clickButton [waitForObject ":Address Book - Add.OK_QPushButton"]
    waitForObjectItem ":Address Book - MyAddresses.adr.File_QTableWidget" "3/1" 
    invoke clickItem ":Address Book - MyAddresses.adr.File_QTableWidget" "3/1" 21 22 0 [enum Qt LeftButton]
    invoke type [waitForObject ":Address Book - MyAddresses.adr.File_QTableWidget"] "<Shift>" 
    invoke type [waitForObject ":Address Book - MyAddresses.adr.File_QTableWidget"] "D" 
    invoke type [waitForObject ":Address Book - MyAddresses.adr.3_1_LineEdit"] "oe" 
    invoke type [waitForObject ":Address Book - MyAddresses.adr.3_1_LineEdit"] "<Return>" 
    waitForObjectItem ":Address Book - MyAddresses.adr.File_QTableWidget" "0/1" 
    test compare [property get $table rowCount] 126
    invoke clickItem ":Address Book - MyAddresses.adr.File_QTableWidget" "0/1" 25 16 0 [enum Qt LeftButton]
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr_QMenuBar" "Edit"]  
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr.Edit_QMenu" "Remove..."]
    invoke clickButton [waitForObject ":Address Book - Delete.Yes_QPushButton"]
    test compare [property get $table rowCount] 125
    waitFor {object exists ":File.0_0_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_0_QModelIndex"] text] "Jane"
    waitFor {object exists ":File.0_1_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_1_QModelIndex"] text] "Doe"
    waitFor {object exists ":File.0_2_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_2_QModelIndex"] text] "jane.doe@nowhere.com"
    waitFor {object exists ":File.0_3_QModelIndex"} 20000
    test compare [property get [findObject ":File.0_3_QModelIndex"] text] "555 123 4567"
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr_QMenuBar" "File"]
    invoke activateItem [waitForObjectItem ":Address Book - MyAddresses.adr.File_QMenu" "Quit"]
    invoke clickButton [waitForObject ":Address Book - Delete.No_QPushButton"]
}
