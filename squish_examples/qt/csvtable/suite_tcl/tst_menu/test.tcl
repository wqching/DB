proc main {} {
    startApplication "csvtable"
    # Activate the menu bar
    waitForObject ":CSV Table_QMenuBar"
    # Activate the menu we want
    invoke activateItem ":CSV Table_QMenuBar" "Edit"
    # Retrieve the menu we want
    set menu [waitForObject ":CSV Table.Edit_QMenu"]
    set actions [invoke $menu actions]
    for {set index 0} {$index < [invoke $actions count]} {incr index} {
        set action [invoke $actions at $index]
        if {![invoke $action isSeparator]} {
            set active "Inactive"
            if {[property get $action enabled]} {
                set active "Active"
            }
            set text [toString [property get $action text]]
            test log "Menu option '$text' is $active"
        }
    }
    # Close the menu
    invoke type $menu "<Escape>"
}
