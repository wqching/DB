proc checkCardDateEdits {} {
    set cardTypeComboBox [waitForObject \
        {{buddy=':Make Payment.Card Type:_QLabel' type='QComboBox' \
            unnamed='1' visible='1'}}]
    set count [property get $cardTypeComboBox count]
    for {set index 0} {$index < $count} {incr index} {
        if {[invoke $cardTypeComboBox itemText $index] != "Visa"} {
            invoke $cardTypeComboBox setCurrentIndex $index
            break
	}
    }
    set today [invoke QDate currentDate]
    set issueDateEdit [waitForObject \
        {{buddy=':Make Payment.Issue Date:_QLabel' type='QDateEdit' \
            unnamed='1' visible='1'}}]
    set maximumIssueDate [toString [property get $issueDateEdit \
        maximumDate]]
    set threeYearsAgo [toString [invoke $today addYears -3]]
    test verify [string equal $maximumIssueDate $threeYearsAgo]

    set expiryDateEdit [waitForObject \
        {{buddy=':Make Payment.Expiry Date:_QLabel' type='QDateEdit' \
            unnamed='1' visible='1'}}]
    set date [invoke $today addMonths 2]
    invoke type $expiryDateEdit [invoke $date toString "MMM yyyy"]
}

proc populateCardFields {} {
    set cardAccountNameLineEdit [waitForObject \
        {{buddy=':Make Payment.Account Name:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $cardAccountNameLineEdit "An Account"
    set cardAccountNumberLineEdit [waitForObject \
        {{buddy=':Make Payment.Account Number:_QLabel' type='QLineEdit' \
            unnamed='1' visible='1'}}]
    invoke type $cardAccountNumberLineEdit "1343 876 326 1323 32"
}

proc main {} {
    startApplication "paymentform"
    source [findFile "scripts" "common.tcl"]

    # Make sure we start in the mode we want to test: card mode
    clickRadioButton "Credit Card"
    
    # Business rule #1: only the CardWidget must be visible in check mode
    checkVisibleWidget "CardWidget" {"CashWidget" "CheckWidget"}
    
    # Business rule #2: the minimum payment is $10 or 5% of the amount due
    # whichever is larger and the maximum is $5000 or the amount due 
    # whichever is smaller
    set amount_due [getAmountDue]
    set five_percent [expr $amount_due / 20.0]
    set minimum [expr 10 < $five_percent ? $five_percent : 10]
    set maximum [expr 5000 > $amount_due ? $amount_due : 5000]
    checkPaymentRange $minimum $maximum

    # Business rule #3: for non-Visa cards the issue date must be no
    # earlier than 3 years ago
    # Business rule #4: the expiry date must be at least a month later
    # than today---we will make sure this is the case for the later tests
    checkCardDateEdits
    
    # Business rule #5: the Pay button is disabled (since the form's data
    # isn't yet valid), so we use findObject() without waiting
    set payButton [findObject {{type='QPushButton' text='Pay' \
        unnamed='1' visible='1'}}]
    test compare [property get $payButton enabled] false
    
    # Business rule #6: the Pay button should be enabled since all the 
    # previous tests pass, and now we have filled in the account details
    populateCardFields
    set payButton [waitForObject {{type='QPushButton' text='Pay' \
        unnamed='1' visible='1'}}]
    test verify [property get $payButton enabled]
}
