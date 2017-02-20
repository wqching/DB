function checkCardDateEdits()
{
    var cardTypeComboBox = waitForObject("{buddy=':Make Payment." +
        "Card Type:_QLabel' type='QComboBox' unnamed='1' visible='1'}");
    for (var index = 0; index < cardTypeComboBox.count; ++index) {
        if (cardTypeComboBox.itemText(index) != "Visa") {
            cardTypeComboBox.setCurrentIndex(index);
            break;
        }
    }
    var today = QDate.currentDate();
    var issueDateEdit = waitForObject("{buddy=':Make Payment." +
        "Issue Date:_QLabel' type='QDateEdit' unnamed='1' visible='1'}");
    test.verify(issueDateEdit.minimumDate == today.addYears(-3));

    var expiryDateEdit = waitForObject("{buddy=':Make Payment." +
        "Expiry Date:_QLabel' type='QDateEdit' unnamed='1' visible='1'}");
    type(expiryDateEdit, today.addMonths(2).toString("MMM yyyy"));
}

function populateCardFields()
{
    var cardAccountNameLineEdit = waitForObject("{buddy=':Make Payment." +
        "Account Name:_QLabel' type='QLineEdit' unnamed='1' visible='1'}");
    type(cardAccountNameLineEdit, "An Account");
    var cardAccountNumberLineEdit = waitForObject("{buddy=':Make Payment." +
        "Account Number:_QLabel' type='QLineEdit' unnamed='1' visible='1'}");
    type(cardAccountNumberLineEdit, "1343 876 326 1323 32");
}

function main()
{
    startApplication("paymentform");
    source(findFile("scripts", "common.js"));

    // Make sure we start in the mode we want to test: card mode
    clickRadioButton("Credit Card");
    
    // Business rule #1: only the CardWidget must be visible in check mode
    checkVisibleWidget("CardWidget", ["CashWidget", "CheckWidget"]);
    
    // Business rule #2: the minimum payment is $10 or 5% of the amount due
    // whichever is larger and the maximum is $5000 or the amount due 
    // whichever is smaller
    var amount_due = getAmountDue();
    checkPaymentRange(Math.max(10, amount_due / 20.0), Math.min(5000, amount_due));

    // Business rule #3: for non-Visa cards the issue date must be no
    // earlier than 3 years ago
    // Business rule #4: the expiry date must be at least a month later
    // than today---we will make sure this is the case for the later tests
    checkCardDateEdits();

    // Business rule #5: the Pay button is disabled (since the form's data
    // isn't yet valid), so we use findObject() without waiting
    var payButton = findObject("{type='QPushButton' text='Pay' " +
        "unnamed='1' visible='1'}");
    test.compare(payButton.enabled, false);
    
    // Business rule #6: the Pay button should be enabled since all the 
    // previous tests pass, and now we have filled in the account details
    populateCardFields();
    payButton = waitForObject("{type='QPushButton' text='Pay' unnamed='1'" +
                              "visible='1'}");
    test.verify(payButton.enabled);
}
