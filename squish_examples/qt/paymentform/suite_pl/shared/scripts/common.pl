sub clickRadioButton
{
    my $text = shift(@_);
    my $radioButton = waitForObject("{text='$text' type='QRadioButton' " .
            "visible='1' window=':Make Payment_MainWindow'}");
    if (!$radioButton->checked) {
        clickButton($radioButton);
    }
    test::verify($radioButton->checked);
}

    
sub getAmountDue
{
    my $amountDueLabel = waitForObject("{name='AmountDueLabel' type='QLabel'}");
    my $amount_due = $amountDueLabel->text;
    $amount_due =~ s/\D//g; # remove non-digits
    return $amount_due;
}


sub checkVisibleWidget
{
    my ($visible, @hidden) = @_;
    my $widget = waitForObject("{name='$visible' type='QWidget'}");
    test::compare($widget->visible, 1);
    foreach (@hidden) {
        my $widget = findObject("{name='$_' type='QWidget'}");
        test::compare($widget->visible, 0);
    }
}


sub checkPaymentRange
{
    my ($minimum, $maximum) = @_;
    my $paymentSpinBox = waitForObject("{buddy=':Make Payment." .
            "This Payment:_QLabel' type='QSpinBox' unnamed='1' visible='1'}");
    test::verify($paymentSpinBox->minimum == $minimum);
    test::verify($paymentSpinBox->maximum == $maximum);
}
