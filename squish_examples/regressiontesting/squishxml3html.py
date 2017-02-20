#!/usr/bin/env python
# -*- encoding=utf8 -*-
# Copyright (c) 2009-14 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,
# distributed, and modified, without limitation.

from __future__ import nested_scopes
from __future__ import generators
from __future__ import division

import codecs
import datetime
import optparse
import os
import random
import re
import shutil
import string
import subprocess
import sys
import tempfile
import time
import traceback
import xml.sax
import xml.sax.saxutils

if sys.platform.startswith("win"):
    import glob


def print_str(s, file_handle=sys.stdout):
    """
    Output s after encoding it with stdout encoding to
    avoid conversion errors with non ASCII characters)
    """
    if sys.__stdout__.encoding:
        print >> file_handle, s.encode(sys.__stdout__.encoding, 'replace')
    else:
        print >> file_handle, s.encode("utf-8")


if sys.version_info[0] != 2 or (
                sys.version_info[0] == 2 and sys.version_info[1] < 4):
    print_str("""%s: error: this program requires \
Python 2.4, 2.5, 2.6, or 2.7;
it cannot run with python %d.%d.
Try running it with the Python interpreter that ships with squish, e.g.:
C:\> C:\\squish\\squish-4.0.1-windows\\python\python.exe %s
""" % (os.path.basename(sys.argv[0]),
       sys.version_info[0], sys.version_info[1],
       os.path.basename(sys.argv[0])))
    sys.exit(1)

NEUTRAL_COLOR = u"#DCDCDC"  # gainsboro
PASS_COLOR = u"#f0fff0"  # honeydew
FAIL_COLOR = u"#FFB6C1"  # lightpink
ERROR_COLOR = u"#FA8072"  # salmon
LOG_COLOR = u"#DAA520"  # goldenrod
WARNING_COLOR = u"#FFA500"  # orange
FATAL_COLOR = u"#F08080"  # lightcoral
CASE_COLOR = u"#90ee90"  # lightgreen

INDEX_HTML_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Squish Report Results Summary</title></head>
<body><h3>Squish Report Results Summary</h3>
<p><b>Report generated %s</b></p>
<table border="0">
"""

SUBPAGE_HTML_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Screenshot Differences</title>
<script type="text/javascript">
function rot() {
  var imgs = document.getElementsByClassName("image");
  var currentRotState = parseInt(document.getElementById("currentRotState").value);
  currentRotState = (currentRotState + 1) % 4;
  document.getElementById("currentRotState").value = currentRotState;
  var newRot = currentRotState * 90;
  var sumWidth = 0;
  for (var i = 0; i < imgs.length; ++i) {
    imgs[i].style["-webkit-transform"] = "rotate(" + newRot + "deg)";
    imgs[i].style.MozTransform = "rotate(" + newRot + "deg)";
    var h = imgs[i].offsetHeight;
    var w = imgs[i].offsetWidth;
    if (currentRotState % 2 == 1) {
      var topIntOld = parseInt(imgs[i].style["top"]);
      var topIntNew = topIntOld + Math.round((w-h)/2);
      var topStrNew = "" + topIntNew + "px";
      imgs[i].style["top"] = topStrNew;
      var leftIntOld = parseInt(imgs[i].style["left"]);
      var leftIntNew = leftIntOld + Math.round((h-w)/2) - sumWidth;
      var leftStrNew = "" + leftIntNew + "px";
      imgs[i].style["left"] = leftStrNew;
    } else {
      var topIntOld = parseInt(imgs[i].style["top"]);
      var topIntNew = topIntOld - Math.round((w-h)/2);
      var topStrNew = "" + topIntNew + "px";
      imgs[i].style["top"] = topStrNew;
      var leftIntOld = parseInt(imgs[i].style["left"]);
      var leftIntNew = leftIntOld - Math.round((h-w)/2) + sumWidth;
      var leftStrNew = "" + leftIntNew + "px";
      imgs[i].style["left"] = leftStrNew;
    }
    sumWidth += (w-h);
  }
}
</script>
<body bgcolor="#dcdcdc" style="white-space: nowrap">
<button onclick="rot()">Rotate</button><input type="hidden" id="currentRotState" value="0" />
Differences/Expected Image/Actual Image<br />
"""

