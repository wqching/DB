#! /usr/bin/env python
# DEPRECATED: THIS SCRIPT IS NOT RECOMMENDED USE squishruntests.py INSTEAD
# Copyright (c) 2008-12 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,
# distributed, and modified, without limitation.

# import necessary modules
import sys
import os
import os.path
from datetime import date
import tempfile
import xml2result2html as xmlresult2html
try:
    import runtests_config
except ImportError:
    print("Please copy the file runtests_config_demo.py to runtests_config.py\n"
          "and adjust the variables in it to match your Squish installation.")
    sys.exit(1)

def runTest(suite, host, htmloutput, title):
    """This functions runs the test suite 'suite' on the host 'host' and
       converts the XML result into HTML and saves that to 'htmloutput'."""
    resultFile, resultFilename = tempfile.mkstemp(
        suffix='.xml',
        prefix='squishresult-',
    )
    os.close(resultFile)
    cmd = "%s --host %s --testsuite \"%s\" --reportgen xml2,%s" % (
        os.path.join(runtests_config.squishdir, "bin", "squishrunner"),
        host,
        suite,
        resultFilename,
    )
    print("run " + suite + " on " + host)
    print(cmd)
    os.system(cmd)
    converter = xmlresult2html.HtmlConverter(
        title = title,
        results = [
            xmlresult2html.ResultParser(resultFilename),
        ]
    )
    open(htmloutput, "w").write(converter.html.encode('utf-8'))
    os.remove(resultFilename) # cleanup

index = "<h2>Test runs on " + str(date.today()) + "</h2>\n<ul>\n"
# loop over all test suites and hosts and call 'runTest'
for suite in runtests_config.suites:
    suitename = os.path.basename(suite)
    for host in runtests_config.hosts:
        file = "%s_%s_%s.html" % (
            date.today(),
            suitename,
            host,
        )
        title = "Suite '%s' on host '%s'" % (
            suitename,
            host,
        )
        runTest(suite, host, os.path.join(runtests_config.outdir, file), title)
        index += '<li><a href="%s">%s</a>\n' % (
            file,
            title,
        )
index += "</ul>\n"

# write links to the generated HTML reports into the index.html so one
# can view a summary of all results
indexHtml = os.path.join(runtests_config.outdir, "index.html")
if os.path.isfile(indexHtml):
    ifile = open(indexHtml, "r")
    index += ifile.read()
    ifile.close()

ifile = open(indexHtml, "w")
ifile.write(index)
ifile.close()
