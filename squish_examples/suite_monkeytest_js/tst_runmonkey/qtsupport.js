source("util.js"); // for enumerateObjects() and makeRandomString()
source("scriptstatement.js");

var QtShared = new function()
{
    this.mouseClickXYConstructor = function(o)
    {
        var f = new ScriptStatement("mouseClick");
        f.addArg(makeWaitStatement(o).toString());
        f.addArg(Math.floor(Math.random() * o.width));
        f.addArg(Math.floor(Math.random() * o.height));
        var button = Math.random() > 0.5 ? "Qt.RightButton"
                                         : "Qt.LeftButton";
        f.addArg(button);
        f.addArg(button);
        return f;
    }

    this.clickButtonConstructor = function(o)
    {
        var f = new ScriptStatement("clickButton");
        f.addArg(makeWaitStatement(o).toString());
        return f;
    }

    this.typeConstructor = function(o)
    {
        var f = new ScriptStatement("type");
        f.addArg(makeWaitStatement(o).toString());
        f.addStringArg(makeRandomString(100));
        return f;
    }

    this.closeWhatsThisConstructor = function(o)
    {
       var f = new ScriptStatement("sendEvent");
       f.addStringArg("QCloseEvent");
       f.addStringArg("{type='QWhatsThis'}");
       return f;
    }

    /**
     * Determines whether an object is an instance of the class specified by
     * the given class name.
     *
     * @param o An object reference
     * @param cn The name of a class
     * @param typeNameFn a function to resolve the name of the object´s type
     * @param inheritsFn a function which is supposed to test whether a given object is derived from a given class (name)
     *
     * @return True if the given object is an instance of the specified class,
     * or if the specified class is a base class.
     */
    this.isA = function(o, cn, typeNameFn, inheritsFn)
    {
        if (!this.cachedResults)
            this.cachedResults = {}


        var concreteClassName = typeNameFn(o);
        if (concreteClassName in this.cachedResults) {
            if (cn in this.cachedResults[concreteClassName])
                return this.cachedResults[concreteClassName][cn];
        } else {
            this.cachedResults[concreteClassName] = {}
        }
        
        result = inheritsFn(o, cn);
        this.cachedResults[concreteClassName][cn] = result;
        return result;
    }

    this.statementForObject = function(o, statementConstructors, typeNameFn, inheritsFn)
    {
        for (var key in statementConstructors) {
            if (QtShared.isA(o, key, typeNameFn, inheritsFn)) {
                return statementConstructors[key](o);
            }
        }
        return undefined;
    }

    this.chooseRandomObject = function(statementConstructors, typeNameFn, inheritsFn)
    {
        var recurseIntoObject = function(o) {
            // Customize the return value of this function to skip recursing
            // into objects whose children should never be automated by the
            // monkey.
            return true;
        }

        var isObjectReady = function(o) {
            try {
                return waitForObject(o, 0) != undefined;
            } catch(e) {
                return false;
            }
        }

        var activePopupWidget = QApplication.activePopupWidget();
        if (!isNull(activePopupWidget)) {
            cast(activePopupWidget, activePopupWidget.metaObject().className())
            return activePopupWidget;
        }

        var parentObject;
        var activeModalWidget = QApplication.activeModalWidget();
        if (!isNull(activeModalWidget)) {
            parentObject = activeModalWidget;
        }

        var maxRandomValue = -1;
        var chosenObject;
        enumerateObjects(
            function(o) {
                if (!QtShared.statementForObject(o, statementConstructors, typeNameFn, inheritsFn)) {
                    return recurseIntoObject(o);
                }

                if (!isObjectReady(o)) {
                    return recurseIntoObject(o);
                }

                var r = Math.random();
                if (r > maxRandomValue) {
                    chosenObject = o;
                    maxRandomValue = r;
                }

                return recurseIntoObject(o);
            },
            parentObject);

        return chosenObject;
    }
}

function QtWidgetToolkit()
{
    var inheritsFn = function(o, cn)
    {
        return o.inherits && o.inherits(cn);
    }

    var activateItemConstructor = function(o)
    {
        var actions = o.actions();
        var numActions = actions.count();

        var indices = [];
        var i;
        for (i = 0; i < numActions; ++i)
            indices.push(i);
        shuffleArray(indices);

        for (i = 0; i < numActions; ++i) {
            var a = actions.at(indices[i]);
            if (a.enabled && a.visible) {
                var cleanedString = String(a.text).replace("&", "");
                if (cleanedString != "" && cleanedString != "Close" && cleanedString != "Quit" && cleanedString != "Exit") {
                    var f = new ScriptStatement("activateItem");
                    f.addArg(makeWaitStatement(o));
                    f.addStringArg(cleanedString);
                    return f;
                }
            }
        }

        var sendEventStatement = new ScriptStatement("sendEvent");
        sendEventStatement.addStringArg("QCloseEvent");
        sendEventStatement.addStringArg(objectMap.realName(o));
        return sendEventStatement;
    }

    var selectComboBoxItemConstructor = function(o)
    {
        return new RawScriptStatement("\
            var o = " + makeWaitStatement(o).toString() + ";\
            o.currentIndex = Math.random() * o.count;\
        ");
    }

    var selectRandomSpinBoxValueConstructor = function(o)
    {
        return new RawScriptStatement("\
            var o = " + makeWaitStatement(o).toString() + ";\
            o.value = o.minimum + Math.random() * (o.maximum - o.minimum);\
        ");
    }

    var selectRandomCalendarDayConstructor = function(o)
    {
        return new RawScriptStatement("\
            var o = " + makeWaitStatement(o).toString() + ";\
            o.selectedDate = o.minimumDate.addDays(Math.random() * o.minimumDate.daysTo(o.maximumDate));\
        ");
    }

    var statementConstructors = {
        "QAbstractButton": QtShared.clickButtonConstructor,
        "QWhatsThat": QtShared.closeWhatsThisConstructor,
        "QLineEdit": QtShared.typeConstructor,
        "QScrollBar": QtShared.mouseClickXYConstructor,
        "QAbstractScrollArea": QtShared.mouseClickXYConstructor,
        "QMenuBar": activateItemConstructor,
        "QMenu": activateItemConstructor,
        "QComboBox": selectComboBoxItemConstructor,
        "QSpinBox": selectRandomSpinBoxValueConstructor,
        "QCalendarWidget": selectRandomCalendarDayConstructor
    }

    this.chooseRandomObject = function() {
        return QtShared.chooseRandomObject(statementConstructors, typeName, inheritsFn);
    }

    this.statementForObject = function(o) {
        return QtShared.statementForObject(o, statementConstructors, typeName, inheritsFn);
    }
}