INDEX_HTML_END = u"</table></body></html>\n"

SUBPAGE_HTML_END = u"</body></html>\n"

INDEX_ITEM = u"""<tr valign="%(valign)s" bgcolor="%(color)s">\
<td>%(when)s</td><td align="right">%(passes)d/%(tests)d</td><td>\
<a href="%(url)s">%(name)s</a></td></tr>\n"""

SUMMARY_MARK = "SzUzMzMzAzRzY" * 2
SUMMARY_SIZE = 2000

REPORT_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>%%(title)s</title></head>
<body><h2>%%(title)s</h2>
<h3>Summary</h3><table border="0">\n%s</table>
<h3>Results</h3><table border="0">\n""" % (
    SUMMARY_MARK + " " * SUMMARY_SIZE)

REPORT_END = u"</table></body></html>\n"

SUMMARY_ITEM = u"""<tr valign="%(valign)s" bgcolor="%(color)s">\
<td>%(name)s</td><td align="right">%(value)s</td><td>%(extra)s</td>\
</tr>\n"""

CASE_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s"><td>\
<b>%%(name)s</b></td><td colspan="4">%%(start)s</td></tr>\n""" % (
    CASE_COLOR)

BDD_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s"><td>%%(type)s</td><td>\
<b>%%(name)s</b></td><td colspan="3">%%(start)s</td></tr>\n""" % (
    CASE_COLOR)

VERIFICATION_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s">\
<td>%%(name)s</td><td colspan="4">%%(filename_and_line)s</td>\
</tr>\n""" % NEUTRAL_COLOR

SAXPARSEEXCEPTION_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s">\
<td></td><td colspan="2" bgcolor="%s">SAXParseException: %%(name)s</td>\
<td colspan="2" bgcolor="%s">%%(error_message)s</td>\
</tr>\n""" % (NEUTRAL_COLOR, FATAL_COLOR, FATAL_COLOR)

RESULT_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s"><td></td>\
<td bgcolor="%%(color)s">%%(type)s</td><td bgcolor="%%(color)s">\
%%(when)s</td><td bgcolor="%%(color)s">%%(description)s</td>\
<td bgcolor="%%(color)s">%%(detailed_description)s</td></tr>\n""" % (
    NEUTRAL_COLOR)

SUBPAGE_IMG_TPL = '<img class="image" src="%s" style="margin-left: 10px; position: relative; top: 0px; left: 0px;" alt="%s" />'

escape = None
datetime_from_string = None


class ReportVersionError(Exception): pass


class ReportError(Exception): pass


