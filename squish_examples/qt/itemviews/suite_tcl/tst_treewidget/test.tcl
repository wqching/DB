proc checkAnItem {indent item root} {
    if {$indent > -1} {
        set checked ""
        set selected ""
        if {[invoke $item checkState 0] == [enum Qt Checked]} {
            set checked " +checked"
        }
        if [invoke $item isSelected] {
            set selected " +selected"
        }
        set text [toString [invoke $item text 0]]
        set pad [string repeat " " $indent]
        test log "|$pad'$text'$checked$selected"
    } else {
        set indent [expr -4]
    }
    # Only show visible child items
    if {$item != $root && [invoke $item isExpanded] || $item == $root} {
        for {set row 0} {$row < [invoke $item childCount]} {incr row} {
            checkAnItem [expr $indent + 4] [invoke $item child $row] \
                $root
        }
    }
}
       
proc main {} {
    startApplication "itemviews"
    set treeWidgetName {{type='QTreeWidget' unnamed='1' visible='1'}}
    set treeWidget [waitForObject $treeWidgetName]
    set root [invoke $treeWidget invisibleRootItem]
    checkAnItem -1 $root $root
}
