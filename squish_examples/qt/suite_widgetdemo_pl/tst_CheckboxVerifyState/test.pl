# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will verify that the checkbox titled "Test 1" in the 
# Groupbox called "Check Boxes" on the tab called "Check Box" starts in a checked state

sub main 
{
    # Setup.  We first need to get to the correct tab in our test application
    my $sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject("$sTabWidgetName");
    clickTab("$sTabWidgetName", "Check Box");
    # We should now be on the "Check Box" tab
    
    # Assign widget names to local variables for widgets we are going to test
    my $sWidgetName = ':Check Boxes.Test 1_QCheckBox';

    # Wait for widget to appear
    waitForObject("$sWidgetName");

    # Assign current value to local variable
    my $obj_QCheckBox = findObject("$sWidgetName");
    my $iCurrentValue = $obj_QCheckBox->checked;

    # You could also do previous 2 lines in one line by doing
    # my $iCurrentValue = findObject("$sWidgetName1")->checked;

    test::log("The current value of the checkbox is $iCurrentValue");

    # Let us test to make sure the checkbox is "checked".  If we were checking to see if
    # the checkbox was unchecked, we would use a 0 instead of a 1.
    test::compare($iCurrentValue, 1);
}
