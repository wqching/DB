proc checkDateRange {minimum maximum} {
    set checkDateEdit [waitForObject \
        {{buddy=':Make Payment.Check Date:_QLabel' type='QDateEdit' \
            unnamed='1' visible='1'}}]
    set minimumDate [toString [property get $checkDateEdit minimumDate]]
    set maximumDate [toString [property get $checkDateEdit maximumDate]]
    test verify [string equal $minimum $minimumDate]
    test verify [string equal $maximum $maximumDate]
}

proc ensureSignedCheckBoxIsChecked {} {
    set checkSignedCheckBox [waitForObject {{text='Check Signed' \
        type='QCheckBox' unnamed='1' visible='0' \
        window=':Make Payment_MainWindow'}}]
    if (![property get $checkSignedCheckBox checked]) {
        invoke clickButton $checkSignedCheckBox
    }
    test verify [property get $checkSignedCheckBox checked]
}

proc populateCheckFields {} {
    set bankNameLineEdit [waitForObject \
        {{buddy=':Make Payment.Bank Name:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $bankNameLineEdit "A Bank"
    set bankNumberLineEdit [waitForObject \
        {{buddy=':Make Payment.Bank Number:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $bankNumberLineEdit "88-91-33X"
    set accountNameLineEdit [waitForObject \
        {{buddy=':Make Payment.Account Name:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $accountNameLineEdit "An Account"
    set accountNumberLineEdit [waitForObject \
        {{buddy=':Make Payment.Account Number:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $accountNumberLineEdit "932745395"
}

proc main {} {
    startApplication "paymentform"
    # Import functionality needed by more than one test script
    source [findFile "scripts" "common.tcl"]

    # Make sure we start in the mode we want to test: check mode
    clickRadioButton "Check"
    
    # Business rule #1: only the CheckWidget must be visible in check mode
    checkVisibleWidget "CheckWidget" {"CashWidget" "CardWidget"}
    
    # Business rule #2: the minimum payment is $10 and the maximum is
    # $250 or the amount due whichever is smaller
    set amount_due [getAmountDue]
    set maximum [expr 250 > $amount_due ? $amount_due : 250]
    checkPaymentRange 10 $maximum
    
    # Business rule #3: the check date must be no earlier than 30 days 
    # ago and no later than tomorrow
    set today [invoke QDate currentDate]
    set thirtyDaysAgo [toString [invoke $today addDays -30]]
    set tomorrow [toString [invoke $today addDays 1]]
    checkDateRange $thirtyDaysAgo $tomorrow
    
    # Business rule #4: the Pay button is disabled (since the form's data
    # isn't yet valid), so we use findObject() without waiting
    set payButton [findObject {{type='QPushButton' text='Pay' \
        unnamed='1' visible='1'}}]
    test verify [expr ![property get $payButton enabled]]
    
    # Business rule #5: the check must be signed (and if it isn't we
    # will check the check box ready to test the next rule)
    ensureSignedCheckBoxIsChecked
    
    # Business rule #6: the Pay button should be enabled since all the 
    # previous tests pass, the check is signed and now we have filled in
    # the account details
    populateCheckFields
    set payButton [waitForObject {{type='QPushButton' text='Pay' \
        unnamed='1' visible='1'}}]
    test verify [property get $payButton enabled]
}
