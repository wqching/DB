sub invokeMenuItem
{
    my ($menu, $item) = @_;
    activateItem(waitForObjectItem("{type='QMenuBar' visible='true'}", $menu));
    activateItem(waitForObjectItem("{type='QMenu' title='$menu'}", $item));
}

    
sub addNameAndAddress
{
    my(@oneNameAndAddress) = @_;
    invokeMenuItem("Edit", "Add...");
    my @fieldNames = ("Forename", "Surname", "Email", "Phone");
    my $fieldName = "";
    for (my $i = 0; $i < scalar(@fieldNames); $i++) {
        $fieldName = $fieldNames[$i];
        my $text = $oneNameAndAddress[$i];
        type(waitForObject(":${fieldName}:_QLineEdit"), $text);
    }
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"));
}
        
        
sub closeWithoutSaving
{
    invokeMenuItem("File", "Quit");
    clickButton(waitForObject(":Address Book.No_QPushButton"));
}


sub checkNameAndAddress
{
    my($table, $record) = @_;
    waitForObject($table);
    my @columnNames = testData::fieldNames($record);
    for (my $column = 0; $column < scalar(@columnNames); $column++) {
        test::compare($table->item(0, $column)->text(), # New addresses are inserted at the start
                      testData::field($record, $column));
    }
}


sub main
{
    startApplication("addressbook");
    my $table = waitForObject(":Address Book_QTableWidget");
    test::verify($table->rowCount == 0);
    invokeMenuItem("File", "New");
    my $limit = 10; # To avoid testing 100s of rows since that would be boring
    my @records = testData::dataset("MyAddresses.tsv");
    my $row = 0;
    for (; $row < scalar(@records); ++$row) {
        my $record = $records[$row];
        my $forename = testData::field($record, "Forename");
        my $surname = testData::field($record, "Surname");
        my $email = testData::field($record, "Email");
        my $phone = testData::field($record, "Phone");
        $table->setCurrentCell(0, 0); # always insert at the start
        addNameAndAddress($forename, $surname, $email, $phone);
        checkNameAndAddress($table, $record);
        if ($row > $limit) {
            last;
        }
    }
    test::verify($table->rowCount == $row + 1);
    closeWithoutSaving;
}
