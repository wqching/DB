proc main {} {
    startApplication "paymentform"
    # Make sure the Cash radio button is checked so we start in the mode
    # we want to test
    set cashRadioButtonName {{text='Cash' type='QRadioButton' visible='1' 
            window=':Make Payment_MainWindow'}}
    
    set cashRadioButton [waitForObject $cashRadioButtonName]
    if {![property get $cashRadioButton checked]} {
        invoke clickButton $cashRadioButton
    }
    test verify [property get $cashRadioButton checked]
    
    # Business rule #1: only the QStackedWidget's CashWidget must be
    # visible in cash mode
    # (The name "CashWidget" was set with QObject::setObjectName())
    set cashWidget [waitForObject "{name='CashWidget' type='QLabel'}"]
    test compare [property get $cashWidget visible] true
    
    set checkWidgetName {{name='CheckWidget' type='QWidget'}}
    # No waiting for a hidden object
    set checkWidget [findObject $checkWidgetName]
    test compare [property get $checkWidget visible] false
    
    set cardWidgetName {{name='CardWidget' type='QWidget'}}
    # No waiting for a hidden object
    set cardWidget [findObject $cardWidgetName]
    test compare [property get $cardWidget visible] false
    
    # Business rule #2: the minimum payment is $1 and the maximum is
    # $2000 or the amount due whichever is smaller
    set amountDueLabel [waitForObject {{name='AmountDueLabel' type='QLabel'}}]
    set amountText [toString [property get $amountDueLabel text]]
    regsub -all {\D} $amountText "" amountText
    set amount_due [expr $amountText]
    set maximum [expr $amount_due < 2000 ? $amount_due : 2000]
    
    set paymentSpinBoxName {{buddy=':Make Payment.This Payment:_QLabel' \
        type='QSpinBox' unnamed='1' visible='1'}}
    set paymentSpinBox [waitForObject $paymentSpinBoxName]
    test compare [property get $paymentSpinBox minimum] 1
    test compare [property get $paymentSpinBox maximum] $maximum
    
    # Business rule #3: the Pay button is enabled (since the above tests
    # ensure that the payment amount is in range)
    set payButtonName {{type='QPushButton' text='Pay' unnamed='1'
                        visible='1'}}
    set payButton [waitForObject $payButtonName]
    test verify [property get $payButton enabled]
}
