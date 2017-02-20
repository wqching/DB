def checkAnItem(indent, index, treeView, model, selectionModel):
    if indent > -1 and index.isValid():
        text = model.data(index).toString()
        checked = selected = ""
        checkState = model.data(index, Qt.CheckStateRole).toInt()
        if checkState == Qt.Checked:
            checked = " +checked"
        if selectionModel.isSelected(index):
            selected = " +selected"
        test.log("|%s'%s'%s%s" % (" " * indent, text, checked, selected))
    else:
        indent = -4
    # Only show visible child items
    if (index.isValid() and treeView.isExpanded(index) or
        not index.isValid()):
        for row in range(model.rowCount(index)):
            checkAnItem(indent + 4, model.index(row, 0, index),
                        treeView, model, selectionModel)

        
def main():
    startApplication("itemviews")
    treeViewName = "{type='QTreeView' unnamed='1' visible='1'}"
    treeView = waitForObject(treeViewName)
    model = treeView.model()
    selectionModel = treeView.selectionModel()
    checkAnItem(-1, QModelIndex(), treeView, model, selectionModel)
