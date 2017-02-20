# DEPRECATED: THIS SCRIPT IS NOT RECOMMENDED USE squishruntests.py INSTEAD
# Copyright (c) 2008-12 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,
# distributed, and modified, without limitation.

# adjust the variables to match your setup
import os

# base directory of Squish
home = os.path.expanduser("~")
squishdir = os.path.join(home, "src/squish")

# directory to which the HTML results should be written
outdir = os.path.join(home, "results")

# list of test suites to execute
suites = [
    os.path.join(squishdir, "examples", "qt4", "suite_addressbook_py"),
    os.path.join(squishdir, "examples", "qt4", "suite_addressbook_js"),
]

# list of hosts on which the suites should be executed
hosts = [
    "127.0.0.1",
]
