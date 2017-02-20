sub checkCardDateEdits
{
    my $cardTypeComboBox = waitForObject("{buddy=':Make Payment." .
            "Card Type:_QLabel' type='QComboBox' unnamed='1' visible='1'}");
    for (my $index = 0; $index < $cardTypeComboBox->count; $index++) {
        if ($cardTypeComboBox->itemText($index) != "Visa") {
            $cardTypeComboBox->setCurrentIndex($index);
            last;
        }
    }
    my $today = QDate::currentDate();
    my $issueDateEdit = waitForObject("{buddy=':Make Payment." .
            "Issue Date:_QLabel' type='QDateEdit' unnamed='1' visible='1'}");
    test::verify($issueDateEdit->minimumDate == $today->addYears(-3));

    my $expiryDateEdit = waitForObject("{buddy=':Make Payment." .
            "Expiry Date:_QLabel' type='QDateEdit' unnamed='1' visible='1'}");
    type($expiryDateEdit, $today->addMonths(2)->toString("MMM yyyy"));
}

sub populateCardFields
{
    my $cardAccountNameLineEdit = waitForObject(
            "{buddy=':Make Payment.Account Name:_QLabel' type='QLineEdit' " .
            "unnamed='1' visible='1'}");
    type($cardAccountNameLineEdit, "An Account");
    my $cardAccountNumberLineEdit = waitForObject(
            "{buddy=':Make Payment.Account Number:_QLabel' " .
            "type='QLineEdit' unnamed='1' visible='1'}");
    type($cardAccountNumberLineEdit, "1343 876 326 1323 32");
}

sub main
{
    startApplication("paymentform");
    source(findFile("scripts", "common.pl"));

    # Make sure we start in the mode we want to test: card mode
    clickRadioButton("Credit Card");
    
    # Business rule #1: only the CardWidget must be visible in check mode
    checkVisibleWidget("CardWidget", ("CashWidget", "CheckWidget"));
    
    # Business rule #2: the minimum payment is $10 or 5% of the amount due
    # whichever is larger and the maximum is $5000 or the amount due 
    # whichever is smaller
    my $amount_due = getAmountDue();
    my $paymentSpinBox = waitForObject("{buddy=':Make Payment." .
            "This Payment:_QLabel' type='QSpinBox' unnamed='1' visible='1'}");
    my $fraction = $amount_due / 20.0;
    checkPaymentRange(10 < $fraction ? $fraction : 10,
                      5000 < $amount_due ? 5000 : $amount_due);

    # Business rule #3: for non-Visa cards the issue date must be no
    # earlier than 3 years ago
    # Business rule #4: the expiry date must be at least a month later
    # than today---we will make sure this is the case for the later tests
    checkCardDateEdits();
    
    # Business rule #5: the Pay button is disabled (since the form's data
    # isn't yet valid), so we use findObject() without waiting
    my $payButton = findObject("{type='QPushButton' text='Pay' unnamed='1'" .
                               "visible='1'}");
    test::compare($payButton->enabled, 0);
    
    # Business rule #6: the Pay button should be enabled since all the 
    # previous tests pass, and now we have filled in the account details
    populateCardFields();
    $payButton = waitForObject("{type='QPushButton' text='Pay' unnamed='1'" .
                              "visible='1'}");
    test::compare($payButton->enabled, 1);
}
