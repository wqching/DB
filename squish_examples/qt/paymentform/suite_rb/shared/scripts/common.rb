# encoding: UTF-8
require 'squish'
include Squish

def clickRadioButton(text)
  radioButton = waitForObject("{text='#{text}' " +
  "type='QRadioButton' visible='1' window=':Make Payment_MainWindow'}")
  if not radioButton.checked
    clickButton(radioButton)
  end
  Test.verify(radioButton.checked)
end

def getAmountDue
  amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}")
  String(amountDueLabel.text).gsub(/\D/, "").to_f
end

def checkVisibleWidget(visible, hidden)
  widget = waitForObject("{name='#{visible}' type='QWidget'}")
  Test.compare(widget.visible, true)
  for name in hidden
    widget = findObject("{name='#{name}' type='QWidget'}")
    Test.compare(widget.visible, false)
  end
end

def checkPaymentRange(minimum, maximum)
  paymentSpinBox = waitForObject("{buddy=':Make Payment.This Payment:_QLabel' " +
  "type='QSpinBox' unnamed='1' visible='1'}")
  Test.verify(paymentSpinBox.minimum == minimum)
  Test.verify(paymentSpinBox.maximum == maximum)
end

def max(x, y)
  x > y ? x : y
end

def min(x, y)
  x < y ? x : y
end
