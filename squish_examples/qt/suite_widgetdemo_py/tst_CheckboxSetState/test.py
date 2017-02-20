# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will verify that the checkbox titled "Test 2" in the 
# Groupbox called "Check Boxes" on the tab called "Check Box" starts in a unchecked state.
# If it does, it will toggle the checkbox to a checked state

def main():
    # Setup.  We first need to get to the correct tab in our test application
    tabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar"
    waitForObject(tabWidgetName)
    clickTab(tabWidgetName, "Check Box")
    # We should now be on the "Check Box" tab

    # Assign widget name to local variable
    widgetName = ':Check Boxes.Test 2_QCheckBox'

    # Wait for widget to appear
    waitForObject(widgetName)

    # In this example, we want the checkbox to be checked when we are done.  So lets start by assigning
    # the value 0 (for "unchecked") to a local variable. 
    wanted = 0

    # We need to know the current value of the checkbox
    checked = findObject(widgetName).checked

    if wanted != checked:
        test.log("We are changing the state of the checkbox, %s" % widgetName)
        clickButton(widgetName)
    else:
        test.log("We do not need to change the value of the checkbox, %s" % widgetName)

