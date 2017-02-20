<squishidl includePaths="S:\shellhelper\tst_binaryPackage-Qt5.5.0-MSVC10\b0\squish-f716a8f-unpatched-qtwebkit;S:\shellhelper\tst_binaryPackage-Qt5.5.0-MSVC10\b0\squish-f716a8f-unpatched-qtwebkit/src;S:\SHELLH~1\TS6690~1.0-M\b0\SQUISH~1;S:\SHELLH~1\TS6690~1.0-M\b0\SQUISH~1/src;Q:/MSVC10/x86/5.5.0/include;Q:/MSVC10/x86/5.5.0/include/QtCore;Q:/MSVC10/x86/5.5.0/include/QtGui;Q:/MSVC10/x86/5.5.0/include/QtXml;Q:/MSVC10/x86/5.5.0/include/QtNetwork;Q:/MSVC10/x86/5.5.0/include/QtCore/5.5.0;Q:/MSVC10/x86/5.5.0/include/QtCore/5.5.0/QtCore;Q:/MSVC10/x86/5.5.0/include/QtGui/5.5.0/QtGui;Q:/MSVC10/x86/5.5.0/include/QtOpenGL;Q:/MSVC10/x86/5.5.0/include/QtSql;Q:/MSVC10/x86/5.5.0/include/QtDeclarative;Q:/MSVC10/x86/5.5.0/include/QtWebKit;Q:/MSVC10/x86/5.5.0/include/QtWebKitWidgets;Q:/MSVC10/x86/5.5.0/include/QtWidgets/5.5.0/QtWidgets;Q:/MSVC10/x86/5.5.0/include/QtPrintSupport;Q:/MSVC10/x86/5.5.0/include/QtWidgets;Q:/MSVC10/x86/5.5.0/mkspecs/win32-msvc2010;S:\SHELLH~1\TS6690~1.0-M\b0\SQUISH~1/include;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\include;C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\SDK\v1.1\include\" version="1.119">
<class name="__global__" />
<class name="CanvasInterface">
<method name="draw" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="p" type="QPainter" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="clipRect" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="handleMousePressEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseMoveEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseReleaseEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseDoubleClickEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="save" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="load" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
</class>
<class name="CanvasItem" super="CanvasInterface">
<enum name="Type">
<enumerator name="TRect" />
</enum>
<method name="canvasModel" returnType="CanvasModel" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="0" />
<method name="handleMousePressEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseMoveEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseReleaseEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseDoubleClickEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="rect" returnType="QRect" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="hit" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1">
<argument array="0" arraylen="0" name="pos" type="QPoint" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="moveBy" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="pos" type="QPoint" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="updateContentsSize" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" />
<method name="updateContentsSize" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="r" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="type" returnType="int" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
</class>
<class name="CanvasRect" super="CanvasItem">
<method name="draw" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="p" type="QPainter" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="clipRect" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="rect" returnType="QRect" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="hit" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1">
<argument array="0" arraylen="0" name="pos" type="QPoint" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="moveBy" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="diff" type="QPoint" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="save" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="load" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="type" returnType="int" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
</class>
<class name="CanvasModel" super="QObject">
<property array="0" arraylen="0" name="staticMetaObject" type="QMetaObject" const1="1" const2="0" reference="0" pointer="0" readable="1" writable="0" stored="1" static="1" />
<method name="metaObject" returnType="QMetaObject" returnType.const1="1" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="qt_metacast" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="n" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="n" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
<constructor name="CanvasModel" returnType="" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" />
<method name="draw" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="p" type="QPainter" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="clipRect" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="handleMousePressEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseMoveEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseReleaseEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="handleMouseDoubleClickEvent" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="e" type="QMouseEvent" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="addItem" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="item" type="CanvasItem" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="takeItem" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="item" type="CanvasItem" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="removeItem" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="item" type="CanvasItem" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="clear" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" />
<method name="save" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="load" returnType="bool" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="ds" type="QDataStream" const1="0" const2="0" reference="1" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="numItems" returnType="int" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="item" returnType="CanvasItem" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="index" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="update" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="r" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="setContentsSize" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="s" type="QSize" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="contentsSize" returnType="QSize" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="addView" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="v" type="CanvasView" const1="0" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="updateNotify" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="r" type="QRect" const1="1" const2="0" reference="1" pointer="0" readable="1" writable="0" stored="1" />
</method>
<method name="contentsSizeChanged" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="w" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="h" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
</class>
<class name="CanvasView" super="QWidget">
<property array="0" arraylen="0" name="staticMetaObject" type="QMetaObject" const1="1" const2="0" reference="0" pointer="0" readable="1" writable="0" stored="1" static="1" />
<method name="metaObject" returnType="QMetaObject" returnType.const1="1" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="1" />
<method name="qt_metacast" returnType="void" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="0">
<argument array="0" arraylen="0" name="" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="tr" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="n" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
</method>
<method name="trUtf8" returnType="QString" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="0" returnType.array="0" returnType.arraylen="0" const="0" static="1">
<argument array="0" arraylen="0" name="s" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="c" type="char" const1="1" const2="0" reference="0" pointer="1" readable="1" writable="1" stored="1" />
<argument array="0" arraylen="0" name="n" type="int" const1="0" const2="0" reference="0" pointer="0" readable="1" writable="1" stored="1" />
</method>
<method name="canvasModel" returnType="CanvasModel" returnType.const1="0" returnType.const2="0" returnType.reference="0" returnType.pointer="1" returnType.array="0" returnType.arraylen="0" const="0" />
</class>
</squishidl>
