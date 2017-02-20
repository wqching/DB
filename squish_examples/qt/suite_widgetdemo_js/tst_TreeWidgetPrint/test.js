// This test case will use the demo Qt4 application called widgets from the squish distribution.
// You can find this application in your squish application directory at: SQUISHROOT/examples/qt/widgets/
//
// The test case will loop through each item in the tree widget and print out each parent and child item. 

function main()
{
    // Setup.  We first need to get to the correct tab in our test application
    var sTabWidgetName = ":Qt Widget Sample.qt_tabwidget_tabbar_QTabBar";
    waitForObject(sTabWidgetName);
    clickTab(sTabWidgetName, "Tree");
    // We should now be on the "Tree" tab
    
    var sWidgetTreeControl = ":A standard tree control_QTreeWidget"; 
 
    waitForObject(sWidgetTreeControl); 
    var obj_QTreeWidget = findObject(sWidgetTreeControl); 
    var obj_QTreeWidgetItem = obj_QTreeWidget.invisibleRootItem(); 
    var iNumberOfRootItems = obj_QTreeWidgetItem.childCount(); 
    test.log("Number of Root Items " + iNumberOfRootItems); 
 
    var i = 0; 
    while (i < iNumberOfRootItems) 
    { 
        var obj_QTreeWidgetItem_TopLevel = obj_QTreeWidgetItem.child(i); 
 
        // Get name of top level item at position i in column 0 
        var sNameOfRootItem = obj_QTreeWidgetItem_TopLevel.text(0); 
        test.log("Name of Root Item: " + sNameOfRootItem); 
 
        // Get number of children under the top level item at position i 
        var iNumberOfChildItems = obj_QTreeWidgetItem_TopLevel.childCount(); 
        test.log("Number of Child Items under " + sNameOfRootItem + " = " + iNumberOfChildItems); 
 
        var j=0; 
        while (j < iNumberOfChildItems) 
        { 
            var obj_QTreeWidgetItem_ChildLevel = obj_QTreeWidgetItem_TopLevel.child(j); 
            // Get name of child item at position j in column 0 
            var sNameOfChildItem = obj_QTreeWidgetItem_ChildLevel.text(0); 
            test.log("NAME " + sNameOfChildItem); 
            j++; 
        } 
        i++; 
    }
}
