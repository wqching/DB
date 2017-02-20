#! /usr/bin/env python
# DEPRECATED: THIS SCRIPT IS NOT RECOMMENDED USE squishxml2html.py INSTEAD
# Copyright (c) 2008-12 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,

import xml.dom.minidom
import datetime
import sys
import os
import os.path
import shutil
from optparse import OptionParser

if sys.version_info >= (3,0):
    print('Error: This script requires a Python version < Python 3.0')
    sys.exit(1)

# The following HTML snippets can be modified to customize the look of the
# resulting page. The script substitutes the "%(title)s" parts with the data
# from the XML testresults.
htmlHeader = """\
<html>
    <head>
        <title>%(title)s</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    </head>
    <body>
"""

htmlFooter = """\
    </body>
</html>
"""

htmlSummary = """\
<h1>Summary</h1>
<table border="0" cellpadding="3">
    <tr>
        <td>Test cases</td><td>%(testcases)s</td>
    </tr>
    <tr>
        <td>Tests</td><td>%(tests)s</td>
    </tr>
    <tr>
        <td>Passes</td><td>%(total_passes)s (including %(expected_fails)s
                           expected failures)</td>
    </tr>
    <tr>
        <td>Fails</td><td>%(total_fails)s (including %(unexpected_passes)s
                          unexpected passes)</td>
    </tr>
    <tr>
        <td>Errors</td><td>%(errors)s</td>
    </tr>
    <tr>
        <td>Fatals</td><td>%(fatals)s</td>
    </tr>
</table>
<h1>Results</h1>
"""

htmlResultsBegin = """\
<p><b>%(filename)s</b></p>
<table border="0" cellpadding="3" width="100%%">
"""

htmlResultsEnd = """\
</table>
"""

htmlResults = {}
htmlResults['PASS'] = """\
<tr bgcolor="#80FF80">
    <td>%(result)s</td>
    <td>%(time)s</td>
    <td>%(line)s</td>
    <td>%(message)s</td>
    <td>%(detail)s</td>
</tr>
"""
htmlResults['XFAIL'] = htmlResults['PASS']
htmlResults['FAIL'] = """\
<tr bgcolor="#FF8080">
    <td>%(result)s</td>
    <td>%(time)s</td>
    <td>%(line)s</td>
    <td>%(message)s</td>
    <td>%(detail)s</td>
</tr>
"""
htmlResults['XPASS'] = htmlResults['FAIL']
htmlResults['ERROR'] = htmlResults['FAIL']
htmlResults['FATAL'] = htmlResults['FAIL']
htmlResults['default'] = """\
<tr bgcolor="#EEEEEE">
    <td>%(result)s</td>
    <td>%(time)s</td>
    <td>%(line)s</td>
    <td>%(message)s</td>
    <td>%(detail)s</td>
</tr>
"""

class ResultParser:
    """This class parses one XML test result file and stores it in Python
    structures. The attribute summary is a Python dictionary with the summary
    of the test result file. The attribute details is a list of dictionaries
    for the detailed test results."""
    def __init__(self, filename):
        self.filename = filename
        self.summary = {'testcases':         0,
                        'tests':             0,
                        'passes':            0,
                        'fails':             0,
                        'errors':            0,
                        'fatals':            0,
                        'unexpected_passes': 0,
                        'expected_fails':    0,
                        'total_passes':      0,
                        'total_fails':       0,
                        }
        self.details = []
        self.currenttest = {'name': '',
                            'time': ''}
        self.currenttests = []
        self.currentvp = {'name': '',
                          'file': '',
                          'line': ''}

        # parse the document
        doc = xml.dom.minidom.parse(filename)
        self.__walkNodes(doc)

        # correction when in testcase mode
        if self.summary['testcases'] == 0:
            self.summary['testcases'] = 1
        doc.unlink()

    def __walkNodes(self, node):
        """This private function walks each node in the document and processes
        the node. The walk is depth first recursive."""
        str = None
        if node.nodeName == 'test':
            self.currenttest['name'] = node.getAttribute('name');
        elif node.nodeName == 'prolog':
            for attr in node.attributes.keys():
                if attr == 'time':
                    self.currenttest[attr] = node.getAttribute(attr)
            result = {'result':  'START',
                      'time':    self.currenttest['time'],
                      'line':    '',
                      'message': 'Start \'' + self.currenttest['name'] + '\'',
                      'detail': 'Test \'' + self.currenttest['name'] + '\' started',
                      }
            self.details.append(result)
            temp = { 'name': self.currenttest['name'], 'time': self.currenttest['time'] }
            self.currenttests.append( temp );
        elif node.nodeName == 'epilog':
            temp = self.currenttests.pop();
            for attr in node.attributes.keys():
                if attr == 'time':
                    temp[attr] = node.getAttribute(attr)
            result = {'result':  'END',
                      'time':    temp['time'],
                      'line':    '',
                      'message': 'End \'' + temp['name'] + '\'',
                      'detail': 'End of test \'' + temp['name'] + '\'',
                      }
            self.details.append(result)
            if len( self.currenttests ) > 0:
                self.summary['testcases'] = self.summary['testcases'] + 1
        elif node.nodeName == 'verification':
            for attr in node.attributes.keys():
                self.currentvp[attr] = node.getAttribute(attr)
        elif node.nodeName == 'result':
            result = {'result':  '',
                      'time':    '',
                      'line':    self.currentvp['file'] + ':' + self.currentvp['line'],
                      'message': '',
                      'detail':  "",
                      }
            if node.firstChild:
                result['detail'] += "\n" + node.firstChild.nodeValue. \
                                   replace('\\n', '\n'). \
                                   replace('\\t', '\t')
            for attr in node.attributes.keys():
                if attr == 'time':
                    result[attr] = node.getAttribute(attr)
                if attr == 'type':
                    str = node.getAttribute(attr)
                    if str == 'PASS':
                        self.summary['passes'] = self.summary['passes'] + 1
                        self.summary['total_passes'] = self.summary['total_passes'] + 1
                    elif str == 'FAIL':
                        self.summary['fails'] = self.summary['fails'] + 1
                        self.summary['total_fails'] = self.summary['total_fails'] + 1
                    elif str == 'XPASS':
                        self.summary['unexpected_passes'] = self.summary['unexpected_passes'] + 1
                        self.summary['total_fails'] = self.summary['total_fails'] + 1
                    elif str == 'XFAIL':
                        self.summary['expected_fails'] = self.summary['expected_fails'] + 1
                        self.summary['total_passes'] = self.summary['total_passes'] + 1
                    result['result'] = str
                    self.summary['tests'] = self.summary['tests'] + 1
            self.details.append(result)
        elif node.nodeName == 'message':
            result = {'result':  '',
                      'time':    '',
                      'line':    '',
                      'message': '',
                      'detail':  "",
                      }
            if node.firstChild:
                result['detail'] += "\n" + node.firstChild.nodeValue. \
                                   replace('\\n', '\n'). \
                                   replace('\\t', '\t')
            for attr in node.attributes.keys():
                if attr == 'time':
                    result[attr] = node.getAttribute(attr)
                if attr == 'type':
                    str = node.getAttribute(attr)
                    if str == 'FATAL':
                        self.summary['fatals'] = self.summary['fatals'] + 1
                        self.summary['tests'] = self.summary['tests'] + 1
                    elif str == 'ERROR':
                        self.summary['errors'] = self.summary['errors'] + 1
                        self.summary['tests'] = self.summary['tests'] + 1
                    result['result'] = str
            self.details.append(result)
        elif node.nodeName == 'description':
            result = self.details[len(self.details) - 1];
            if node.hasAttribute('type'):
                if node.firstChild:
                    result['detail'] += "\n" + node.firstChild.nodeValue. \
                                       replace('\\n', '\n'). \
                                       replace('\\t', '\t')
            else:
                if node.firstChild:
                    result['message'] = node.firstChild.nodeValue. \
                                        replace('\\n', '\n'). \
                                        replace('\\t', '\t')
                else:
                    result['message'] = ''

        # walk child nodes
        child = node.firstChild
        while child:
            self.__walkNodes(child)
            child = child.nextSibling

