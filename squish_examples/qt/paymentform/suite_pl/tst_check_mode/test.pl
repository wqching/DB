sub checkDateRange
{
    my ($minimum, $maximum) = @_;
    $checkDateEdit = waitForObject("{buddy=':Make Payment.Check Date:_QLabel' " .
	    "type='QDateEdit' unnamed='1' visible='1'}");
    test::verify($checkDateEdit->minimumDate == $minimum);
    test::verify($checkDateEdit->maximumDate == $maximum);
}


sub ensureSignedCheckBoxIsChecked
{
    my $checkSignedCheckBox = waitForObject("{text='Check Signed' " .
            "type='QCheckBox' unnamed='1' visible='0' " .
            "window=':Make Payment_MainWindow'}");
    if (!$checkSignedCheckBox->checked) {
        clickButton($checkSignedCheckBox);
    }
    test::verify($checkSignedCheckBox->checked);
}

sub populateCheckFields
{
    my $bankNameLineEdit = waitForObject("{buddy=':Make Payment." .
            "Bank Name:_QLabel' type='QLineEdit' unnamed='1' visible='1'}");
    type($bankNameLineEdit, "A Bank");
    my $bankNumberLineEdit = waitForObject(
        "{buddy=':Make Payment.Bank Number:_QLabel' type='QLineEdit' " .
        "unnamed='1' visible='1'}");
    type($bankNumberLineEdit, "88-91-33X");
    my $accountNameLineEdit = waitForObject(
        "{buddy=':Make Payment.Account Name:_QLabel' type='QLineEdit' " .
        "unnamed='1' visible='1'}");
    type($accountNameLineEdit, "An Account");
    my $accountNumberLineEdit = waitForObject(
        "{buddy=':Make Payment.Account Number:_QLabel' type='QLineEdit' " .
        "unnamed='1' visible='1'}");
    type($accountNumberLineEdit, "932745395");
}

sub main
{
    startApplication("paymentform");
    # Import functionality needed by more than one test script
    source(findFile("scripts", "common.pl"));

    # Make sure we start in the mode we want to test: check mode
    clickRadioButton("Check");
    
    # Business rule #1: only the CheckWidget must be visible in check mode
    checkVisibleWidget("CheckWidget", ("CashWidget", "CardWidget"));
    
    # Business rule #2: the minimum payment is $10 and the maximum is
    # $250 or the amount due whichever is smaller
    my $amount_due = getAmountDue();
    checkPaymentRange(10, 250 < $amount_due ? 250 : $amount_due);
    
    # Business rule #3: the check date must be no earlier than 30 days 
    # ago and no later than tomorrow
    my $today = QDate::currentDate();
    checkDateRange($today->addDays(-30), $today->addDays(1));
    
    # Business rule #4: the Pay button is disabled (since the form's data
    # isn't yet valid), so we use findObject() without waiting
    my $payButton = findObject("{type='QPushButton' text='Pay' unnamed='1'" .
                               "visible='1'}");
    test::verify(!$payButton->enabled);
    
    # Business rule #5: the check must be signed (and if it isn't we
    # will check the check box ready to test the next rule)
    ensureSignedCheckBoxIsChecked();
    
    # Business rule #6: the Pay button should be enabled since all the 
    # previous tests pass, the check is signed and now we have filled in
    # the account details
    populateCheckFields();
    $payButton = waitForObject("{type='QPushButton' text='Pay' unnamed='1'" .
                              "visible='1'}");
    test::compare($payButton->enabled, 1);
}
