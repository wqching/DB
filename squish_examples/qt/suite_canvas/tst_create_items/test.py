def checkRectangle(item, x, y, width, height):
    test.compare(item.rect().x, x)
    test.compare(item.rect().y, y)
    test.compare(item.rect().width, width)
    test.compare(item.rect().height, height)

def main():
    snooze(1.5)
    sendEvent("QMoveEvent", ":Canvas_QMainWindow", 572, 471, 538, 402)

    # insert 3 rectangular items
    mouseClick(":Canvas.CanvasView_CanvasView", 90, 56, 1, Qt.LeftButton)
    mouseClick(":Canvas.CanvasView_CanvasView", 170, 173, 1, Qt.LeftButton)
    mouseClick(":Canvas.CanvasView_CanvasView", 271, 96, 1, Qt.LeftButton)
    snooze(0.5)
    
    # retrieve reference to the canvas model
    canvas = waitForObject(":Canvas.CanvasView_CanvasView")
    model = canvas.canvasModel()
    
    # check that it contains 3 items
    test.compare(model.numItems(), 3)
    
    # for each item, check that it has the correct geometry
    checkRectangle(model.item(0), 90, 56, 50, 70)
    checkRectangle(model.item(1), 170, 173, 50, 70)
    checkRectangle(model.item(2), 271, 96, 50, 70)

    # close and exit
    sendEvent("QCloseEvent", ":Canvas_QMainWindow")
