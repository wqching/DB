function main()
{
    startApplication("paymentform");
    // Make sure the Cash radio button is checked so we start in the mode
    // we want to test
    var cashRadioButtonName = "{text='Cash' type='QRadioButton' " +
            "visible='1' window=':Make Payment_MainWindow'}";
    var cashRadioButton = waitForObject(cashRadioButtonName);
    if (!cashRadioButton.checked) {
        clickButton(cashRadioButton);
    }
    test.verify(cashRadioButton.checked);
    
    // Business rule #1: only the QStackedWidget's CashWidget must be
    // visible in cash mode
    // (The name "CashWidget" was set with QObject::setObjectName())
    var cashWidget = waitForObject("{name='CashWidget' type='QLabel'}");
    test.compare(cashWidget.visible, true);
    
    var checkWidgetName = "{name='CheckWidget' type='QWidget'}";
    // No waiting for a hidden object
    var checkWidget = findObject(checkWidgetName);
    test.compare(checkWidget.visible, false);
    
    var cardWidgetName = "{name='CardWidget' type='QWidget'}";
    // No waiting for a hidden object
    cardWidget = findObject(cardWidgetName);
    test.compare(cardWidget.visible, false);
    
    // Business rule #2: the minimum payment is $1 and the maximum is
    // $2000 or the amount due whichever is smaller
    var amountDueLabel = waitForObject("{name='AmountDueLabel' " +
        "type='QLabel'}");
    var amount_due = 0 + String(amountDueLabel.text).replace(/\D/g, "");
    var maximum = Math.min(2000, amount_due);
    
    var paymentSpinBoxName = "{buddy=':Make Payment.This Payment:_QLabel'" +
                             "type='QSpinBox' unnamed='1' visible='1'}";
    var paymentSpinBox = waitForObject(paymentSpinBoxName);
    test.verify(paymentSpinBox.minimum == 1);
    test.verify(paymentSpinBox.maximum == maximum);
    
    // Business rule #3: the Pay button is enabled (since the above tests
    // ensure that the payment amount is in range)
    var payButtonName = "{type='QPushButton' text='Pay' unnamed='1'" +
                        "visible='1'}";
    var payButton = waitForObject(payButtonName);
    test.verify(payButton.enabled);
}
