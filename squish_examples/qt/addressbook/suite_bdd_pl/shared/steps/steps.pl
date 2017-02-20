use warnings;

package main;

Given(
    "addressbook application is running",
    sub {
        my $context = shift;
        startApplication("addressbook");
        waitFor( "object::exists(':Address Book_MainWindow')", 20000 );
        test::compare( findObject(":Address Book_MainWindow")->enabled, 1 );
    }
);

When(
    "I create a new addressbook",
    sub {
        my $context = shift;
        clickButton( waitForObject(":Address Book.New_QToolButton") );
    }
);

Then(
    "addressbook should be empty",
    sub {
        my $context = shift;
        waitFor( "object::exists(':Address Book - Unnamed.File_QTableWidget')",20000 );
        test::compare(findObject(":Address Book - Unnamed.File_QTableWidget")->rowCount,0);
    }
);

When("I add a new person '|word|','|word|','|any|','|integer|' to address book",
  sub {
      my $context = shift;
      my ($forename, $surname, $email, $phone) = @_;
      clickButton( waitForObject(":Address Book - Unnamed.Add_QToolButton") );
      type( waitForObject(":Forename:_LineEdit"), $forename );
      type( waitForObject(":Surname:_LineEdit"),  $surname );
      type( waitForObject(":Email:_LineEdit"),    $email );
      type( waitForObject(":Phone:_LineEdit"),    $phone );
      clickButton( waitForObject(":Address Book - Add.OK_QPushButton") );
      $context->{userData}{'forename'} = $forename; 
      $context->{userData}{'surname'} = $surname;       
      
    });
    
Then("'|integer|' entries should be present", sub {
    my $context = shift;
    my $num = shift;
    waitFor("object::exists(':Address Book - Unnamed.File_QTableWidget')", 20000);
    test::compare(findObject(":Address Book - Unnamed.File_QTableWidget")->rowCount, $num);
} );

When("I add new persons to address book", sub {
    my %context = %{shift()};
    my @table = @{$context{'table'}};

    # Drop initial row with column headers
    shift(@table);

    for my $row (@table) {
      my ($forename, $surname, $email, $phone) = @{$row};
      clickButton( waitForObject(":Address Book - Unnamed.Add_QToolButton") );
      type( waitForObject(":Forename:_LineEdit"), $forename );
      type( waitForObject(":Surname:_LineEdit"),  $surname );
      type( waitForObject(":Email:_LineEdit"),    $email );
      type( waitForObject(":Phone:_LineEdit"),    $phone );
      clickButton( waitForObject(":Address Book - Add.OK_QPushButton") );
    }
});

Then("previously entered forename and surname shall be at the top", sub {
    my $context = shift;    
    test::compare( waitForObject(":File.0_0_QModelIndex")->text,  $context->{userData}{'forename'}, "forename?" );
    test::compare( waitForObject(":File.0_1_QModelIndex")->text,  $context->{userData}{'surname'}, "surname?" );
});
