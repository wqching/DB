# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will verify that the checkbox titled "Test 2" in the 
# Groupbox called "Check Boxes" on the tab called "Check Box" starts in a unchecked state.
# If it does, it will toggle the checkbox to a checked state

sub main 
{
    # Setup.  We first need to get to the correct tab in our test application
    my $sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject("$sTabWidgetName");
    clickTab("$sTabWidgetName", "Check Box");
    # We should now be on the "Check Box" tab

    # Assign widget name to local variable
    my $sWidgetName = ':Check Boxes.Test 2_QCheckBox';

    # Wait for widget to appear
    waitForObject("$sWidgetName");

    # In this example, we want the checkbox to be checked when we are done.  So lets start by assigning
    # the value "checked" to a local variable. 
    my $sDesiredValue = "checked";
    my $iDesiredValue;

    # Lets convert the string checked into a bit value.  For this example I choose to use a string as one 
    # might take this chunk of code and make a function or method out of it.  And with functions and methods
    # sometimes it is easier to pass in a human readable string name, rather than a bit value.
    if ($sDesiredValue eq "checked") { $iDesiredValue = 1; }
    elsif ($sDesiredValue eq "unchecked") { $iDesiredValue = 0; }

    # We need to know the current value of the checkbox
    my $iCurrentValue = findObject("$sWidgetName")->checked;

    if ($iDesiredValue != $iCurrentValue)
    {
        test::log("We are changing the state of the checkbox, $sWidgetName");
        clickButton("$sWidgetName");
    }
    else
    {
        test::log("We do not need to change the value of the checkbox, $sWidgetName");
    }
}
