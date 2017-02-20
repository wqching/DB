# encoding: UTF-8
require 'squish'
include Squish

def main
  startApplication("paymentform")
  # Make sure the Cash radio button is checked so we start in the mode
  # we want to test
  cashRadioButtonName = "{text='Cash' type='QRadioButton' visible='1'" +
  "window=':Make Payment_MainWindow'}"
  cashRadioButton = waitForObject(cashRadioButtonName)
  if not cashRadioButton.checked
    clickButton(cashRadioButton)
  end
  Test.verify(cashRadioButton.checked)

  # Business rule #1: only the QStackedWidget's CashWidget must be
  # visible in cash mode
  # (The name "CashWidget" was set with QObject::setObjectName())
  cashWidget = waitForObject("{name='CashWidget' type='QLabel'}")
  Test.compare(cashWidget.visible, true)

  checkWidgetName = "{name='CheckWidget' type='QWidget'}"
  # No waiting for a hidden object
  checkWidget = findObject(checkWidgetName)
  Test.compare(checkWidget.visible, false)

  cardWidgetName = "{name='CardWidget' type='QWidget'}"
  # No waiting for a hidden object
  cardWidget = findObject(cardWidgetName)
  Test.compare(cardWidget.visible, false)

  # Business rule #2: the minimum payment is $1 and the maximum is
  # $2000 or the amount due whichever is smaller
  amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}")
  amount_due = String(amountDueLabel.text).gsub(/\D/, "").to_f
  maximum = 2000 < amount_due ? 2000 : amount_due

  paymentSpinBoxName = "{buddy=':Make Payment.This Payment:_QLabel'" +
  "type='QSpinBox' unnamed='1' visible='1'}"
  paymentSpinBox = waitForObject(paymentSpinBoxName)
  Test.verify(paymentSpinBox.minimum == 1)
  Test.verify(paymentSpinBox.maximum == maximum)

  # Business rule #3: the Pay button is enabled (since the above tests
  # ensure that the payment amount is in range)
  payButtonName = "{type='QPushButton' text='Pay' unnamed='1'" +
  "visible='1'}"
  payButton = waitForObject(payButtonName)
  Test.verify(payButton.enabled)
end
