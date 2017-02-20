sub main
{
    startApplication("shapes");
    # Added by hand #1
    test::verify(waitForObject(":Add Box_QPushButton")->enabled);
    test::verify(waitForObject(":Add Polygon_QPushButton")->enabled);
    test::verify(waitForObject(":Add Text..._QPushButton")->enabled);
    test::verify(waitForObject(":Quit_QPushButton")->enabled);
    test::verify(!findObject(":Delete..._QPushButton")->enabled);
    test::verify(!findObject(":_QSpinBox")->enabled);
    # End of added by hand #1
    clickButton(waitForObject(":Add Box_QPushButton"));
    clickButton(waitForObject(":Add Box_QPushButton"));
    clickButton(waitForObject(":Add Polygon_QPushButton"));
    # Added by hand #2
    my $rectItem1 = waitForObject(":_QGraphicsRectItem");
    my $rectItem2 = waitForObject(":_QGraphicsRectItem_2");
    test::verify($rectItem1->rect->x + 5 eq $rectItem2->rect->x);
    test::verify($rectItem1->rect->y + 5 eq $rectItem2->rect->y);
    test::verify($rectItem1->zValue lt $rectItem2->zValue);
    my $polygonItem = waitForObject(":_QGraphicsPolygonItem");
    test::verify($polygonItem->polygon->count() == 3);
    # End of added by hand #2
    openContextMenu(waitForObject(":_QGraphicsPolygonItem"), 142, 56, 0);
    activateItem(waitForObjectItem(":_QMenu", "Square"));
    clickButton(waitForObject(":Add Text..._QPushButton"));
    sendEvent("QMoveEvent", waitForObject(":Shapes - Add Text_QInputDialog"), 153, 171, 80, 130);
    type(waitForObject(":Text:_QLineEdit"), "Some Text");
    type(waitForObject(":Text:_QLineEdit"), "<Return>");
    # Added by hand #3
    test::verify($polygonItem->polygon->count() == 4);
    my $textItem = waitForObject(":_QGraphicsTextItem");
    test::verify($textItem->toPlainText() eq "Some Text");
    my $countLCD = waitForObject(":_QLCDNumber");
    test::verify($countLCD->intValue == 4);
    test::verify(waitForObject(":Delete..._QPushButton")->enabled);
    test::verify(waitForObject(":_QSpinBox")->enabled);
    # End of added by hand #3
    doubleClick(waitForObject(":_QGraphicsProxyWidget"), 306, 113, 0, Qt::LeftButton);
    sendEvent("QMouseEvent", waitForObject(":_QGraphicsProxyWidget"), QEvent::MouseButtonPress, 328, 99, Qt::LeftButton, 0);
    dragItemBy(waitForObject(":_QGraphicsProxyWidget"), 328, 99, -146, -103, 1, Qt::LeftButton);
    doubleClick(waitForObject(":_QGraphicsProxyWidget"), 328, 66, 0, Qt::LeftButton);
    mouseClick(waitForObject(":Shapes_QGraphicsView"), 362, 105, 0, Qt::LeftButton);
    mouseClick(waitForObject(":Shapes_QGraphicsView"), 90, 296, 0, Qt::LeftButton);
    mouseDrag(waitForObject(":Shapes_QGraphicsView"), 351, 167, -168, -161, 1, Qt::LeftButton);
    dragItemBy(waitForObject(":_QGraphicsPolygonItem"), 48, 48, 93, 132, 1, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsProxyWidget"), 335, 207, 0, Qt::LeftButton);
    doubleClick(waitForObject(":_QGraphicsProxyWidget"), 335, 207, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsPolygonItem"), 50, 33, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsProxyWidget"), 328, 101, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsProxyWidget"), 249, 79, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsPolygonItem"), 26, 68, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsProxyWidget"), 245, 218, 0, Qt::LeftButton);
    mouseClick(waitForObject(":_QGraphicsTextItem"), 102, 24, 0, Qt::LeftButton);
    mouseClick(waitForObject(":Shapes_QGraphicsView"), 389, 128, 0, Qt::LeftButton);
    sendEvent("QMouseEvent", waitForObject(":_QGraphicsProxyWidget"), QEvent::MouseButtonPress, 322, 121, Qt::LeftButton, 0);
    dragItemBy(waitForObject(":_QGraphicsProxyWidget"), 322, 121, 29, 36, 1, Qt::LeftButton);
    mouseDrag(waitForObject(":Shapes_QGraphicsView"), 372, 138, -36, 13, 1, Qt::LeftButton);
    clickButton(waitForObject(":Delete..._QPushButton"));
    clickButton(waitForObject(":Shapes - Delete.Yes to All_QPushButton"));
    # Added by hand #4
    $countLCD = waitForObject(":_QLCDNumber");
    test::verify($countLCD->intValue == 2);
    test::verify(!findObject(":Delete..._QPushButton")->enabled);
    test::verify(!findObject(":_QSpinBox")->enabled);
    # End of added by hand #4
    clickButton(waitForObject(":Quit_QPushButton"));
};