class HtmlConverter:
    """This class converts a list of test results (as ResultParser objects) to
    HTML. The attribute html contains the HTML version of the converted
    results."""
    def __init__(self, title, results, screenshotsAsLinks=False):
        self.screenshotsAsLinks = screenshotsAsLinks
        self.screenshots = []

        summary = {'testcases':         0,
                   'tests':             0,
                   'passes':            0,
                   'fails':             0,
                   'errors':            0,
                   'fatals':            0,
                   'unexpected_passes': 0,
                   'expected_fails':    0,
                   'total_passes':      0,
                   'total_fails':       0,
                   }
        detailsHtml = ''
        for r in results:
            # aggregate the keys of the summary
            for attr in summary.keys():
                summary[attr] += r.summary.get(attr, 0)
            # convert to HTML
            detailsHtml += self.createHtmlForOneResult(r)
        # put the parts together to one HTML document
        self.html  = htmlHeader % {'title': title} + \
                     htmlSummary % summary + \
                     detailsHtml + \
                     htmlFooter

    def createHtmlForOneResult(self, r):
        html = htmlResultsBegin % {'filename': r.filename}
        for d in r.details:
            d['detail'] = self.htmlEscape(d['detail'].strip())
            if self.screenshotsAsLinks:
                d['message'] = self.convertScreenshotToLink(d['message'])
            html += htmlResults.get(d['result'], htmlResults['default']) % d
        html += htmlResultsEnd
        return html

    def htmlEscape(self, detail):
        # escape &, <, > and convert newlines and tab to HTML
        return detail.replace('&', '&amp;'). \
                      replace('<', '&lt;'). \
                      replace('>', '&gt;'). \
                      replace('\n', '<br>'). \
                      replace('\t', '&nbsp;'*4)

    def convertScreenshotToLink(self, message):
        # check if there is a reference to a screenshot for failures
        messageStart, found, rest = message.partition('(Screenshot in "')
        if not found:
            return message
        screenshot, found, messageEnd = rest.partition('")')
        if not found:
            return message
        self.screenshots.append(screenshot)
        return '%s(<a href="%s">Screenshot</a>)%s' % \
               (messageStart, os.path.basename(screenshot), messageEnd)

if __name__ == '__main__':
    """The following code is executed if this script was called from the
    commandline."""
    parser = OptionParser(usage='usage: %prog [options] resultfile1 ...')
    parser.add_option('--outdir',
                      help='write files to the directory OUTDIR',
                      metavar='OUTDIR')
    (options, args) = parser.parse_args()

    # open input file
    if not args:
        parser.error('Missing a file name argument')

    # parse the XML files
    title = ''
    results = []
    for filename in args:
        title += filename + ' '
        results.append(ResultParser(filename))

    # convert the result to HTML
    if options.outdir:
        converter = HtmlConverter(title, results, screenshotsAsLinks=True)
        if not os.path.exists(options.outdir):
            os.makedirs(options.outdir)
        for screenshot in converter.screenshots:
            shutil.copy(screenshot, options.outdir)
        file = open(os.path.join(options.outdir, 'index.html'), 'w')
        file.write(converter.html.encode('utf-8'))
        file.close
    else:
        converter = HtmlConverter(title, results)
        print(converter.html.encode('utf-8'))
