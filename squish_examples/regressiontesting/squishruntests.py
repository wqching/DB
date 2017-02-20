#!/usr/bin/env python
# -*- encoding=utf8 -*-
# Copyright (c) 2009-15 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,
# distributed, and modified, without limitation.

from __future__ import nested_scopes
from __future__ import generators
from __future__ import division

import datetime
import optparse
import os
import re
import subprocess
import sys


def is_windows():
    platform = sys.platform.lower()
    return platform.startswith("win") or platform.startswith("microsoft")


INI_FILE = "runtests.ini"
RUNNER = "squishrunner"
if is_windows():
    RUNNER += ".exe"
CONVERTER = "squishxml3html.py"


def parse_options():
    parser = optparse.OptionParser(usage="""\
usage: %%prog [-i|--ini]

This program runs Squish tests: the squishserver must already be running.

The program needs to know where Squish's executables are, where the
results should go, which host(s) to run the tests on, and which test
suites to run.
All this is specified in %s, or alternatively in the file
specified using the -i (or --ini) option.

Here is an example %s file
(~ is replaced with your HOME directory on Windows or Unix):

    SQUISHDIR = ~/squish/bin
    RESULTSDIR = ~/results
    HOSTS = 127.0.0.1
    SUITES = ~/squish/examples/qt/suite_addressbook_py \\
             ~/squish/examples/qt/suite_canvas \\
             ~/squish/examples/qt/suite_canvas_js
    PRESERVE = 0
    ISO = 1

Note that both HOSTS and SUITES can accept multiple items.
Items should be separated by spaces or by escaped newlines.
HOSTS entries can include a port number, e.g.
    HOSTS = 127.0.0.1:4322 192.4.0.1:5860
HOSTS is optional and defaults to 127.0.0.1 (localhost) and Squish's
default port (4322).
(If a path contains spaces it must be enclosed in double quotes.)
RESULTSDIR is optional and defaults to . (the current directory).
PRESERVE is optional and defaults to 0 (don't preserve message
formatting).
ISO is optional and defaults to 0 (use locale-specific date/times; if
set to 1, ISO 8601 date/times will be used).""" % (INI_FILE, INI_FILE))
    parser.add_option("-i", "--ini", dest="ini",
            help="configuration file [default: %s]" % INI_FILE)
    parser.set_defaults(ini=INI_FILE)
    opts, args = parser.parse_args()
    global CONVERTER
    if not os.path.exists(CONVERTER):
        CONVERTER = os.path.join(os.path.dirname(os.path.realpath(__file__)), CONVERTER)
        if not os.path.exists(CONVERTER):
            parser.error("file does not exist '%s'" % (CONVERTER))
    if not os.path.exists(opts.ini):
        usage("this program requires a %s file" % opts.ini)
    return opts, args


def main():
    opts, args = parse_options()
    ini = open(opts.ini).read()
    config = get_config(ini)
    validate_config(config)
    global RUNNER
    if not verify_squishserver_availability(config, RUNNER):
        return
    xml_files = run_tests(config)
    convert_to_html(config, xml_files)