class SquishReportHandler(xml.sax.handler.ContentHandler, xml.sax.handler.ErrorHandler):
    def __init__(self, opts, fh, squishDir=None, tempDir=None):
        xml.sax.handler.ContentHandler.__init__(self)
        if opts.preserve:
            self.valign = "middle"
        else:
            self.valign = "top"
        self.preserve = opts.preserve
        self.fh = fh
        self.testContextStack = []

        # IN logic handlers
        self.in_report = False
        self.in_prolog = False
        self.in_name = False
        self.in_location = False
        self.in_verification = False
        self.in_uri = False
        self.in_lineNo = False
        self.in_text = False
        self.in_detail = False
        self.in_expectedValue = False
        self.in_actualValue = False
        self.in_objectName = False
        self.in_deletion = False
        self.in_insertion = False
        self.in_objectLocation = False

        self.suite_start = None
        self.case_start = None
        self.start = None
        self.suite_passes = 0
        self.suite_fails = 0
        self.suite_fatals = 0
        self.suite_errors = 0
        self.suite_expected_fails = 0
        self.suite_unexpected_passes = 0
        self.parse_error = False
        self.suite_tests = 0
        self.suite_cases = 0
        self.suite_url = None
        self.suite_name = None
        # For BDD elements handling
        self.name = None
        self.squishDir = squishDir
        self.tempDir = tempDir
        self.targetDir = opts.dir
        self.text = None
        self.detail = None
        self.expectedValue = None
        self.actualValue = None
        self.objectName = None
        self.deletion = []
        self.insertion = []
        self.vpName = None
        self.resetCaseMembers()
        self.suiteDir = None

    def resetCaseMembers(self):
        self.in_result = False
        self.in_message = False
        self.case_name = None
        self.result_type = None
        self.result_time = None
        self.message_type = None
        self.message_time = None
        self.message_file = None
        self.message_line = None
        self.message = []
        self.currentAbsVpFile = None

    def writeParseError(self, name, exception):
        err = str(exception)
        self.fh.write(SAXPARSEEXCEPTION_ITEM % dict(valign=self.valign,
                                                    name=escape(name),
                                                    error_message=escape(err)))
        print_str(err)

    def warning(self, exception):
        self.writeParseError("Warning", exception)

    def error(self, exception):
        self.parse_error = True
        self.writeParseError("Error", exception)

    def fatalError(self, exception):
        self.parse_error = True
        self.writeParseError("Fatal error", exception)

    def startElement(self, name, attributes):
        if name == u"SquishReport":
            version = attributes.get(u"version")
            if not version:
                raise ReportVersionError("Missing Squish Report version; "
                        "please use squishrunner's xml3 report-generator.")
            version = version.split(".")
            if int(version[0]) < 3:
                raise ReportVersionError("Unsupported Squish Report version \"%s\"; "
                        "please use squishrunner's xml3 report-generator." % ".".join(version))
            self.in_report = True
            return
        elif not self.in_report:
            raise ReportError("unrecognized XML file")
        if name == u"test":
            testcontext = attributes.get(u"type")
            self.testContextStack.append(testcontext)
            if testcontext == u"testcase":
                self.suite_cases += 1
        elif name == u"prolog":
            self.in_prolog = True
            testcontext = self.testContextStack[-1]
            if testcontext == u"testcase":
                self.case_start = datetime_from_string(attributes.get("time"))
            elif testcontext == u"testsuite":
                self.suite_start = datetime_from_string(attributes.get("time"))
            else:
                self.start = datetime_from_string(attributes.get("time"))
        elif name == u"name":
            self.in_name = True
        elif name == u"epilog":
            # We ignore epilog times
            pass
        elif name == u"verification":
            self.in_verification = True
        elif name == u"scriptedVerificationResult" \
                or name == u"propertyVerificationResult"\
                or name == u"screenshotVerificationResult"\
                or name == u"tableVerificationResult"\
                or name == u"visualVerificationResult":
            self.result_type = attributes.get("type")
            self.result_time = datetime_from_string(attributes.get("time"))
            self.suite_tests += 1
            if self.result_type == u"PASS":
                self.suite_passes += 1
            elif self.result_type == u"FAIL":
                self.suite_fails += 1
            elif self.result_type == u"FATAL":
                self.suite_fatals += 1
            elif self.result_type == u"ERROR":
                self.suite_errors += 1
            elif self.result_type in (u"XPASS", u"UPASS"):
                self.suite_unexpected_passes += 1
            elif self.result_type == u"XFAIL":
                self.suite_expected_fails += 1
            self.in_result = True
        elif name == u"message":
            self.message_type = attributes.get("type")
            if self.message_type == u"FATAL":
                self.suite_fatals += 1
            elif self.message_type == u"ERROR":
                self.suite_errors += 1
            self.message_time = datetime_from_string(attributes.get("time"))
            self.in_message = True
        elif name == u"location":
            self.in_location = True
        elif name == u"uri":
            self.in_uri = True
        elif name == u"lineNo":
            self.in_lineNo = True
        elif name == u"text":
            self.in_text = True
        elif name == u"detail":
            self.in_detail = True
        elif name == u"expectedValue":
            self.in_expectedValue = True
        elif name == u"actualValue":
            self.in_actualValue = True
        elif name == u"objectName":
            self.in_objectName = True
        elif name == u"insertion":
            self.in_insertion = True
        elif name == u"deletion":
            self.in_deletion = True
        elif name == u"objectLocation":
            self.in_objectLocation = True

    def characters(self, text):
        if self.in_message and not (self.in_location):
            self.message.append(text)
        elif self.in_message and self.in_lineNo:
            self.message_line = escape(text)
        elif self.in_uri and self.testContextStack[-1] == "testsuite":
            self.suiteDir = escape(text)
        elif self.in_message and self.in_uri:
            self.message_file = escape(text)
        elif self.in_verification and self.in_lineNo:
            self.ver_line = escape(text)
        elif self.in_verification and self.in_uri and self.in_location:
            self.ver_file = escape(text)
        elif self.in_verification and self.in_uri and self.in_objectLocation:
            self.vpName = escape(text)
        elif self.in_text:
            self.text = str(self.text or '') + escape(text)
        elif self.in_detail:
            self.detail = str(self.detail or '') + escape(text)
        elif self.in_expectedValue:
            self.expectedValue = escape(text)
        elif self.in_actualValue:
            self.actualValue = escape(text)
        elif self.in_objectName:
            self.objectName = escape(text)
        elif self.in_insertion:
            stripedText = str(text.lstrip())
            if stripedText != "":
                self.insertion.append(stripedText)
        elif self.in_deletion:
            stripedText = str(text.lstrip())
            if stripedText != "":
                self.deletion.append(stripedText)
        elif self.in_name:
            testcontext = self.testContextStack[-1]
            if testcontext == "testsuite":
                self.suite_name = escape(text)
                self.fh.write(REPORT_START % dict(title=self.suite_name))
            elif testcontext == "testcase":
                self.case_name = escape(text)
                self.fh.write(CASE_ITEM % dict(name=escape(self.case_name),
                                               valign=self.valign, start=self.case_start))
            else:
                self.name = escape(text)
                self.fh.write(BDD_ITEM % dict(type=testcontext.title(), name=escape(self.name),
                                               valign=self.valign, start=self.start))
                
    def endElement(self, name):
        if name == u"SquishReport":
            self.fh.write(REPORT_END)
        elif name == u"test":
            self.testContextStack.pop()
        elif name == u"prolog":
            self.in_prolog = False
        elif name == u"name":
            self.in_name = False
        elif name == u"epilog":
            # We ignore epilog times
            pass
        elif name == u"verification":
            self.in_verification = False
            self.currentAbsVpFile = None
            self.ver_file = None
        elif name == u"scriptedVerificationResult" \
                or name == u"propertyVerificationResult"\
                or name == u"screenshotVerificationResult"\
                or name == u"tableVerificationResult"\
                or name == u"visualVerificationResult":
            color = FAIL_COLOR
            if self.result_type in (u"PASS", u"XFAIL"):
                color = PASS_COLOR
            elif self.result_type == u"ERROR":
                color = ERROR_COLOR
            elif self.result_type == u"LOG":
                color = LOG_COLOR
            if self.detail is None:
                self.detail = ""
            if name == u"scriptedVerificationResult":
                desc = self.text
                detailed_desc = self.detail
            elif name == u"propertyVerificationResult":
                if self.expectedValue is None:
                   self.expectedValue = ""
                if self.actualValue is None:
                   self.actualValue = ""
                desc = self.text + " Expecting value: '" + self.expectedValue + "'"
                detailed_desc = self.detail
            elif name == u"screenshotVerificationResult":
                desc = self.text
                test_file = self.ver_file.replace("file://", "")
                self.currentAbsVpFile = findVpFile(test_file, self.vpName, self.suiteDir)
                detailed_desc = escape_and_handle_image(self.detail, self.preserve, self.currentAbsVpFile, "".join(self.objectName), self.squishDir, self.targetDir, self.tempDir)
            elif name == u"tableVerificationResult":
                desc = self.text
                detailed_desc = self.detail
                if color == FAIL_COLOR:
                    detailed_desc += " Insertion: " + str(self.insertion)
                    detailed_desc += " Deletion: " + str(self.deletion)
            elif name == u"visualVerificationResult":
                desc = self.text
                detailed_desc = self.detail

            self.fh.write(RESULT_ITEM % dict(color=color,
                                             type=self.result_type,
                                             when=self.result_time,
                                             description=desc,
                                             detailed_description=detailed_desc,
                                             valign=self.valign))
            # Reset values
            self.result_type = None
            self.result_time = None
            self.text = None
            self.detail = None
            self.expectedValue = None
            self.actualValue = None
            self.in_result = False
            self.objectName = None
            self.insertion = []
            self.deletion = []
        elif name == u"message":
            color = LOG_COLOR
            if self.message_type == u"WARNING":
                color = WARNING_COLOR
            if self.message_type == u"ERROR":
                color = ERROR_COLOR
            elif self.message_type == u"FATAL":
                color = FATAL_COLOR
            msg = self.message
            detail_msg = ""
            if (len("".join(self.message).strip()) == 0 and
                        len(self.description) > 0):
                msg = self.description
                detail_msg = self.detailed_description
            msg = escape_and_handle_image("".join(msg), self.preserve, subFilesDir=self.targetDir)
            where = ""
            if self.message_file is not None:
                where = "At %s:%s:<br><br>" % (escape(self.message_file), self.message_line)
            detail_msg = where + escape_and_handle_image("".join(detail_msg),
                                                         self.preserve,
                                                         subFilesDir=self.targetDir)
            self.fh.write(RESULT_ITEM % dict(color=color,
                                             type=self.message_type,
                                             when=self.message_time,
                                             description=msg,
                                             detailed_description=detail_msg,
                                             valign=self.valign))
            self.message = []
            self.in_message = False
        elif name == u"location":
            self.in_location = False
            if self.in_verification:
                self.fh.write(VERIFICATION_ITEM % dict(valign=self.valign,
                                                       name=escape("TEST"),
                                                       filename_and_line=escape(
                                                           os.path.normpath(self.ver_file) + "#" + self.ver_line)))
        elif name == u"uri":
            self.in_uri = False
        elif name == u"lineNo":
            self.in_lineNo = False
        elif name == u"text":
            self.in_text = False
        elif name == u"detail":
            self.in_detail = False
        elif name == u"expectedValue":
            self.in_expectedValue = False
        elif name == u"actualValue":
            self.in_actualValue = False
        elif name == u"objectName":
            self.in_objectName = False
        elif name == u"insertion":
            self.in_insertion = False
        elif name == u"deletion":
            self.in_deletion = False
        elif name == u"objectLocation":
            self.in_objectLocation = False

