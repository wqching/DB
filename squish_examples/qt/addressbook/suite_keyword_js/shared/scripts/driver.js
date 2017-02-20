source(findFile("scripts", "actions.js"));

function drive(datafile)
{
    test.log("Drive: '" + datafile + "'");
    var records = testData.dataset(datafile);
    for (var row = 0; row < records.length; ++row) {
        var command = testData.field(records[row], "Keyword") + "(";
        var comma = "";
        for (var i = 1; i <= 4; ++i) {
            var arg = testData.field(records[row], "Argument " + i);
            if (arg != "") {
                command += comma + "'" + arg + "'";
                comma = ", ";
            }
            else {
                break;
            }
        }
        command += ")";
        test.log("Execute: " + command);
        eval(command);
    }
}    
