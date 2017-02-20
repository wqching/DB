function clickRadioButton(text)
{
    var radioButton = waitForObject("{text='" + text + "' type='QRadioButton' " +
            "visible='1' window=':Make Payment_MainWindow'}");
    if (!radioButton.checked) {
        clickButton(radioButton);
    }
    test.verify(radioButton.checked);
}  


function getAmountDue()
{
    var amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}");
    return 0 + String(amountDueLabel.text).replace(/\D/g, "");
}


function checkVisibleWidget(visible, hidden)
{
    var widget = waitForObject("{name='" + visible + "' type='QWidget'}");
    test.compare(widget.visible, true);
    for (var i = 0; i < hidden.length; ++i) {
        var name = hidden[i];
        var widget = findObject("{name='" + name + "' type='QWidget'}");
        test.compare(widget.visible, false);
    }
}


function checkPaymentRange(minimum, maximum)
{
    var paymentSpinBox = waitForObject("{buddy=':Make Payment." +
        "This Payment:_QLabel' type='QSpinBox' unnamed='1' visible='1'}");
    test.verify(paymentSpinBox.minimum == minimum);
    test.verify(paymentSpinBox.maximum == maximum);
}