def getExpectedImage(absVpFile, squishDir, tempDir):
    convertVp = os.path.join(os.path.join(squishDir, "bin"), "convertvp")
    # XXX assumes usage of --resultdir switch to squishrunner
    subprocess.call([convertVp, "--fromvp", absVpFile, tempDir])
    return os.path.join(tempDir, "img_1.png")  # XXX limitation of convertvp.


def getDiffedImage(absVpFile, widgetName, actualImage, squishDir, tempDir):
    vpdiff = os.path.join(os.path.join(squishDir, "bin"), "vpdiff")
    targetFile = os.path.join(tempDir, randomFilename()) + ".png"
    cmd = [vpdiff, absVpFile, widgetName, actualImage, targetFile, "--highlights"]
    subprocess.call(cmd)
    return os.path.join(targetFile)


def randomFilename():
    return ''.join([random.choice(string.letters + string.digits) for i in range(8)])


def packageImage(absPathToImage, targetDir):
    (root, ext) = os.path.splitext(absPathToImage)
    fileName = randomFilename() + ext
    targetFile = os.path.join(targetDir, fileName)
    try:
        shutil.copy(absPathToImage, targetFile)
    except IOError, e:
        print_str(str(e), sys.stderr)
    return fileName


def escape_and_handle_image(description, preserve, absVpFile=None, widgetName=None, squishDir=None, subFilesDir=None,
                            tempDir=None):
    match = re.search(ur"""saved\s+as\s+['"](?P<image>[^'"]+)['"]""",
                      description, re.IGNORECASE)
    if match:
        before = escape(description[:match.start()])
        actualImage = match.group("image")
        actImage = packageImage(actualImage, subFilesDir)

        after = escape(description[match.end():])
        if absVpFile is not None and squishDir is not None and subFilesDir is not None and tempDir is not None:
            expectedImage = getExpectedImage(absVpFile, squishDir, tempDir)
            diffedImage = getDiffedImage(absVpFile, widgetName, actualImage, squishDir, tempDir)
            expImage = packageImage(expectedImage, subFilesDir)
            dffImage = packageImage(diffedImage, subFilesDir)

            imgPageName = "%s.html" % (randomFilename(), )
            imgPageFile = open(os.path.join(subFilesDir, imgPageName), 'w')
            imgPageFile.write(SUBPAGE_HTML_START)
            imgPageFile.write(SUBPAGE_IMG_TPL % (dffImage, "Diff View"))
            imgPageFile.write(SUBPAGE_IMG_TPL % (expImage, "Expected Image"))
            imgPageFile.write(SUBPAGE_IMG_TPL % (actImage, "Actual Image"))
            imgPageFile.write(SUBPAGE_HTML_END)
            imgPageFile.close()

            description = '%s <a href="%s">View</a> %s' % (
                before, imgPageName, after)
        else:
            description = '%s <a href="./%s">%s</a> %s' % (
                before, actImage, actImage, after)

    else:
        # the logscreenshotOnFail/Error case
        match = re.search(
            ur"""screenshot\s+in\s+['"](?P<image>[^'"]+)['"]""",
            description, re.IGNORECASE)
        if match is not None:
            before = escape(description[:match.start()])
            actualImage = match.group("image")
            actImage = packageImage(actualImage, subFilesDir)
            after = escape(description[match.end():])
            description = '%s<a href="./%s">Screenshot</a>%s' % (
                before, actImage, after)
        else:
            description = escape(description)
    if preserve:
        description = "<pre>%s</pre>" % description

    return description


