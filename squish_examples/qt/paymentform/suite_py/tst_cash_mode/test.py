def main():
    startApplication("paymentform")
    # Make sure the Cash radio button is checked so we start in the mode
    # we want to test
    cashRadioButtonName = ("{text='Cash' type='QRadioButton' visible='1'"
                           "window=':Make Payment_MainWindow'}")
    cashRadioButton = waitForObject(cashRadioButtonName)
    if not cashRadioButton.checked:
        clickButton(cashRadioButton)
    test.verify(cashRadioButton.checked)
    
    # Business rule #1: only the QStackedWidget's CashWidget must be
    # visible in cash mode
    # (The name "CashWidget" was set with QObject::setObjectName())
    cashWidget = waitForObject("{name='CashWidget' type='QLabel'}")
    test.compare(cashWidget.visible, True)
    
    checkWidgetName = "{name='CheckWidget' type='QWidget'}"
    # No waiting for a hidden object
    checkWidget = findObject(checkWidgetName)
    test.compare(checkWidget.visible, False)
    
    cardWidgetName = "{name='CardWidget' type='QWidget'}"
    # No waiting for a hidden object
    cardWidget = findObject(cardWidgetName)
    test.compare(cardWidget.visible, False)
    
    # Business rule #2: the minimum payment is $1 and the maximum is
    # $2000 or the amount due whichever is smaller
    amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}")
    chars = []
    for char in unicode(amountDueLabel.text):
        if char.isdigit():
            chars.append(char)
    amount_due = cast("".join(chars), int)
    maximum = min(2000, amount_due)
    
    paymentSpinBoxName = ("{buddy=':Make Payment.This Payment:_QLabel'"
                          "type='QSpinBox' unnamed='1' visible='1'}")
    paymentSpinBox = waitForObject(paymentSpinBoxName)
    test.verify(paymentSpinBox.minimum == 1)
    test.verify(paymentSpinBox.maximum == maximum)
    
    # Business rule #3: the Pay button is enabled (since the above tests
    # ensure that the payment amount is in range)
    payButtonName = ("{type='QPushButton' text='Pay' unnamed='1'"
                     "visible='1'}")
    payButton = waitForObject(payButtonName)
    test.verify(payButton.enabled)
