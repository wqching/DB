function main()
{
    startApplication("csvtable");
    // Load data from an external file
    infile = findFile("testdata", "before.csv");
    infile = infile.replace(/[\/]/g, File.separator);
    test.log("Reading " + infile);
    file = File.open(infile, "r");
    var lines = [];
    var i = 0;
    while (true) {
        var line = file.readln();
        if (line == null)
            break;
        lines[i++] = line;
    }
    file.close();
    test.verify(lines.length == 13);

    // Save data to an external file
    outfile = infile + ".tmp";
    var i = outfile.lastIndexOf(File.separator);
    if (i > -1)
        outfile = outfile.substr(i + 1);
    outfile = OS.cwd().replace(/[\/]/g, File.separator) + File.separator + outfile;
    test.log("Writing " + outfile);
    file = File.open(outfile, "w")
    for (var i in lines)
        file.write(lines[i] + "\n");
//    file.write("X\n"); // Uncomment this to make the files different
    file.close();

    // Compare two external files
    var diff = OS.name == "Windows" ? "fc" : "diff";
    var command = diff;
    command += ' "' + infile + '" "' + outfile + '"';
    var result = OS.system(command);
    test.verify(result == 0,
                "infile and outfile equal according to " + diff);
    
    // Delete external file
    File.remove(outfile);
    
    // Check the existence of external files
    test.verify(File.exists(infile), "infile correctly present");
    test.verify(!File.exists(outfile), "outfile sucessfully deleted");
    
    // Access environment variables
    var keys = ["HOME", "PATH", "MY_ENV_VAR"];
    for (i in keys)
        test.log(keys[i] + " = " + OS.getenv(keys[i]));
}