def findVpFile(scriptFile, vpName, suiteDir):
    if not vpName:
        return None
    guess = os.path.join(os.path.join(os.path.dirname(scriptFile), "verificationPoints"), vpName)
    if os.path.exists(guess):
        return guess
    guess = os.path.join(
        os.path.join(os.path.join(os.path.dirname(os.path.dirname(scriptFile)), "shared"), "verificationPoints"),
        vpName)
    if os.path.exists(guess):
        return guess
    guess = os.path.join(os.path.join(os.path.dirname(os.path.dirname(scriptFile)), "verificationPoints"), vpName)
    if os.path.exists(guess):
        return guess

    # New VP URIs format with specified protocol or absolute path.
    from urlparse import urlparse
    import urllib
    uri_parts = urlparse(vpName)
    finalPath = urllib.url2pathname(uri_parts.path)
    # If VP URI is absolute path use it as it is.
    if uri_parts.scheme == 'file' and os.path.exists(finalPath):
        return finalPath

    # If VP URI is a path relative to test suite directory.
    if uri_parts.scheme == 'x-testsuite':
        guess = suiteDir + uri_parts.path
        uri_parts = urlparse(guess)
        finalPath = urllib.url2pathname(uri_parts.path)
        if os.path.exists(finalPath):
            return finalPath

    print_str("VpFile not found: (scriptFile=%s, vpName=%s)" % (scriptFile, vpName), sys.stderr)
    return None


