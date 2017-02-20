#include "main.h"

#include <qapplication.h>
#include <qbuttongroup.h>
#include <qcheckbox.h>
#include <qcombobox.h>
#include <qgroupbox.h>
#include <qlabel.h>
#include <qlayout.h>
#include <qlineedit.h>
#include <qlistwidget.h>
#include <qmenu.h>
#include <qmenubar.h>
#include <qpushbutton.h>
#include <qradiobutton.h>
#include <qspinbox.h>
#include <qstatusbar.h>
#include <qtablewidget.h>
#include <qtabwidget.h>
#include <qtoolbar.h>
#include <qtreewidget.h>

#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
#  include "../../../include/qtbuiltinhook.h"
#endif

WidgetDemoPage::WidgetDemoPage( const QString &text, QWidget *w, QWidget *parent )
    : QWidget( parent )
{
    QLabel *label = new QLabel( text, this );

    QVBoxLayout *layout = new QVBoxLayout( this );
    layout->setMargin( 16 );
    layout->addWidget( label, 0 );
    layout->addWidget( w, 1, Qt::AlignCenter );
}

static QTreeWidgetItem* createTreeWidgetItem( QTreeWidgetItem* parent, const QString& text )
{
    QTreeWidgetItem* item = new QTreeWidgetItem( parent );
    item->setText( 0, text );
    return item;
}

