# encoding: UTF-8
require 'squish'
include Squish

def checkDateRange(minimum, maximum)
  checkDateEdit = waitForObject("{buddy=':Make Payment.Check Date:_QLabel' " +
  "type='QDateEdit' unnamed='1' visible='1'}")
  Test.verify(checkDateEdit.minimumDate == minimum)
  Test.verify(checkDateEdit.maximumDate == maximum)
end

def ensureSignedCheckBoxIsChecked
  checkSignedCheckBox = waitForObject("{text='Check Signed' type='QCheckBox' " +
  "unnamed='1' visible='0' window=':Make Payment_MainWindow'}")
  if not checkSignedCheckBox.checked
    clickButton(checkSignedCheckBox)
  end
  Test.verify(checkSignedCheckBox.checked)
end

def populateCheckFields
  bankNameLineEdit = waitForObject("{buddy=':Make Payment.Bank Name:_QLabel' " +
  "type='QLineEdit' unnamed='1' visible='1'}")
  type(bankNameLineEdit, "A Bank")
  bankNumberLineEdit = waitForObject(
  "{buddy=':Make Payment.Bank Number:_QLabel' type='QLineEdit' " +
  "unnamed='1' visible='1'}")
  type(bankNumberLineEdit, "88-91-33X")
  accountNameLineEdit = waitForObject(
  "{buddy=':Make Payment.Account Name:_QLabel' type='QLineEdit' " +
  "unnamed='1' visible='1'}")
  type(accountNameLineEdit, "An Account")
  accountNumberLineEdit = waitForObject(
  "{buddy=':Make Payment.Account Number:_QLabel' type='QLineEdit' " +
  "unnamed='1' visible='1'}")
  type(accountNumberLineEdit, "932745395")
end

def main
  startApplication("paymentform")
  # Import functionality needed by more than one test script
  require findFile("scripts", "common.rb")

  # Make sure we start in the mode we want to test: check mode
  clickRadioButton("Check")

  # Business rule #1: only the CheckWidget must be visible in check mode
  checkVisibleWidget("CheckWidget", ["CashWidget", "CardWidget"])

  # Business rule #2: the minimum payment is $10 and the maximum is
  # $250 or the amount due whichever is smaller
  amount_due = getAmountDue
  checkPaymentRange(10, min(250, amount_due))

  # Business rule #3: the check date must be no earlier than 30 days
  # ago and no later than tomorrow
  today = QDate.currentDate()
  checkDateRange(today.addDays(-30), today.addDays(1))

  # Business rule #4: the Pay button is disabled (since the form's data
  # isn't yet valid), so we use findObject() without waiting
  payButton = findObject("{type='QPushButton' text='Pay' unnamed='1'" +
  "visible='1'}")
  Test.verify(!payButton.enabled)

  # Business rule #5: the check must be signed (and if it isn't we
  # will check the check box ready to test the next rule)
  ensureSignedCheckBoxIsChecked

  # Business rule #6: the Pay button should be enabled since all the
  # previous tests pass, the check is signed and now we have filled in
  # the account details
  populateCheckFields
  payButton = waitForObject("{type='QPushButton' text='Pay' unnamed='1'" +
  "visible='1'}")
  Test.verify(payButton.enabled)
end
