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


sub main
{
    startApplication("addressbook");
    my $table = waitForObject(":Address Book_QTableWidget");
    test::verify($table->rowCount == 0);
    invokeMenuItem("File", "New");
    my @data = (["Andy", "Beach", "andy.beach\@nowhere.com", "555 123 6786"],
                ["Candy", "Deane", "candy.deane\@nowhere.com", "555 234 8765"],
                ["Ed", "Fernleaf", "ed.fernleaf\@nowhere.com", "555 876 4654"]);
    foreach $oneNameAndAddress (@data) {
        addNameAndAddress(@{$oneNameAndAddress});
    }
    waitForObject($table);
    test::compare($table->rowCount, scalar(@data), "table contains as many rows as added data");
    closeWithoutSaving;
}