int main( int argc, char **argv )
{
    QApplication app( argc, argv );

#if defined(Q_OS_AIX) || defined(Q_OS_VXWORKS)
    Squish::installBuiltinHook(); // On AIX/VxWorks we must manually install a hook
#endif

    QWidget *centralWidget = new QWidget;

    QTabWidget *tw = new QTabWidget;
    tw->addTab( new WidgetDemoPage( "This is a simple QPushButton control", new QPushButton( "Press Me!" ) ),
                "Push Button" );

    {
        QGroupBox *gb1 = new QGroupBox( "Check Boxes");
        gb1->setCheckable(true);
        gb1->setChecked(true);
        gb1->setMinimumWidth( 200 );


        QCheckBox *checkBox1 = new QCheckBox("Test 1", gb1 );
        checkBox1->setChecked(true);
        QCheckBox *checkBox2 = new QCheckBox("Test 2", gb1 );
        checkBox2->setChecked(false);

        QVBoxLayout *layout1 = new QVBoxLayout ( gb1 );
        layout1->addWidget( checkBox1 );
	layout1->addWidget( checkBox2 );

        tw->addTab( new WidgetDemoPage( "This is a simple QCheckBox control", gb1 ), "Check Box" );
    }

    {
        QGroupBox *gb = new QGroupBox( "Colors" );

        QRadioButton *btn1 = new QRadioButton( "Blue", gb );
        QRadioButton *btn2 = new QRadioButton( "White", gb );
        QRadioButton *btn3 = new QRadioButton( "Green", gb );
        btn2->setChecked(true);

        QButtonGroup *btnGroup = new QButtonGroup;
        btnGroup->addButton( btn1 );
        btnGroup->addButton( btn2 );
        btnGroup->addButton( btn3 );

        QVBoxLayout *layout = new QVBoxLayout( gb );
        layout->addWidget( btn1 );
        layout->addWidget( btn2 );
        layout->addWidget( btn3 );

        tw->addTab( new WidgetDemoPage( "Here you can see a few QRadioButton controls", gb ),
                    "Radio Buttons" );
    }

    {
        QTableWidget *table = new QTableWidget( 4, 3 );
        table->setMinimumWidth( 400 );
        table->setHorizontalHeaderLabels( QStringList() << "Car" << "Color" << "Year");
//        for ( int row = 0; row < table->rowCount(); ++row ) {
//           for ( int col = 0; col < table->columnCount(); ++col ) {
//                table->setItem( row, col, new QTableWidgetItem( QString( "Cell %1/%2" ).arg( row ).arg( col ) ) );
//            }
//        }
        table->setItem( 0, 0, new QTableWidgetItem( QString( "BMW" ) ) );
        table->setItem( 0, 1, new QTableWidgetItem( QString( "Red" ) ) );
        table->setItem( 0, 2, new QTableWidgetItem( QString( "2005" ) ) );

        table->setItem( 1, 0, new QTableWidgetItem( QString( "VM" ) ) );
        table->setItem( 1, 1, new QTableWidgetItem( QString( "Blue" ) ) );
        table->setItem( 1, 2, new QTableWidgetItem( QString( "2006" ) ) );

        table->setItem( 2, 0, new QTableWidgetItem( QString( "Mercedes" ) ) );
        table->setItem( 2, 1, new QTableWidgetItem( QString( "White" ) ) );
        table->setItem( 2, 2, new QTableWidgetItem( QString( "2007" ) ) );

        table->setItem( 3, 0, new QTableWidgetItem( QString( "Porsche" ) ) );
        table->setItem( 3, 1, new QTableWidgetItem( QString( "Black" ) ) );
        table->setItem( 3, 2, new QTableWidgetItem( QString( "2008" ) ) );

        tw->addTab( new WidgetDemoPage( "A standard table control", table ),
                      "Table" );
    }

    {
        QListWidget *list = new QListWidget;
        list->addItems( QStringList() << "Berlin" << "Paris" << "Rome" << "Amsterdam" << "Helsinki" );
        tw->addTab( new WidgetDemoPage( "A standard list control", list ), "List" );
    }

    {
        QTreeWidget *tree = new QTreeWidget;

        QTreeWidgetItem *topItem = new QTreeWidgetItem( tree );
        topItem->setText( 0, "Germany" );
        topItem->addChild( createTreeWidgetItem( topItem, "Berlin" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Hamburg" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Munich" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Buxtehude" ) );
        tree->addTopLevelItem( topItem );

        topItem = new QTreeWidgetItem( tree );
        topItem->setText( 0, "Norway" );
        topItem->addChild( createTreeWidgetItem( topItem, "Oslo" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Bergen" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Trondheim" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Stavanger" ) );
        tree->addTopLevelItem( topItem );

        topItem = new QTreeWidgetItem( tree );
        topItem->setText( 0, "Spain" );
        topItem->addChild( createTreeWidgetItem( topItem, "Madrid" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Barcelona" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Valencia" ) );
        topItem->addChild( createTreeWidgetItem( topItem, "Seville" ) );
        tree->addTopLevelItem( topItem );

        tw->addTab( new WidgetDemoPage( "A standard tree control", tree ), "Tree" );
    }

    {
        QTabWidget *tabs = new QTabWidget;
        tabs->addTab( new QLabel( "Content of first tab" ), "First Tab" );
        tabs->addTab( new QLabel( "Content of second tab" ), "Second Tab" );
        tabs->addTab( new QLabel( "Content of third tab" ), "Third Tab" );
        tabs->setMinimumSize( 400, 300 );

        tw->addTab( new WidgetDemoPage( "A standard tab control", tabs ), "Tab Control" );
    }

    {
        QWidget *w = new QWidget;

        QLabel *l = new QLabel( "First Name:", w );
        QLineEdit *lineEdit = new QLineEdit( w );

        QHBoxLayout *layout = new QHBoxLayout( w );
        layout->addWidget( l );
        layout->addWidget( lineEdit );

        tw->addTab( new WidgetDemoPage( "A standard line edit control", w ), "Line Edit" );
    }

    {
        QWidget *w = new QWidget;

        QLabel *l = new QLabel( "Update Interval:", w );
        QSpinBox *sb = new QSpinBox( w );
        sb->setMinimum( -100 );
        sb->setMaximum( 100 );
        sb->setValue( 20 );
        sb->setSingleStep( 5 );

        QHBoxLayout *layout = new QHBoxLayout( w );
        layout->addWidget( l );
        layout->addWidget( sb );

        tw->addTab( new WidgetDemoPage( "A standard spinbox control", w ), "Spinbox" );
    }

    {
        QWidget *w = new QWidget;

        QLabel *l = new QLabel( "Favorite Food", w );
        QComboBox *cb = new QComboBox( w );
        cb->addItems( QStringList() << "Pizza" << "Pasta" << "Burger" );

        QHBoxLayout *layout = new QHBoxLayout( w );
        layout->addWidget( l );
        layout->addWidget( cb );

        tw->addTab( new WidgetDemoPage( "A standard combobox control", w ), "Combobox" );
    }

    {
        QWidget *w = new QWidget;


        tw->addTab( new WidgetDemoPage( "A simple menu", w ), "Menus" );
    }

    QMenuBar *mb = new QMenuBar;
    {
        QMenu *mnu = new QMenu( "&File" );
        mnu->addAction( "Menu Item &1" );
        mnu->addAction( "Menu Item &2" );
        mnu->addAction( "Menu Item &3" );
        mnu->addSeparator();
        mnu->addAction( "&Quit", qApp, SLOT( quit() ) );
        mb->addMenu( mnu );

        mnu = new QMenu( "Sample Menu &1" );
        mnu->addAction( "Item &1" );
        mnu->addAction( "Item &2" );
        mnu->addAction( "Item &3" );
        mb->addMenu( mnu );

        mnu = new QMenu( "Sample Menu &2" );
        mnu->addAction( "Item &1" );
        mnu->addAction( "Item &2" );
        mnu->addAction( "Item &3" );
        mb->addMenu( mnu );
    }

    QToolBar *tb = new QToolBar;
    tb->addAction( "Tool 1" );
    tb->addAction( "Tool 2" );
    tb->addAction( "Tool 3" );

#ifndef QT_NO_STATUSBAR
    QStatusBar *sb = new QStatusBar;
    sb->showMessage( "Application Ready!" );
#endif

    QVBoxLayout *topLayout = new QVBoxLayout( centralWidget );
    topLayout->setMargin( 0 );
    topLayout->addWidget( mb );
    topLayout->addWidget( tb );
    topLayout->addWidget( tw );
#ifndef QT_NO_STATUSBAR
    topLayout->addWidget( sb );
#endif

    centralWidget->setWindowTitle( "Qt Widget Sample" );
    centralWidget->show();

    return app.exec();
}

