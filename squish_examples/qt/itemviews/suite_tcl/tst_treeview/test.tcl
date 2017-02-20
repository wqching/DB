proc checkAnItem {indent index treeView model selectionModel} {
    if {$indent > -1 && [invoke $index isValid]} {
        set text [toString [invoke [invoke $model data $index] toString]]
        set checked ""
        set selected ""
        set checkState [invoke [invoke $model data $index \
            [enum Qt CheckStateRole]] toInt]
        if {$checkState == [enum Qt Checked]} {
            set checked " +checked"
        }
        if [invoke $selectionModel isSelected $index] {
            set selected " +selected"
        }
        set pad [string repeat " " $indent]
        test log "|$pad'$text'$checked$selected"
    } else {
        set indent [expr -4]
    }
    # Only show visible child items
    if {[invoke $index isValid] && \
        [invoke $treeView isExpanded $index] || \
        ![invoke $index isValid]} {
        for {set row 0} {$row < [invoke $model rowCount $index]} \
            {incr row} {
            checkAnItem [expr $indent + 4] [invoke $model index \
                $row 0 $index] $treeView $model $selectionModel
        }
    }
}
        
proc main {} {
    startApplication "itemviews"
    set treeViewName {{type='QTreeView' unnamed='1' visible='1'}}
    set treeView [waitForObject $treeViewName]
    set model [invoke $treeView model]
    set selectionModel [invoke $treeView selectionModel]
    checkAnItem -1 [construct QModelIndex] $treeView $model \
        $selectionModel
}
