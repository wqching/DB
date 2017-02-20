def checkAnItem(indent, item, root):
    if indent > -1:
        checked = selected = ""
        if item.checkState(0) == Qt.Checked:
            checked = " +checked"
        if item.isSelected():
            selected = " +selected"
        test.log("|%s'%s'%s%s" % (" " * indent, item.text(0), checked,
                                  selected))
    else:
        indent = -4
    # Only show visible child items
    if item != root and item.isExpanded() or item == root:
        for row in range(item.childCount()):
            checkAnItem(indent + 4, item.child(row), root)
       
def main():
    startApplication("itemviews")
    treeWidgetName = "{type='QTreeWidget' unnamed='1' visible='1'}"
    treeWidget = waitForObject(treeWidgetName)
    root = treeWidget.invisibleRootItem()
    checkAnItem(-1, root, root)
