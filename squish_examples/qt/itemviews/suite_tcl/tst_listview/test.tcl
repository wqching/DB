proc main {} {
    startApplication "itemviews"
    set listViewName {{type='QListView' unnamed='1' visible='1'}}
    set listView [waitForObject $listViewName]
    set model [invoke $listView model]
    set selectionModel [invoke $listView selectionModel]
    for {set row 0} {$row < [invoke $model rowCount]} {incr row} {
        set index [invoke $model index $row 0]
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
        test log "($row) '$text'$checked$selected"
    }
}
