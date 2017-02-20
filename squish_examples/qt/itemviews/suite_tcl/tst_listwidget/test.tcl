proc main {} {
    startApplication "itemviews"
    set listWidgetName {{type='QListWidget' unnamed='1' visible='1'}}
    set listWidget [waitForObject $listWidgetName]
    for {set row 0} {$row < [property get $listWidget count]} {incr row} {
        set item [invoke $listWidget item $row]
        set checked ""
        set selected ""
        if {[invoke $item checkState] == [enum Qt Checked]} {
            set checked " +checked"
        }
        if [invoke $item isSelected] {
            set selected " +selected"
        }
        set text [toString [invoke $item text]]
        test log "($row) '$text'$checked$selected"
    }
}
