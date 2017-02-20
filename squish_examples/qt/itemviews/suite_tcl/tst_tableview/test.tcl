proc main {} {
    startApplication "itemviews"
    set tableViewName {{type='QTableView' unnamed='1' visible='1'}}
    set tableView [waitForObject $tableViewName]
    set model [invoke $tableView model]
    set selectionModel [invoke $tableView selectionModel]
    for {set row 0} {$row < [invoke $model rowCount]} {incr row} {
        for {set column 0} {$column < [invoke $model columnCount]} \
            {incr column} {
            set index [invoke $model index $row $column]
            set text [toString [invoke [invoke $model data $index] \
                toString]]
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
            test log "($row, $column) '$text'$checked$selected"
        }
    }
}