def process_suite(opts, filename, index_fh=None):
    tempDir = tempfile.mkdtemp()
    extension = os.path.splitext(filename)[1]
    xmlResultDir = os.path.split(filename)[0]
    baseName = os.path.basename(xmlResultDir)
    html_file = os.path.abspath(os.path.join(opts.dir,
                                             os.path.basename(filename.replace(extension, baseName+".html"))))
    if opts.preserve:
        valign = "middle"
    else:
        valign = "top"
    fh = None

    squishDir = opts.squishdir
    if squishDir is None:
        pass
    elif not os.path.exists(squishDir):
        print_str("Given Squish directory doesn't exists. Ignoring it.", sys.stderr)
        squishDir = None
    elif not os.path.exists(os.path.join(squishDir, "bin")):
        print_str(
            "Given Squish directory is not a valid Squish directory. It lacks the 'bin' subdirectory. Ignoring it.",
            sys.stderr)
        squishDir = None
    elif (not os.path.exists(os.path.join(os.path.join(squishDir, "bin"), "convertvp")) and
              not os.path.exists(os.path.join(os.path.join(squishDir, "bin"), "convertvp.exe"))):
        print_str(
            "Given Squish directory is not a valid Squish directory. It lacks 'bin/convertvp' utility. Ignoring it.",
            sys.stderr)
        squishDir = None

    try:
        try:
            fh = codecs.open(html_file, "w", encoding="utf-8")
            reporter = SquishReportHandler(opts, fh, squishDir, tempDir)
            parser = xml.sax.make_parser()
            parser.setContentHandler(reporter)
            parser.setErrorHandler(reporter)
            parser.parse(filename)
            write_summary_entry(valign, reporter, html_file)
            if index_fh is not None:
                write_index_entry(valign, index_fh, reporter,
                                  os.path.basename(html_file))
            if opts.verbose:
                print_str("wrote '%s'" % html_file)

        except ReportVersionError, e:
            # Special handling for version errors to avoid printing
            # the scary looking, hard to read backtrace:
            print_str(" ".join(e.args))

        except (EnvironmentError, ValueError, ReportError,
                xml.sax.SAXParseException), err:
            traceback.print_exc()

    finally:
        if fh is not None:
            fh.close()
    shutil.rmtree(tempDir)


