sub doFileOpen
{
    my $path_and_filename = shift(@_);
    chooseMenuOptionByKey( "File", "F", "o" );
    waitForObject(":fileNameEdit_QLineEdit");
    my @components = split /\//, $path_and_filename;
    foreach (@components) {
        type( ":fileNameEdit_QLineEdit", $_ );
        waitForObject(":fileNameEdit_QLineEdit");
        type( ":fileNameEdit_QLineEdit", "<Return>" );
    }
}

sub chooseMenuOptionByKey {
    my ( $menuTitle, $menuKey, $optionKey ) = @_;
    my $windowName = "{type='MainWindow' unnamed='1' visible='1' "
      . "windowTitle?='CSV Table*'}";
    waitForObject($windowName);
    type( $windowName, "<Alt+$menuKey>" );
    my $menuName =
      "{title='$menuTitle' type='QMenu' " . "unnamed='1' visible='1'}";
    waitForObject($menuName);
    type( $menuName, $optionKey );
}

sub compareTableWithDataFile {
    my ( $tableWidget, $filename ) = @_;
    my @records = testData::dataset($filename);
    for ( my $row = 0 ; $row < scalar(@records) ; $row++ ) {
        my @columnNames = testData::fieldNames( $records[$row] );
        for ( my $column = 0 ; $column < scalar(@columnNames) ; $column++ ) {
            my $tableItem = $tableWidget->item( $row, $column );
            test::compare( $tableItem->text(),
                testData::field( $records[$row], $column ) );
        }
    }
}
