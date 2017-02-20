# This test case will use the demo Qt4 application called widgets from the squish distribution.
# You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
#
# The test case will loop through each item in the tree widget and print out each parent and child item. 

def main(): 
    # Setup.  We first need to get to the correct tab in our test application
    tabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar"
    waitForObject(tabWidgetName)
    clickTab(tabWidgetName, "Tree")
    # We should now be on the "Tree" tab
    
    widgetTreeControl = ":A standard tree control_QTreeWidget" 
 
    waitForObject(widgetTreeControl) 
    obj_QTreeWidget = findObject(widgetTreeControl) 
    obj_QTreeWidgetItem = obj_QTreeWidget.invisibleRootItem() 
    rootItemsCount = obj_QTreeWidgetItem.childCount() 
    test.log("Number of Root Items %d" % rootItemsCount) 
 
    for i in range(rootItemsCount):
        obj_QTreeWidgetItem_TopLevel = obj_QTreeWidgetItem.child(i) 
 
        # Get name of top level item at position i in column 0 
        nameOfRootItem = obj_QTreeWidgetItem_TopLevel.text(0) 
        test.log("Name of Root Item: %s" % nameOfRootItem) 
 
        # Get number of children under the top level item at position $i 
        childItemsCount = obj_QTreeWidgetItem_TopLevel.childCount() 
        test.log("Number of Child Items under %s = %d" % (nameOfRootItem,childItemsCount)) 
 
        for j in range(childItemsCount):
            obj_QTreeWidgetItem_ChildLevel = obj_QTreeWidgetItem_TopLevel.child(j) 
            # Get name of child item at position j in column 0 
            nameOfChildItem = obj_QTreeWidgetItem_ChildLevel.text(0) 
            test.log("NAME %s" % nameOfChildItem) 