function Qt3Toolkit()
{
    var inheritsFn = function(o, cn)
    {
        return o.inherits && o.inherits(cn);
    }

    var activateItemConstructor = function(o)
    {
        var md = castToQMenuData(o);
        var numItems = md.count();

        var indices = [];
        var i;
        for (i = 0; i < numItems; ++i)
            indices.push(i);
        shuffleArray(indices);

        for (i = 0; i < numItems; ++i) {
            var id = md.idAt(i);
            if (md.isItemEnabled(id) && md.isItemVisible(id)) {
                var cleanedString = String(md.text(id)).replace("&", "");
                cleanedString = cleanedString.substr(0, cleanedString.indexOf("\t"));
                if (cleanedString != "" && cleanedString != "Close" && cleanedString != "Quit" && cleanedString != "Exit") {
                    var f = new ScriptStatement("activateItem");
                    f.addArg(makeWaitStatement(o));
                    f.addStringArg(cleanedString);
                    return f;
                }
            }
        }

        var sendEventStatement = new ScriptStatement("sendEvent");
        sendEventStatement.addStringArg("QCloseEvent");
        sendEventStatement.addStringArg(objectMap.realName(o));
        return sendEventStatement;
    }

    var statementConstructors = {
        "QButton": QtShared.clickButtonConstructor,
        "QWhatsThat": function(o) {
            var f = new ScriptStatement("sendEvent");
            f.addStringArg("QCloseEvent");
            f.addStringArg("{type='QWhatsThis'}");
            return f;
        },
        "QLineEdit": QtShared.typeConstructor,
        "QTextEdit": QtShared.typeConstructor,
        "QScrollBar": QtShared.mouseClickXYConstructor,
        "QListView": QtShared.mouseClickXYConstructor,
        "QMenuBar": activateItemConstructor,
        "QPopupMenu": activateItemConstructor
    }

    this.chooseRandomObject = function() {
        return QtShared.chooseRandomObject(statementConstructors, typeName, inheritsFn);
    }

    this.statementForObject = function(o) {
        return QtShared.statementForObject(o, statementConstructors, typeName, inheritsFn);
    }
}

function QtQuickToolkit()
{
    var typeNameFn = function(o)
    {
        return typeName(o).split("_")[0];
    }

    var inheritsFn = function(o, cn)
    {
        return (typeNameFn(o) == cn);
    }

    var selectComboBoxItemConstructor = function(o)
    {
        return new RawScriptStatement("\
            var o = " + makeWaitStatement(o).toString() + ";\
            o.currentIndex = Math.random() * o.count;\
        ");
    }

    var selectRandomValue = function(o)
    {
        return new RawScriptStatement("\
            var o = " + makeWaitStatement(o).toString() + ";\
            o.value = o.minimumValue + Math.random() * (o.maximumValue - o.minimumValue);\
        ");
    }

    var statementConstructors = {
      "QQuickBorderImage": QtShared.mouseClickXYConstructor,
      "QQuickRectangle": QtShared.mouseClickXYConstructor,
      "QQuickImage": QtShared.mouseClickXYConstructor,
      "QQuickAnimatedImage": QtShared.mouseClickXYConstructor,
      "QQuickAnimatedSprite": QtShared.mouseClickXYConstructor,
      "QQuickSpriteSequence": QtShared.mouseClickXYConstructor,
      "QQuickText": QtShared.mouseClickXYConstructor,
      "QQuickWindow": QtShared.mouseClickXYConstructor,
      "QQuickTextInput": QtShared.typeConstructor,
      "QQuickTextEdit": QtShared.typeConstructor,
      "Button": QtShared.mouseClickXYConstructor,
      "ToolButton": QtShared.mouseClickXYConstructor,
      "RadioButton": QtShared.mouseClickXYConstructor,
      "SpinBox": selectRandomValue,
      "ComboBox": selectComboBoxItemConstructor,
      "CheckBox": QtShared.mouseClickXYConstructor,
      "Switch": QtShared.mouseClickXYConstructor,
      "Slider": selectRandomValue,
      "ProgressBar": selectRandomValue,
      "TextArea": QtShared.typeConstructor,
      "TextField": QtShared.typeConstructor
    }

	this.chooseRandomObject = function()
    {
        return QtShared.chooseRandomObject(statementConstructors, typeNameFn, inheritsFn);
    }

    this.statementForObject = function(o)
    {
        return QtShared.statementForObject(o, statementConstructors, typeNameFn, inheritsFn);
    }

}