def write_summary_entry(valign, reporter, html_file):
    summary = []
    color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Test Cases",
                                       value=reporter.suite_cases, extra="", valign=valign))
    summary.append(SUMMARY_ITEM % dict(color=color, name="Tests",
                                       value=reporter.suite_tests, extra="", valign=valign))
    extra = ""
    if reporter.suite_expected_fails != 0:
        extra = " plus %d expected fails" % reporter.suite_expected_fails
    summary.append(SUMMARY_ITEM % dict(color=color, name="Passes",
                                       value=reporter.suite_passes, extra=extra, valign=valign))
    extra = ""
    if reporter.suite_unexpected_passes != 0:
        extra = " plus %d unexpected passes" % (
            reporter.suite_unexpected_passes)
    color = FAIL_COLOR
    if reporter.suite_fails == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Fails",
                                       value=reporter.suite_fails, extra=extra, valign=valign))
    color = ERROR_COLOR
    if reporter.suite_errors == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Errors",
                                       value=reporter.suite_errors, extra="", valign=valign))
    color = FATAL_COLOR
    if reporter.suite_fatals == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Fatals",
                                       value=reporter.suite_fatals, extra="", valign=valign))
    summary = u"".join(summary)
    summary = summary.encode("utf8")
    if len(summary) > SUMMARY_SIZE + len(SUMMARY_MARK):
        print_str("internal error: summary too big to write---try doubling SUMMARY_SIZE", sys.stderr)
        return

    fh = None
    try:
        fh = open(html_file, "r+b")
        data = fh.read(8000 + SUMMARY_SIZE)
        i = data.find(SUMMARY_MARK)
        if i == -1:
            print_str("internal error: failed to write summary", sys.stderr)
        else:
            fh.seek(i)
            fh.write(summary)
    finally:
        if fh is not None:
            fh.close()


def write_index_entry(valign, index_fh, reporter, html_file):
    color = FAIL_COLOR
    if ((reporter.suite_tests ==
                 reporter.suite_passes + reporter.suite_expected_fails) and
            not reporter.suite_errors and not reporter.suite_fatals and
            not reporter.parse_error):
        color = PASS_COLOR
    index_fh.write(INDEX_ITEM % dict(color=color, valign=valign,
                                     when=reporter.suite_start, passes=reporter.suite_passes,
                                     tests=reporter.suite_tests, url=html_file,
                                     name=reporter.suite_name))


