# encoding: UTF-8
require 'squish'

include Squish

def main
  startApplication("shapes")
  # Added by hand #1
  Test.verify(waitForObject(":Add Box_QPushButton").enabled)
  Test.verify(waitForObject(":Add Polygon_QPushButton").enabled)
  Test.verify(waitForObject(":Add Text..._QPushButton").enabled)
  Test.verify(waitForObject(":Quit_QPushButton").enabled)
  Test.verify(!findObject(":Delete..._QPushButton").enabled)
  Test.verify(!findObject(":_QSpinBox").enabled)
  # End of added by hand #1
  clickButton(waitForObject(":Add Box_QPushButton"))
  clickButton(waitForObject(":Add Box_QPushButton"))
  clickButton(waitForObject(":Add Polygon_QPushButton"))
  # Added by hand #2
  rectItem1 = waitForObject(":_QGraphicsRectItem")
  rectItem2 = waitForObject(":_QGraphicsRectItem_2")
  Test.verify(rectItem1.rect.x + 5 == rectItem2.rect.x)
  Test.verify(rectItem1.rect.y + 5 == rectItem2.rect.y)
  Test.verify(rectItem1.zValue < rectItem2.zValue)
  polygonItem = waitForObject(":_QGraphicsPolygonItem")
  Test.verify(polygonItem.polygon.count() == 3)
  # End of added by hand #2
  openContextMenu(waitForObject(":_QGraphicsPolygonItem"), 142, 56, 0)
  activateItem(waitForObjectItem(":_QMenu", "Square"))
  clickButton(waitForObject(":Add Text..._QPushButton"))
  sendEvent("QMoveEvent", waitForObject(":Shapes - Add Text_QInputDialog"), 153, 171, 80, 130)
  type(waitForObject(":Text:_QLineEdit"), "Some Text")
  type(waitForObject(":Text:_QLineEdit"), "<Return>")
  # Added by hand #3
  Test.verify(polygonItem.polygon.count() == 4)
  textItem = waitForObject(":_QGraphicsTextItem")
  Test.verify(textItem.toPlainText() == "Some Text")
  countLCD = waitForObject(":_QLCDNumber")
  Test.verify(countLCD.intValue == 4)
  Test.verify(waitForObject(":Delete..._QPushButton").enabled)
  Test.verify(waitForObject(":_QSpinBox").enabled)
  # End of added by hand #3
  doubleClick(waitForObject(":_QGraphicsProxyWidget"), 306, 113, 0, Qt::LEFT_BUTTON)
  sendEvent("QMouseEvent", waitForObject(":_QGraphicsProxyWidget"), QEvent::MOUSE_BUTTON_PRESS, 328, 99, Qt::LEFT_BUTTON, 0)
  dragItemBy(waitForObject(":_QGraphicsProxyWidget"), 328, 99, -146, -103, 1, Qt::LEFT_BUTTON)
  doubleClick(waitForObject(":_QGraphicsProxyWidget"), 328, 66, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":Shapes_QGraphicsView"), 362, 105, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":Shapes_QGraphicsView"), 90, 296, 0, Qt::LEFT_BUTTON)
  mouseDrag(waitForObject(":Shapes_QGraphicsView"), 351, 167, -168, -161, 1, Qt::LEFT_BUTTON)
  dragItemBy(waitForObject(":_QGraphicsPolygonItem"), 48, 48, 93, 132, 1, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsProxyWidget"), 335, 207, 0, Qt::LEFT_BUTTON)
  doubleClick(waitForObject(":_QGraphicsProxyWidget"), 335, 207, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsPolygonItem"), 50, 33, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsProxyWidget"), 328, 101, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsProxyWidget"), 249, 79, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsPolygonItem"), 26, 68, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsProxyWidget"), 245, 218, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":_QGraphicsTextItem"), 102, 24, 0, Qt::LEFT_BUTTON)
  mouseClick(waitForObject(":Shapes_QGraphicsView"), 389, 128, 0, Qt::LEFT_BUTTON)
  sendEvent("QMouseEvent", waitForObject(":_QGraphicsProxyWidget"), QEvent::MOUSE_BUTTON_PRESS, 322, 121, Qt::LEFT_BUTTON, 0)
  dragItemBy(waitForObject(":_QGraphicsProxyWidget"), 322, 121, 29, 36, 1, Qt::LEFT_BUTTON)
  mouseDrag(waitForObject(":Shapes_QGraphicsView"), 372, 138, -36, 13, 1, Qt::LEFT_BUTTON)
  clickButton(waitForObject(":Delete..._QPushButton"))
  clickButton(waitForObject(":Shapes - Delete.Yes to All_QPushButton"))
  # Added by hand #4
  countLCD = waitForObject(":_QLCDNumber")
  Test.verify(countLCD.intValue == 2)
  Test.verify(!findObject(":Delete..._QPushButton").enabled)
  Test.verify(!findObject(":_QSpinBox").enabled)
  # End of added by hand #4
  clickButton(waitForObject(":Quit_QPushButton"))
end
