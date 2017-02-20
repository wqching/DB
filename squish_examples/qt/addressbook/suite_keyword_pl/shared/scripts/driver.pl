source( findFile( "scripts", "actions.pl" ) );

sub drive {
    my $datafile = shift;
    test::log("Drive: '$datafile'");
    my @records = testData::dataset($datafile);
    for ( my $row = 0 ; $row < scalar(@records) ; ++$row ) {
        my $command = testData::field( $records[$row], "Keyword" ) . "(";
        my $comma = "";
        for ( my $i = 1 ; $i <= 4 ; ++$i ) {
            my $arg = testData::field( $records[$row], "Argument $i" );
            if ( $arg ne "" ) {
                $command .= "$comma\"$arg\"";
                $comma = ", ";
            }
            else {
                last;
            }
        }
        $command .= ");";
        test::log("Execute: $command");
        eval $command;
    }
}
