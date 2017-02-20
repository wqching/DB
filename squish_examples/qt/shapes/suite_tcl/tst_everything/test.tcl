proc main {} {
    startApplication "shapes" 
    # Added by hand #1
    test verify [property get [waitForObject ":Add Box_QPushButton"] enabled]
    test verify [property get [waitForObject ":Add Polygon_QPushButton"] enabled]
    test verify [property get [waitForObject ":Add Text..._QPushButton"] enabled]
    test verify [property get [waitForObject ":Quit_QPushButton"] enabled]
    test compare [property get [findObject ":Delete..._QPushButton"] enabled] 0
    test compare [property get [findObject ":_QSpinBox"] enabled] 0
    # End of added by hand #1
    invoke clickButton [waitForObject ":Add Box_QPushButton"]
    invoke clickButton [waitForObject ":Add Box_QPushButton"] 
    invoke clickButton [waitForObject ":Add Polygon_QPushButton"]
    # Added by hand #2
    set rectItem1 [waitForObject ":_QGraphicsRectItem"]
    set rectItem2 [waitForObject ":_QGraphicsRectItem_2"]
    set rectItem1X [property get [property get $rectItem1 rect] x]
    set rectItem1Y [property get [property get $rectItem1 rect] y]
    set rectItem2X [property get [property get $rectItem2 rect] x]
    set rectItem2Y [property get [property get $rectItem2 rect] y]
    test compare $rectItem2X [expr $rectItem1X + 5]
    test compare $rectItem2Y [expr $rectItem1Y + 5]
    test verify [expr [property get $rectItem1 zValue] < [property get $rectItem2 zValue]]
    set polygonItem [waitForObject ":_QGraphicsPolygonItem"]
    test compare [invoke [property get $polygonItem polygon] count] 3 
    # End of added by hand #2
    invoke openContextMenu [waitForObject ":_QGraphicsPolygonItem"] 142 56 0
    invoke activateItem [waitForObjectItem ":_QMenu" "Square"]
    invoke clickButton [waitForObject ":Add Text..._QPushButton"]
    sendEvent "QMoveEvent" [waitForObject ":Shapes - Add Text_QInputDialog"] 153 171 80 130
    invoke type [waitForObject ":Text:_QLineEdit"] "Some Text"
    invoke type [waitForObject ":Text:_QLineEdit"] "<Return>"
    # Added by hand #3
    test compare [invoke [property get $polygonItem polygon] count] 4 
    set textItem [waitForObject ":_QGraphicsTextItem"]
    test compare [invoke $textItem toPlainText] "Some Text" 
    set countLCD [waitForObject ":_QLCDNumber"]
    test compare [invoke $countLCD intValue] 4 
    test verify [property get [waitForObject ":Delete..._QPushButton"] enabled]
    test verify [property get [waitForObject ":_QSpinBox"] enabled]
    # End of added by hand #3
    invoke doubleClick [waitForObject ":_QGraphicsProxyWidget"] 306 113 0 [enum Qt LeftButton] 
    sendEvent "QMouseEvent" [waitForObject ":_QGraphicsProxyWidget"] [enum QEvent MouseButtonPress] 328 99 [enum Qt LeftButton] 0 
    invoke dragItemBy [waitForObject ":_QGraphicsProxyWidget"] 328 99 -146 -103 1 [enum Qt LeftButton] 
    invoke doubleClick [waitForObject ":_QGraphicsProxyWidget"] 328 66 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":Shapes_QGraphicsView"] 362 105 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":Shapes_QGraphicsView"] 90 296 0 [enum Qt LeftButton] 
    invoke mouseDrag [waitForObject ":Shapes_QGraphicsView"] 351 167 -168 -161 1 [enum Qt LeftButton] 
    invoke dragItemBy [waitForObject ":_QGraphicsPolygonItem"] 48 48 93 132 1 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsProxyWidget"] 335 207 0 [enum Qt LeftButton] 
    invoke doubleClick [waitForObject ":_QGraphicsProxyWidget"] 335 207 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsPolygonItem"] 50 33 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsProxyWidget"] 328 101 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsProxyWidget"] 249 79 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsPolygonItem"] 26 68 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsProxyWidget"] 245 218 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":_QGraphicsTextItem"] 102 24 0 [enum Qt LeftButton] 
    invoke mouseClick [waitForObject ":Shapes_QGraphicsView"] 389 128 0 [enum Qt LeftButton] 
    sendEvent "QMouseEvent" [waitForObject ":_QGraphicsProxyWidget"] [enum QEvent MouseButtonPress] 322 121 [enum Qt LeftButton] 0 
    invoke dragItemBy [waitForObject ":_QGraphicsProxyWidget"] 322 121 29 36 1 [enum Qt LeftButton] 
    invoke mouseDrag [waitForObject ":Shapes_QGraphicsView"] 372 138 -36 13 1 [enum Qt LeftButton] 
    invoke clickButton [waitForObject ":Delete..._QPushButton"]
    invoke clickButton [waitForObject ":Shapes - Delete.Yes to All_QPushButton"]
    # Added by hand #4
    set countLCD [waitForObject ":_QLCDNumber"]
    test compare [invoke $countLCD intValue] 2 
    test compare [property get [findObject ":Delete..._QPushButton"] enabled] 0
    test compare [property get [findObject ":_QSpinBox"] enabled] 0
    # End of added by hand #4
    invoke clickButton [waitForObject ":Quit_QPushButton"]
}
