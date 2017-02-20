source("monkey.js");
source("qtsupport.js");

/* This test demonstrates the usage of 'Monkey' objects. Such objects
 * start an application and then, when given the right 'Toolkit' object,
 * randomly interact with different GUI controls. It's possible to find
 * endless loops, crashes etc. in the application this way---providing
 * the monkey test is left to run for long enough.
 */
function main()
{
    /* Make sure that the Qt4/Qt5 addressbook example which comes with Squish
     * is registered before executing the next line. You can also use your
     * own application - but make sure to use either Qt3Toolkit or
     * QtWidgetToolkit or even QtQuickToolkit depending on your application.
     */
    var monkey = new Monkey("addressbook", new QtWidgetToolkit());
    monkey.logStatement = function(s) { test.log(s); }
    monkey.onWarning = function(s) { test.warning(s); }
    monkey.onError = function(s) { test.fatal(s); }
    monkey.run();
}
/* If you need to manually terminate the monkey test, move the mouse
 * outside the AUT and press Esc to invoke Squish's Control Bar window's
 * Stop action: this may require a few attempts.
 */
