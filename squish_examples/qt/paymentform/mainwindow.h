/*
    Copyright (c) 2008 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include <qdialog.h>

QT_BEGIN_NAMESPACE
class QCheckBox;
class QComboBox;
class QDateEdit;
class QLabel;
class QLineEdit;
class QPushButton;
class QRadioButton;
class QSpinBox;
class QStackedWidget;
QT_END_NAMESPACE


class MainWindow : public QDialog
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent=0);

public slots:
    void updateUi();
    void accept();

private:
    QComboBox *invoiceComboBox;
    QLineEdit *descLineEdit;
    QLabel *amountLabel;
    QSpinBox *paymentSpinBox;
    QRadioButton *cashRadioButton;
    QRadioButton *checkRadioButton;
    QRadioButton *cardRadioButton;
    QStackedWidget *paymentMethodWidgets;
    QLabel *cashWidget;
    QWidget *checkWidget;
    QWidget *cardWidget;
    QPushButton *payButton;
    QPushButton *cancelButton;
    QLineEdit *bankNameLineEdit;
    QLineEdit *bankNumberLineEdit;
    QLineEdit *bankAccountNameLineEdit;
    QLineEdit *bankAccountNumberLineEdit;
    QDateEdit *checkDateEdit;
    QCheckBox *checkSignedCheckBox;
    QComboBox *cardTypeComboBox;
    QLineEdit *cardAccountNameLineEdit;
    QLineEdit *cardAccountNumberLineEdit;
    QDateEdit *cardIssueDateEdit;
    QDateEdit *cardExpiryDateEdit;
};
