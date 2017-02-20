
function fetchRootContextFromObject(someQObject) {
    // Fetch context from object
    var ctx = qmlContext(someQObject);
    test.verify(!isNull(ctx), "Context fetched from object is valid");

    // Go up to root context, object may have been created in a sub-context
    while (!isNull(ctx.parentContext())) {
        test.log("Going up one QML context");
        ctx = ctx.parentContext();
    }

    return ctx;
}

function fetchRootContextFromEngine(someQObject) {
    // Fetch QML engine from some object it has already created
    var engine = qmlEngine(someQObject);
    test.verify(!isNull(engine), "Engine fetched from object is valid");

    // Fetch root context from engine, no need to traverse in this case
    return engine.rootContext();
}

function verifyContextProperty(ctx) {
    test.verify(!isNull(ctx), "Context to verify property on is valid");

    // Fetch custom property from root context (as a QVariant)
    var prop = ctx.contextProperty("appContextProperty");
    test.verify(!isNull(prop) && prop.isValid(), "QML context property could be fetched");

    // Extract actual QObject sub type from QVariant
    var app = object.convertTo(prop, "QObject");
    test.compare(!isNull(app) && typeName(app), "QGuiApplication", "Application object is valid and has correct type");
    test.compare(app.applicationName, "quickaddressbook", "Application object is accessible");
}

function main() {
    startApplication("quickaddressbook");

    var window = waitForObject(":Quick Addressbook_QQuickWindowQmlImpl");

    // 1st way to access QML context contents
    test.log("Accessing QML context via object and context traversal");
    verifyContextProperty(fetchRootContextFromObject(window));

    // 2nd way to access QML context contents
    test.log("Accessing QML context via object and engine")
    verifyContextProperty(fetchRootContextFromEngine(window));

    closeWindow(":Quick Addressbook_QQuickWindowQmlImpl");
}