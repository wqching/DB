import codecs
import filecmp
import os
import subprocess
import sys

def main():
    startApplication("csvtable")
    # Load data from an external file
    infile = findFile("testdata", "before.csv")
    infile = infile.replace("/", os.sep)
    test.log("Reading %s" % infile)
    file = codecs.open(infile, "r", "utf-8")
    lines = []
    for line in file:
        lines.append(line)
    file.close()
    test.verify(len(lines) == 13)
    
    # Save data to an external file
    outfile = os.path.join(os.getcwd(), os.path.basename(infile) + ".tmp")
    outfile = outfile.replace("/", os.sep)
    test.log("Writing %s" % outfile)
    file = codecs.open(outfile, "w", "utf-8")
    for line in lines:
        file.write(line)
#    file.write("X") # Uncomment this to make the files different
    file.close()
    
    # Compare two external files
    test.verify(filecmp.cmp(infile, outfile, False),
        "infile and outfile equal according to filecmp library")
    
    if sys.platform in ("win32", "cygwin"):
        command = ["fc"]
    else:
        command = ["diff"]
    command.extend(('"%s"' % infile, '"%s"' % outfile))
    result = subprocess.call(" ".join(command), shell=True)
    test.verify(result == 0, "infile and outfile equal according to %s" % (
        command[0]))
    
    # Delete external file
    os.remove(outfile)
    
    # Check the existence of external files
    test.verify(os.path.exists(infile), "infile correctly present")
    test.verify(not os.path.exists(outfile), "outfile sucessfully deleted")
    
    # Access environment variables
    for key in ("HOME", "PATH", "MY_ENV_VAR"):
        test.log("%s = %s" % (key, os.environ.get(key)))