sub main
{
    startApplication("addressbook");
    activateItem(waitForObjectItem(":Address Book_QMenuBar", "File"));
    activateItem(waitForObjectItem(":Address Book.File_QMenu", "Open..."));
    clickButton(waitForObject(":Address Book - Choose File.detailModeButton_QToolButton"));
    waitForObjectItem(":stackedWidget.treeView_QTreeView", "MyAddresses\\.adr");
    clickItem(":stackedWidget.treeView_QTreeView", "MyAddresses\\.adr", 75, 13, 0, Qt::LeftButton);
    clickButton(waitForObject(":Address Book - Choose File.Open_QPushButton"));
    waitForObjectItem(":Address Book - MyAddresses.adr.File_QTableWidget", "1/0");
    clickItem(":Address Book - MyAddresses.adr.File_QTableWidget", "1/0", 74, 16, 0, Qt::LeftButton);
    my $table = waitForObject(":Address Book - MyAddresses.adr.File_QTableWidget");
    test::verify($table->rowCount == 125);
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr_QMenuBar", "Edit"));
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr.Edit_QMenu", "Add..."));
    type(waitForObject(":Forename:_LineEdit"), "Jane");
    type(waitForObject(":Forename:_LineEdit"), "<Tab>");
    type(waitForObject(":Surname:_LineEdit"), "Doe");
    type(waitForObject(":Surname:_LineEdit"), "<Tab>");
    type(waitForObject(":Email:_LineEdit"), "jane.doe\@nowhere.com");
    type(waitForObject(":Email:_LineEdit"), "<Tab>");
    type(waitForObject(":Phone:_LineEdit"), "555 123 4567");
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"));
    waitForObjectItem(":Address Book - MyAddresses.adr.File_QTableWidget", "3/1");
    clickItem(":Address Book - MyAddresses.adr.File_QTableWidget", "3/1", 21, 22, 0, Qt::LeftButton);
    type(waitForObject(":Address Book - MyAddresses.adr.File_QTableWidget"), "<Shift>");
    type(waitForObject(":Address Book - MyAddresses.adr.File_QTableWidget"), "D");
    type(waitForObject(":Address Book - MyAddresses.adr.3_1_LineEdit"), "oe");
    type(waitForObject(":Address Book - MyAddresses.adr.3_1_LineEdit"), "<Return>");
    waitForObjectItem(":Address Book - MyAddresses.adr.File_QTableWidget", "0/1");
    test::verify($table->rowCount == 126);
    clickItem(":Address Book - MyAddresses.adr.File_QTableWidget", "0/1", 25, 16, 0, Qt::LeftButton);
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr_QMenuBar", "Edit"));
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr.Edit_QMenu", "Remove..."));
    clickButton(waitForObject(":Address Book - Delete.Yes_QPushButton"));
    test::verify($table->rowCount == 125);
    waitFor("object::exists(':File.0_0_QModelIndex')", 20000);
    test::compare(findObject(":File.0_0_QModelIndex")->text, "Jane");
    waitFor("object::exists(':File.0_1_QModelIndex')", 20000);
    test::compare(findObject(":File.0_1_QModelIndex")->text, "Doe");
    waitFor("object::exists(':File.0_2_QModelIndex')", 20000);
    test::compare(findObject(":File.0_2_QModelIndex")->text, "jane.doe\@nowhere.com");
    waitFor("object::exists(':File.0_3_QModelIndex')", 20000);
    test::compare(findObject(":File.0_3_QModelIndex")->text, "555 123 4567");
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr_QMenuBar", "File"));
    activateItem(waitForObjectItem(":Address Book - MyAddresses.adr.File_QMenu", "Quit"));
    clickButton(waitForObject(":Address Book - Delete.No_QPushButton"));
}
