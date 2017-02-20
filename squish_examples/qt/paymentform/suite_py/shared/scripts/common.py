def clickRadioButton(text):
    radioButton = waitForObject("{text='%s' type='QRadioButton' visible='1'"
            "window=':Make Payment_MainWindow'}" % text)
    if not radioButton.checked:
        clickButton(radioButton)
    test.verify(radioButton.checked)
    

def getAmountDue():
    amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}")
    chars = []
    for char in unicode(amountDueLabel.text):
        if char.isdigit():
            chars.append(char)
    return cast("".join(chars), int)


def checkVisibleWidget(visible, hidden):
    widget = waitForObject("{name='%s' type='QWidget'}" % visible)
    test.compare(widget.visible, True)
    for name in hidden:
        widget = findObject("{name='%s' type='QWidget'}" % name)
        test.compare(widget.visible, False)


def checkPaymentRange(minimum, maximum):
    paymentSpinBox = waitForObject("{buddy=':Make Payment.This Payment:_QLabel' "
            "type='QSpinBox' unnamed='1' visible='1'}")
    test.verify(paymentSpinBox.minimum == minimum)
    test.verify(paymentSpinBox.maximum == maximum)
