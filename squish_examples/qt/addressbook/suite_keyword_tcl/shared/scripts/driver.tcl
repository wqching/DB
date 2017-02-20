source [findFile "scripts" "actions.tcl"]

proc drive {datafile} {
    test log "Drive: '$datafile'"
    set data [testData dataset $datafile]
    for {set row 0} {$row < [llength $data]} {incr row} {
        set command [testData field [lindex $data $row] "Keyword"]
        for {set i 1} {$i <= 4} {incr i} {
            set arg [testData field [lindex $data $row] "Argument $i"]
            if {$arg != ""} {
                set command "${command} \"${arg}\""
            } else {
                break
            }
        }
        test log "Execute: $command"
        eval $command
    }
}