def parse_options():
    parser = optparse.OptionParser(usage="""\
usage: %prog [-h|--help] [-i|--iso] [-p|--preserve] [-v|--verbose] [-d|--dir <directory>] [-s|--squishdir <squish installation>] [results1.xml [results2.xml [...]]]

If only one file is specified and no directory is specified the file is
converted to HTML and output to the current working directory; verbose
is not supported in this case. If multiple files are specified they are
converted to HTML in files of the same name but with a suffix of
.html---they are put in the current working directory unless a directory
is specified using -d or --dir. If multiple files are specified an index.html file is also
output that has links to each results file.

All referenced images from the Test Results are placed into the target
directory as well.

If the --squishdir option is given, the expected images from failed screenshot
VPs are extracted and stored in the target directory and displayed in the
generated report next to the failed images.

If the --iso option is given the time information is produced in ISO format.

If the --preserve option is given the formatting of messages is preserved as it is in the xml files.""")
    parser.add_option("-d", "--dir", dest="dir",
                      help="output directory [default: .]")
    parser.add_option("-i", "--iso", dest="iso",
                      action="store_true",
                      help="use ISO date/time format [default: off]")
    parser.add_option("-p", "--preserve", dest="preserve",
                      action="store_true",
                      help="preserve message formatting [default: off]")
    parser.add_option("-s", "--squishdir", dest="squishdir",
                      help="path to Squish installation")
    parser.add_option("-v", "--verbose", dest="verbose",
                      action="store_true",
                      help="list each file as it is output [default: off]")
    parser.set_defaults(iso=False, preserve=False, verbose=False, squish=None)
    opts, args = parser.parse_args()
    if len(args) < 1:
        parser.error("no files have been specified")
    args = [x for x in args if x.lower().endswith(".log") or
            x.lower().endswith(".xml")]
    if not args:
        parser.error("no .log or .xml files have been specified")
    return opts, args


def create_functions(opts):
    global escape
    if not opts.preserve:
        def function(s, is_multiline=False):
            return (xml.sax.saxutils.escape(s).strip().
                    replace("\n", "<br/>"))
    else:
        def function(s, is_multiline=False):
            if is_multiline:
                return "<pre>%s</pre>" % (
                    xml.sax.saxutils.escape(s).strip())
            else:
                return xml.sax.saxutils.escape(s).strip()
    escape = function

    global datetime_from_string
    if not opts.iso:
        # Sadly, Python doesn't properly support time zones out of the box
        def function(s):
            if s is None:
                return ""
            return time.asctime(time.strptime(s[:19],
                                              "%Y-%m-%dT%H:%M:%S")).replace(" ", "&nbsp;")
    else:
        def function(s):
            if s is None:
                return ""
            return s
    datetime_from_string = function


def main():
    opts, args = parse_options()
    if sys.platform.startswith("win"):
        temp = []
        for arg in args:
            temp.extend(glob.glob(arg))
        args = temp
    create_functions(opts)
    if not opts.dir:
        opts.dir = "."
    if len(args) == 1 and not opts.dir:
        opts.verbose = False
        process_suite(opts, args[0])
    else:
        if not os.path.exists(opts.dir):
            os.makedirs(opts.dir)
        index_file = os.path.abspath(os.path.join(opts.dir, "index.html"))
        fh = None
        try:
            fh = codecs.open(index_file, "w", encoding="utf-8")
            if opts.iso:
                when = datetime.date.today().isoformat()
            else:
                when = datetime.date.today().strftime("%x")
            fh.write(INDEX_HTML_START % when)
            for filename in args:
                process_suite(opts, filename, fh)
            fh.write(INDEX_HTML_END)
            if opts.verbose:
                print_str("wrote '%s'" % index_file)
        except:
            traceback.print_exc()
        if fh is not None:
            fh.close()


main()
