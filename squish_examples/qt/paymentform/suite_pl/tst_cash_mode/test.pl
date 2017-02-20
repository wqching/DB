sub main
{
    startApplication("paymentform");
    # Make sure the Cash radio button is checked so we start in the mode
    # we want to test
    my $cashRadioButtonName = "{text='Cash' type='QRadioButton' " .
                              "visible='1'window=':Make Payment_MainWindow'}";
    my $cashRadioButton = waitForObject($cashRadioButtonName);
    if (!$cashRadioButton->checked) {
        clickButton($cashRadioButton);
    }
    test::compare($cashRadioButton->checked, 1);
    
    # Business rule #1: only the QStackedWidget's CashWidget must be
    # visible in cash mode
    # (The name "CashWidget" was set with QObject::setObjectName())
    my $cashWidget = waitForObject("{name='CashWidget' type='QLabel'}");
    test::compare($cashWidget->visible, 1);
    
    $checkWidgetName = "{name='CheckWidget' type='QWidget'}";
    # No waiting for a hidden object
    my $checkWidget = findObject($checkWidgetName);
    test::compare($checkWidget->visible, 0);
    
    my $cardWidgetName = "{name='CardWidget' type='QWidget'}";
    # No waiting for a hidden object
    my $cardWidget = findObject($cardWidgetName);
    test::compare($cardWidget->visible, 0);
    
    # Business rule #2: the minimum payment is $1 and the maximum is
    # $2000 or the amount due whichever is smaller
    my $amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}");
    my $amount_due = $amountDueLabel->text;
    $amount_due =~ s/\D//g; # remove non-digits
    my $maximum = 2000 < $amount_due ? 2000 : $amount_due;
        
    my $paymentSpinBoxName = "{buddy=':Make Payment.This Payment:_QLabel'" .
                             "type='QSpinBox' unnamed='1' visible='1'}";
    my $paymentSpinBox = waitForObject($paymentSpinBoxName);
    test::verify($paymentSpinBox->minimum == 1);
    test::verify($paymentSpinBox->maximum == $maximum);
    
    # Business rule #3: the Pay button is enabled (since the above tests
    # ensure that the payment amount is in range)
    my $payButtonName = "{type='QPushButton' text='Pay' unnamed='1'" .
                        "visible='1'}";
    my $payButton = waitForObject($payButtonName);
    test::compare($payButton->enabled, 1);
}