def verify_squishserver_availability(config, runner):
    hosts = [None]
    if "HOSTS" in config:
        hosts = config["HOSTS"]

    for host in config["HOSTS"]:
        print "Testing access to host: %s" % host
        port = None

        cmd = ['%s' % os.path.join(config["SQUISHDIR"], runner)]
        if host is not None:
            if ":" not in host:
                cmd += ["--host", "%s" % host]
            else:
                host_split, port = host.split(":", 1)
                cmd += ["--host", "%s" % host_split]
                cmd += ["--port", "%s" % port]

        cmd += ["--info", "all"]

        proc = subprocess.Popen(
            args=cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
        proc.communicate()
        ret = proc.returncode

        if ret != 0:
            print "ERROR: Error while accessing squishserver at %s" % host
            print "       squishrunner exit code: %s" % ret
            print "       Tested with command: %s" % cmd
            return False
    return True


def get_config(ini):
    def fixpath(path):
        return os.path.normpath(os.path.expanduser(path))

    entries = ini.replace("\\\n", " ").splitlines()
    config = dict(RESULTSDIR=".", PRESERVE="0", ISO="0")
    for entry in entries:
        i = entry.find("=")
        key, value = entry[:i - 1].strip(), entry[i + 1:].strip()
        if key in ("SQUISHDIR", "RESULTSDIR"):
            value = fixpath(value.strip("'\"").strip())
        elif key == "HOSTS":
            value = [host.strip() for host in value.split()]
        elif key == "SUITES":
            suites = []
            suite = ""
            quote = None
            for c in value:
                if c in "'\"":
                    if quote is not None:
                        if suite:
                            suites.append(fixpath(suite))
                            suite = ""
                        quote = None
                    else:
                        quote = c
                elif c in " \t":
                    if quote is not None:
                        suite += c
                    elif suite:
                        suites.append(fixpath(suite))
                        suite = ""
                elif c:
                    suite += c
            if suite:
                suites.append(fixpath(suite))
            value = suites
        config[key] = value
    return config


def validate_config(config):
    if "SQUISHDIR" not in config or not config["SQUISHDIR"]:
        usage("SQUISHDIR is missing from %s" % INI_FILE)
    if not os.path.exists(os.path.join(config["SQUISHDIR"], RUNNER)):
        usage("%s is not in %s" % (RUNNER, config["SQUISHDIR"]))
    if "RESULTSDIR" not in config or not config["RESULTSDIR"]:
        usage("RESULTSDIR is missing from %s" % INI_FILE)
    if not os.path.exists(config["RESULTSDIR"]):
        os.makedirs(config["RESULTSDIR"])
    if "HOSTS" not in config or not config["HOSTS"]:
        config["HOSTS"] = ["127.0.0.1"]
    if "SUITES" not in config or not config["SUITES"]:
        usage("SUITES is missing from %s" % INI_FILE)
    for suite in config["SUITES"]:
        if not os.path.exists(suite):
            usage("non-existent suite %s" % suite)
    if "PRESERVE" in config:
        try:
            config["PRESERVE"] = bool(int(config["PRESERVE"].strip()))
        except ValueError:
            config["PRESERVE"] = False
    else:
        config["PRESERVE"] = False
    if "ISO" in config:
        try:
            config["ISO"] = bool(int(config["ISO"].strip()))
        except ValueError:
            config["ISO"] = False
    else:
        config["ISO"] = False


def valid_filename(name):
    return re.sub(r'[:*?"<>|%]+', "_", name)


def run_tests(config):
    xml_files = []
    for suite in config["SUITES"]:
        for host in config["HOSTS"]:
            print "running", os.path.basename(suite), "on", host
            host_str = host
            if is_windows():
                host_str = host.replace(":", "_")
            xml = (os.path.join(config["RESULTSDIR"],
                                os.path.basename(suite)) +
                   "-" + host_str + "-" +
                   valid_filename(
                        datetime.datetime.utcnow().isoformat("T")[:19]))
            xml_files.append(os.path.join(xml,"results.xml"))
            command = []
            command.append(os.path.join(config["SQUISHDIR"], RUNNER))
            parts = host.split(":")
            host = parts[0]
            if len(parts) == 1:
                port = None
            else:
                port = parts[1]
            command.append("--host")
            command.append(host)
            if port is not None:
                command.append("--port")
                command.append(port)
            command.append("--testsuite")
            command.append(suite)
            command.append("--reportgen")
            command.append("xml3,%s" % xml)
            print " ".join(command)
            subprocess.call(command)
    return xml_files


def convert_to_html(config, xml_files):
    command = []
    command.append(sys.executable)
    command.append(CONVERTER)
    command.append("-v")
    if config["PRESERVE"]:
        command.append("-p")
    if config["ISO"]:
        command.append("-i")
    command.append("-d")
    command.append(config["RESULTSDIR"])
    command += xml_files
    print " ".join(command)
    subprocess.call(command)


def usage(message=None, error=True):
    print "usage: %s" % os.path.basename(sys.argv[0])
    if message is not None:
        if error:
            print "error:",
        print message
    sys.exit()


main()
