source("util.js"); // for shuffleArray()
source("scriptstatement.js");

function Monkey(app, gui)
{
    this.run = function() {
        startApplication( app );

        subsequentFails = 0

        while (true) {
            try {
                this.guardedRun();
            } catch(e) {
                this.onWarning("Error occurred while accessing object (probably a GUI object that vanished suddenly): " + e);
                // Snooze here to avoid filling up the log too quickly in case of a permanent error
                snooze(1);
            }
        }
    }

    this.guardedRun = function() {
        var o = gui.chooseRandomObject();
        if (!o) {
            this.onWarning("Couldn't find appropriate object for interaction (the choosen GUI object probably vanished suddenly)");
            if ( ++subsequentFails == 3 ) {
                this.onError("Failed to find an object appropriate for interaction in three consecutive tries; giving up.");
                return false;
            }
        } else if (objectMap.realName(o) == "") {
            this.onWarning("Ignoring empty real name for an object (probably a GUI object that vanished while trying to access it)");
            return false;
        } else {
            subsequentFails = 0;

            var statement = gui.statementForObject(o);
            if (!statement) {
                this.onWarning("Don't know what script statement to run for objects of type " + typeName(o));
            } else {
                var cmd = statement.toString() + ";";
                try {
                    this.logStatement(cmd);
                    eval(cmd);
                } catch ( e ) {
                    if ( ++subsequentFails == 3 ) {
                        this.onError("Failed to find an object appropriate for interaction in three consecutive tries; giving up.");
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
