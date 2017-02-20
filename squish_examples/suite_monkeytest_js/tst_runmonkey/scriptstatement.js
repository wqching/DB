/**
 * Constructs a ScriptStatement object for safely composing JavaScript
 * code.
 */
function ScriptStatement(name) {
    var args = [];
    this.addStringArg = function(value) {
        var escapedValue = "";

        var len = value.length;
        for (var i = 0; i < len; ++i) {
            switch (value[i]) {
                case "\\":
                    escapedValue += "\\\\";
                    break;
                case "\"":
                    escapedValue += "\\\"";
                    break;
                default:
                    escapedValue += value[i];
                    break;
            }
        }

        this.addArg("\"" + escapedValue + "\"");
    }

    this.addArg = function(value) {
        args.push(value);
    }

    this.toString = function() {
        return name + "(" + args.join(",") + ")";
    }
}

/**
 * Wraps a raw string with JavaScript code into a ScriptStatement object.
 */
function RawScriptStatement(code) {
    this.toString = function() { return code; }
}

/**
 * Convenience function to generate a 'waitForObject' script statement.
 */
function makeWaitStatement(o) {
    var f = new ScriptStatement("waitForObject");
    var realName = objectMap.realName(o);
    if (realName == "") {
        if (isNull(o)) {
            throw "Object vanished suddenly";
        } else {
            throw "Could not retrieve real name for a non-null object";
        }
    }
    f.addStringArg(realName);
    return f;
}
