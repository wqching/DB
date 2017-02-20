use warnings;
use File::Basename;
use File::Spec;

sub main
{
    startApplication("csvtable");
    my $sep = File::Spec->rootdir();

    # Load data from an external file
    my $infile = findFile("testdata", "before.csv");
    $infile =~ s,/,$sep,g;
    test::log("Reading $infile");
    open(FILE, "<:encoding(UTF-8)", $infile) or test::fail("Failed to read $infile");
    my @lines = <FILE>;
    close(FILE);
    test::verify(scalar(@lines) == 13);

    # Save data to an external file
    my $outfile = File::Spec->rel2abs(basename($infile) . ".tmp");
    $outfile =~ s,/,$sep,g;
    test::log("Writing $outfile");
    open(FILE, ">:encoding(UTF-8)", $outfile) or test::fail("Failed to write $outfile");
    print FILE @lines;
#    print FILE "X\n"; # Uncomment this to make the files different
    close(FILE);

    # Compare two external files
    my $diff = $^O eq "MSWin32" ? "fc" : "diff";
    my $command = "$diff \"$infile\" \"$outfile\"";
    system($command);
    my $result = $? >> 8;
    test::verify($result == 0, "infile and outfile equal according to $diff");

    # Delete external file
    unlink $outfile;

    # Check the existence of external files
    test::verify(-e $infile, "infile correctly present");
    test::verify(!-e $outfile, "outfile sucessfully deleted");

    # Print the Squish environment
    for my $key ("HOME", "PATH", "MY_ENV_VAR") {
        test::log("$key = $ENV{$key}");
    }
}
