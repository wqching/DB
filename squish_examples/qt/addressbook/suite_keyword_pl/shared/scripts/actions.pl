my $FORENAME = 0;
my $SURNAME  = 1;
my $EMAIL    = 2;
my $PHONE    = 3;

sub chooseMenuItem {
    my ( $menu, $item ) = @_;
    activateItem( waitForObjectItem( ":Address Book_QMenuBar", $menu ) );
    activateItem(
        waitForObjectItem( ":Address Book." . $menu . "_QMenu", $item ) );
}

sub addAddress {
    my ( $forename, $surname, $email, $phone ) = @_;
    my $oldRowCount = getRowCount();
    chooseMenuItem( "Edit", "Add..." );
    type( waitForObject(":Forename:_LineEdit"), $forename );
    type( waitForObject(":Surname:_LineEdit"),  $surname );
    type( waitForObject(":Email:_LineEdit"),    $email );
    type( waitForObject(":Phone:_LineEdit"),    $phone );
    clickButton( waitForObject(":Address Book - Add.OK_QPushButton") );
    my $newRowCount = getRowCount();
    test::verify( $oldRowCount + 1 == $newRowCount, "row count" );
    my $row = $oldRowCount;    # The first item is inserted at row 0

    if ( $row > 0 ) {          # subsequent ones at row rowCount - 1
        --$row;
    }
    checkTableRow( $row, $forename, $surname, $email, $phone );
}

sub removeAddress {
    my $email = shift;
    my $tableWidget =
      waitForObject(":Address Book - Unnamed.File_QTableWidget");
    my $oldRowCount = getRowCount();
    for ( my $row = 0 ; $row < $oldRowCount ; ++$row ) {
        if ( $tableWidget->item( $row, $EMAIL )->text() eq $email ) {
            $tableWidget->setCurrentCell( $row, $EMAIL );
            chooseMenuItem( "Edit", "Remove..." );
            clickButton(
                waitForObject(":Address Book - Delete.Yes_QPushButton") );
            test::log("Removed $email");
            last;
        }
    }
    my $newRowCount = getRowCount();
    test::verify( $oldRowCount - 1 == $newRowCount, "row count" );
}

sub verifyRowCount {
    my $rows = shift;
    test::verify( $rows eq getRowCount(), "row count" );
}

sub getRowCount {
    my $tableWidget =
      waitForObject(":Address Book - Unnamed.File_QTableWidget");
    return $tableWidget->rowCount;
}

sub checkTableRow {
    my ( $row, $forename, $surname, $email, $phone ) = @_;
    my $tableWidget =
      waitForObject(":Address Book - Unnamed.File_QTableWidget");
    test::compare( $forename, $tableWidget->item( $row, $FORENAME )->text(),
        "forename" );
    test::compare( $surname, $tableWidget->item( $row, $SURNAME )->text(),
        "surname" );
    test::compare( $email, $tableWidget->item( $row, $EMAIL )->text(),
        "email" );
    test::compare( $phone, $tableWidget->item( $row, $PHONE )->text(),
        "phone" );
}

sub terminate {
    chooseMenuItem( "File", "Quit" );
    clickButton( waitForObject(":Address Book.No_QPushButton") );
}
