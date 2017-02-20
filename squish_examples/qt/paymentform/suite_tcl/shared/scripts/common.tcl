proc clickRadioButton {text} {
    set radioButton [waitForObject "{text='$text' type='QRadioButton' \
        visible='1' window=':Make Payment_MainWindow'}"]
    if (![property get $radioButton checked]) {
        invoke clickButton $radioButton
    }
    test verify [property get $radioButton checked]
}
    
proc getAmountDue {} {
    set amountDueLabel [waitForObject {{name='AmountDueLabel' \
        type='QLabel'}}]
    set amountText [toString [property get $amountDueLabel text]]
    regsub -all {\D} $amountText "" amountText
    return [expr $amountText]
}


proc checkVisibleWidget {visible hidden} {
    set widget [waitForObject "{name='$visible' type='QWidget'}"]
    test compare [property get $widget visible] true
    foreach name $hidden {
        set widget [findObject "{name='$name' type='QWidget'}"]
        test compare [property get $widget visible] false
    }
}


proc checkPaymentRange {minimum maximum} {
    set paymentSpinBox [waitForObject \
        {{buddy=':Make Payment.This Payment:_QLabel' \
            type='QSpinBox' unnamed='1' visible='1'}}]
    test compare [property get $paymentSpinBox minimum] $minimum
    test compare [property get $paymentSpinBox maximum] $maximum
}
