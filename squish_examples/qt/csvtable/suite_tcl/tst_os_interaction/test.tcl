proc main {} {
    startApplication "csvtable"
    # Load data from an external file
    set infile [file nativename [findFile "testdata" "before.csv"]]
    test log "Reading $infile"
    set fh [open $infile]
    set text [read $fh]
    close $fh
    set text [string trimright $text]
    set lines [split $text "\n"]
    test compare [llength $lines] 13
    
    # Save data to an external file
    set outfile [file nativename [file join [pwd] [file tail "$infile.tmp"]]]
    test log "Writing $outfile"
    set fh [open $outfile "w"]
    foreach line $lines {
        puts $fh $line
    }
    # Uncomment the next line to make the files different
    #puts $fh "X"
    close $fh
    
    # Compare two external files
    if {$::tcl_platform(platform) eq "windows"} {
        set diff "fc"
    } else {
        set diff "diff"
    }
    set result 0
    if {[catch {exec $diff $infile $outfile} message options]} {
        set details [dict get $options -errorcode]
        if {[lindex $details 0] eq "CHILDSTATUS"} {
            set result [lindex $details 2]
            test fail "infile and outfile not equal according to $diff"
        } else {
            test fail "Failed to get $diff's result"
        }
    } else {
        test pass "infile and outfile equal according to $diff"
    }

    # Delete external file
    file delete $outfile
    
    # Check the existence of external files
    test verify [file exists $infile] "infile correctly present"
    test verify [expr ![file exists $outfile]] "outfile sucessfully deleted"
    
    # Access environment variables
    global env
    foreach key {"HOME" "PATH" "MY_ENV_VAR"} {
        set value ""
        if {[catch {set value $env($key)}]} {
            # do nothing for missing key: empty default value is fine
        }
        test log "$key = $value"
    }
}
