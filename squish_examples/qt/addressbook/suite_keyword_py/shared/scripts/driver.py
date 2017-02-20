source(findFile("scripts", "actions.py"))

def drive(datafile):
    test.log("Drive: '%s'" % datafile)
    for row, record in enumerate(testData.dataset(datafile)):
        command = testData.field(record, "Keyword") + "("
        comma = ""
        for i in range(1, 5):
            arg = testData.field(record, "Argument %d" % i)
            if arg:
                command += "%s%r" % (comma, arg)
                comma = ", "
            else:
                break
        command += ")"
        test.log("Execute: %s" % command)
        eval(command)
        