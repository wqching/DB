/*
    Copyright (c) 2008 froglogic GmbH. All rights reserved.

    This file is part of an example program for Squish---it may be used,
    distributed, and modified, without limitation.
*/

#include "mainwindow.h"
#include <qcheckbox.h>
#include <qcombobox.h>
#include <qdatetimeedit.h>
#include <qdialogbuttonbox.h>
#include <qspinbox.h>
#include <qgridlayout.h>
#include <qlabel.h>
#include <qlineedit.h>
#include <qpushbutton.h>
#include <qradiobutton.h>
#include <qstackedwidget.h>
#include <qtimer.h>


MainWindow::MainWindow(QWidget *parent)
    : QDialog(parent)
{
    QLabel *invoiceLabel = new QLabel(tr("In&voice:"));
    invoiceComboBox = new QComboBox;
    invoiceLabel->setBuddy(invoiceComboBox);
    for (int x = 12000; x < 13000; x += 100)
        invoiceComboBox->addItem(tr("AXV-%1").arg(x),
                                 QVariant(int(x - 10000)));
    invoiceComboBox->setCurrentIndex(0);
    QLabel *descLabel = new QLabel(tr("&Description:"));
    descLineEdit = new QLineEdit;
    descLabel->setBuddy(descLineEdit);
    QLabel *amountDueLabel = new QLabel(tr("Amount Due"));
    amountLabel = new QLabel;
    amountLabel->setObjectName("AmountDueLabel");
    amountLabel->setAlignment(Qt::AlignVCenter|Qt::AlignRight);
    QLabel *paymentLabel = new QLabel(tr("This &Payment:"));
    paymentSpinBox = new QSpinBox;
    paymentLabel->setBuddy(paymentSpinBox);
    paymentSpinBox->setAlignment(Qt::AlignVCenter|Qt::AlignRight);
    paymentSpinBox->setPrefix(tr("$ "));
    cashRadioButton = new QRadioButton(tr("Cas&h"));
    checkRadioButton = new QRadioButton(tr("Chec&k"));
    cardRadioButton = new QRadioButton(tr("C&redit Card"));
    cardRadioButton->setChecked(true);

    cashWidget = new QLabel(tr("Paying Cash"));
    cashWidget->setObjectName("CashWidget");
    cashWidget->setStyleSheet("color: brown; font-size: 30pt;");
    cashWidget->setAlignment(Qt::AlignCenter);

    checkWidget = new QWidget;
    checkWidget->setObjectName("CheckWidget");
    QLabel *bankNameLabel = new QLabel(tr("Bank Na&me:"));
    bankNameLineEdit = new QLineEdit;
    bankNameLabel->setBuddy(bankNameLineEdit);
    QLabel *bankNumberLabel = new QLabel(tr("&Bank Number:"));
    bankNumberLineEdit = new QLineEdit;
    bankNumberLabel->setBuddy(bankNumberLineEdit);
    QLabel *bankAccountNameLabel = new QLabel(tr("Account &Name:"));
    bankAccountNameLineEdit = new QLineEdit;
    bankAccountNameLabel->setBuddy(bankAccountNameLineEdit);
    QLabel *bankAccountNumberLabel = new QLabel(tr("&Account Number:"));
    bankAccountNumberLineEdit = new QLineEdit;
    bankAccountNumberLabel->setBuddy(bankAccountNumberLineEdit);
    QLabel *checkDateLabel = new QLabel(tr("&Check Date:"));
    checkDateEdit = new QDateEdit;
    checkDateLabel->setBuddy(checkDateEdit);
    checkSignedCheckBox = new QCheckBox(tr("Check &Signed"));
    QGridLayout *checkLayout = new QGridLayout;
    checkLayout->addWidget(bankNameLabel, 0, 0);
    checkLayout->addWidget(bankNameLineEdit, 0, 1);
    checkLayout->addWidget(bankNumberLabel, 0, 2);
    checkLayout->addWidget(bankNumberLineEdit, 0, 3);
    checkLayout->addWidget(bankAccountNameLabel, 1, 0);
    checkLayout->addWidget(bankAccountNameLineEdit, 1, 1);
    checkLayout->addWidget(bankAccountNumberLabel, 1, 2);
    checkLayout->addWidget(bankAccountNumberLineEdit, 1, 3);
    checkLayout->addWidget(checkDateLabel, 2, 0);
    checkLayout->addWidget(checkDateEdit, 2, 1);
    checkLayout->addWidget(checkSignedCheckBox, 2, 2, 1, 2);
    checkWidget->setLayout(checkLayout);

    cardWidget = new QWidget;
    cardWidget->setObjectName("CardWidget");
    QLabel *cardTypeLabel = new QLabel(tr("Card &Type:"));
    cardTypeComboBox = new QComboBox;
    cardTypeLabel->setBuddy(cardTypeComboBox);
    cardTypeComboBox->addItems(QStringList() << tr("Master")
                                             << tr("Visa"));
    QLabel *cardAccountNameLabel = new QLabel(tr("Account &Name:"));
    cardAccountNameLineEdit = new QLineEdit;
    cardAccountNameLabel->setBuddy(cardAccountNameLineEdit);
    QLabel *cardAccountNumberLabel = new QLabel(tr("&Account Number:"));
    cardAccountNumberLineEdit = new QLineEdit;
    cardAccountNumberLabel->setBuddy(cardAccountNumberLineEdit);
    QLabel *cardIssueDateLabel = new QLabel(tr("&Issue Date:"));
    cardIssueDateEdit = new QDateEdit;
    cardIssueDateLabel->setBuddy(cardIssueDateEdit);
    cardIssueDateEdit->setDisplayFormat(tr("MMM yyyy"));
    QLabel *cardExpiryDateLabel = new QLabel(tr("&Expiry Date:"));
    cardExpiryDateEdit = new QDateEdit;
    cardExpiryDateLabel->setBuddy(cardExpiryDateEdit);
    cardExpiryDateEdit->setDisplayFormat(tr("MMM yyyy"));
    QGridLayout *cardLayout = new QGridLayout;
    cardLayout->addWidget(cardTypeLabel, 0, 0);
    cardLayout->addWidget(cardTypeComboBox, 0, 1);
    cardLayout->addWidget(cardAccountNameLabel, 1, 0);
    cardLayout->addWidget(cardAccountNameLineEdit, 1, 1);
    cardLayout->addWidget(cardAccountNumberLabel, 1, 2);
    cardLayout->addWidget(cardAccountNumberLineEdit, 1, 3);
    cardLayout->addWidget(cardIssueDateLabel, 2, 0);
    cardLayout->addWidget(cardIssueDateEdit, 2, 1);
    cardLayout->addWidget(cardExpiryDateLabel, 2, 2);
    cardLayout->addWidget(cardExpiryDateEdit, 2, 3);
    cardWidget->setLayout(cardLayout);

    paymentMethodWidgets = new QStackedWidget;
    paymentMethodWidgets->addWidget(cashWidget);
    paymentMethodWidgets->addWidget(checkWidget);
    paymentMethodWidgets->addWidget(cardWidget);
    paymentMethodWidgets->setCurrentWidget(cardWidget);
    QDialogButtonBox *buttonBox = new QDialogButtonBox(
            QDialogButtonBox::Ok|QDialogButtonBox::Cancel);
    payButton = buttonBox->button(QDialogButtonBox::Ok);
    payButton->setText(tr("Pa&y"));
    payButton->setEnabled(false);
    cancelButton = buttonBox->button(QDialogButtonBox::Cancel);

    QGridLayout *layout = new QGridLayout;
    layout->addWidget(invoiceLabel, 0, 0);
    layout->addWidget(invoiceComboBox, 0, 1);
    layout->addWidget(descLabel, 0, 2);
    layout->addWidget(descLineEdit, 0, 3);
    layout->addWidget(amountDueLabel, 1, 0);
    layout->addWidget(amountLabel, 1, 1);
    layout->addWidget(paymentLabel, 1, 2);
    layout->addWidget(paymentSpinBox, 1, 3);
    QHBoxLayout *radioLayout = new QHBoxLayout;
    radioLayout->addWidget(cashRadioButton);
    radioLayout->addWidget(checkRadioButton);
    radioLayout->addWidget(cardRadioButton);
    radioLayout->addStretch();
    layout->addLayout(radioLayout, 3, 0, 1, 4);
    layout->addWidget(paymentMethodWidgets, 4, 0, 1, 4);
    layout->addWidget(buttonBox, 5, 0, 1, 4);
    setLayout(layout);

    connect(bankNameLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(bankNumberLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(bankAccountNameLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(bankAccountNumberLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(checkSignedCheckBox, SIGNAL(toggled(bool)),
            this, SLOT(updateUi()));
    connect(cardTypeComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(updateUi()));
    connect(cardAccountNameLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(cardAccountNumberLineEdit, SIGNAL(textChanged(const QString&)),
            this, SLOT(updateUi()));
    connect(checkDateEdit, SIGNAL(dateChanged(const QDate&)),
            this, SLOT(updateUi()));
    connect(cardIssueDateEdit, SIGNAL(dateChanged(const QDate&)),
            this, SLOT(updateUi()));
    connect(cardExpiryDateEdit, SIGNAL(dateChanged(const QDate&)),
            this, SLOT(updateUi()));
    connect(cashRadioButton, SIGNAL(clicked(bool)),
            this, SLOT(updateUi()));
    connect(checkRadioButton, SIGNAL(clicked(bool)),
            this, SLOT(updateUi()));
    connect(cardRadioButton, SIGNAL(clicked(bool)),
            this, SLOT(updateUi()));
    connect(invoiceComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(updateUi()));
    connect(payButton, SIGNAL(clicked()), this, SLOT(accept()));
    connect(cancelButton, SIGNAL(clicked()), this, SLOT(reject()));

    setWindowTitle(tr("Make Payment"));
    QTimer::singleShot(0, this, SLOT(updateUi()));
}


void MainWindow::updateUi()
{
    // Amount depends on the invoice
    int index = invoiceComboBox->currentIndex();
    double due = 0.0;
    bool ok = false;
    if (index > -1 && index < invoiceComboBox->count()) {
        due = invoiceComboBox->itemData(index).toDouble(&ok);
    }
    if (ok) {
        amountLabel->setText(tr("$%L1").arg(due));
    }
    else {
        amountLabel->clear();
    }

    // Payment method and business logic
    QDate today(QDate::currentDate());
    if (cashRadioButton->isChecked()) {
        paymentMethodWidgets->setCurrentWidget(cashWidget);
        paymentSpinBox->setRange(1, qMin(2000, int(due)));
        payButton->setEnabled(true);
    }
    else if (checkRadioButton->isChecked()) {
        paymentMethodWidgets->setCurrentWidget(checkWidget);
        paymentSpinBox->setRange(10, qMin(250, int(due)));
        checkDateEdit->setDateRange(today.addDays(-30), today.addDays(1));
        payButton->setEnabled(
                (!bankNameLineEdit->text().isEmpty()) &&
                (!bankNumberLineEdit->text().isEmpty()) &&
                (!bankAccountNameLineEdit->text().isEmpty()) &&
                (!bankAccountNumberLineEdit->text().isEmpty()) &&
                checkSignedCheckBox->isChecked());
    }
    else if (cardRadioButton->isChecked()) {
        paymentMethodWidgets->setCurrentWidget(cardWidget);
        paymentSpinBox->setRange(qMax(10, int(due / 20)),
                                 qMin(5000, int(due)));
        cardIssueDateEdit->setDateRange(today.addYears(-3),
                                        today.addMonths(-1));
        cardExpiryDateEdit->setDateRange(today.addMonths(1),
                                         today.addYears(5));
        payButton->setEnabled(
                (!cardAccountNameLineEdit->text().isEmpty()) &&
                (!cardAccountNumberLineEdit->text().isEmpty()));
    }
}


void MainWindow::accept()
{
    // In a real app we'd give details to the caller but here we don't
    // care
    QDialog::accept();
}
