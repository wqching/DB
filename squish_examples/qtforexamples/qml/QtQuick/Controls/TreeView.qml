/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.2
import QtQml.Models 2.2

BasicTableView {
    id: root

    property var model: null

    readonly property var currentIndex: modelAdaptor.mapRowToModelIndex(__currentRow)
    property ItemSelectionModel selection: null

    signal activated(var index)
    signal clicked(var index)
    signal doubleClicked(var index)
    signal pressAndHold(var index)
    signal expanded(var index)
    signal collapsed(var index)

    function isExpanded(index) {
        if (index.valid && index.model !== model) {
            console.warn("TreeView.isExpanded: model and index mismatch")
            return false
        }
        return modelAdaptor.isExpanded(index)
    }

    function collapse(index) {
        if (index.valid && index.model !== model)
            console.warn("TreeView.collapse: model and index mismatch")
        else
            modelAdaptor.collapse(index)
    }

    function expand(index) {
        if (index.valid && index.model !== model)
            console.warn("TreeView.expand: model and index mismatch")
        else
            modelAdaptor.expand(index)
    }

    function indexAt(x, y) {
        var obj = root.mapToItem(__listView.contentItem, x, y)
        return modelAdaptor.mapRowToModelIndex(__listView.indexAt(obj.x, obj.y))
    }

    style: Settings.styleComponent(Settings.style, "TreeViewStyle.qml", root)

    // Internal stuff. Do not look

    __viewTypeName: "TreeView"

    __model: TreeModelAdaptor {
        id: modelAdaptor
        model: root.model

        onExpanded: root.expanded(index)
        onCollapsed: root.collapsed(index)
    }

    __itemDelegateLoader: TreeViewItemDelegateLoader {
        __style: root.__style
        __itemDelegate: root.itemDelegate
        __mouseArea: mouseArea
        __treeModel: modelAdaptor
    }

    onSelectionModeChanged: if (!!selection) selection.clear()

    __mouseArea: MouseArea {
        id: mouseArea

        parent: __listView
        width: __listView.width
        height: __listView.height
        z: -1
        propagateComposedEvents: true
        focus: true
        // Note:  with boolean preventStealing we are keeping
        // the flickable from eating our mouse press events
        preventStealing: !Settings.hasTouchScreen

        property int clickedRow: -1
        property int pressedRow: -1
        property int pressedColumn: -1
        readonly property alias currentRow: root.__currentRow

        // Handle vertical scrolling whem dragging mouse outside boundaries
        property int autoScroll: 0 // 0 -> do nothing; 1 -> increment; 2 -> decrement
        property bool shiftPressed: false // forward shift key state to the autoscroll timer

        Timer {
            running: mouseArea.autoScroll !== 0 && __verticalScrollBar.visible
            interval: 20
            repeat: true
            onTriggered: {
                var oldPressedRow = mouseArea.pressedRow
                var row
                if (mouseArea.autoScroll === 1) {
                    __listView.incrementCurrentIndexBlocking();
                    row = __listView.indexAt(0, __listView.height + __listView.contentY)
                    if (row === -1)
                        row = __listView.count - 1
                } else {
                    __listView.decrementCurrentIndexBlocking();
                    row = __listView.indexAt(0, __listView.contentY)
                }

                if (row !== oldPressedRow) {
                    mouseArea.pressedRow = row
                    var modifiers = mouseArea.shiftPressed ? Qt.ShiftModifier : Qt.NoModifier
                    mouseArea.mouseSelect(row, modifiers, true /* drag */)
                }
            }
        }

        function mouseSelect(row, modifiers, drag) {
            if (!selection) {
                maybeWarnAboutSelectionMode()
                return
            }

            if (selectionMode) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(row)
                selection.setCurrentIndex(modelIndex, ItemSelectionModel.NoUpdate)
                if (selectionMode === SelectionMode.SingleSelection) {
                    selection.select(modelIndex, ItemSelectionModel.ClearAndSelect)
                } else {
                    var itemSelection = clickedRow === row ? modelIndex
                                        : modelAdaptor.selectionForRowRange(clickedRow, row)
                    if (selectionMode === SelectionMode.MultiSelection
                        || selectionMode === SelectionMode.ExtendedSelection && modifiers & Qt.ControlModifier) {
                        if (drag)
                            selection.select(itemSelection, ItemSelectionModel.ToggleCurrent)
                        else
                            selection.select(modelIndex, ItemSelectionModel.Toggle)
                    } else if (modifiers & Qt.ShiftModifier) {
                        selection.select(itemSelection, ItemSelectionModel.SelectCurrent)
                    } else {
                        clickedRow = row // Needed only when drag is true
                        selection.select(modelIndex, ItemSelectionModel.ClearAndSelect)
                    }
                }
            }
        }

        function keySelect(keyModifiers) {
            if (selectionMode) {
                if (!keyModifiers)
                    clickedRow = currentRow
                if (!(keyModifiers & Qt.ControlModifier))
                    mouseSelect(currentRow, keyModifiers, keyModifiers & Qt.ShiftModifier)
            }
        }

        function selected(row) {
            if (selectionMode === SelectionMode.NoSelection)
                return false

            var modelIndex = null
            if (!!selection) {
                modelIndex = modelAdaptor.mapRowToModelIndex(row)
                if (modelIndex.valid) {
                    if (selectionMode === SelectionMode.SingleSelection)
                        return selection.currentIndex === modelIndex
                    return selection.hasSelection && selection.isSelected(modelIndex)
                }
            }

            return row === currentRow
                   && (selectionMode === SelectionMode.SingleSelection
                       || (selectionMode > SelectionMode.SingleSelection && !selection))
        }

        function branchDecorationContains(x, y) {
            var clickedItem = __listView.itemAt(0, y + __listView.contentY)
            if (!(clickedItem && clickedItem.rowItem))
                return false
            var branchDecoration = clickedItem.rowItem.branchDecoration
            if (!branchDecoration)
                return false
            var pos = mapToItem(branchDecoration, x, y)
            return branchDecoration.contains(Qt.point(pos.x, pos.y))
        }

        function maybeWarnAboutSelectionMode() {
            if (selectionMode > SelectionMode.SingleSelection)
                console.warn("TreeView: Non-single selection is not supported without an ItemSelectionModel.")
        }

        onPressed: {
            pressedRow = __listView.indexAt(0, mouseY + __listView.contentY)
            pressedColumn = __listView.columnAt(mouseX)
            __listView.forceActiveFocus()
            if (pressedRow > -1 && !Settings.hasTouchScreen
                && !branchDecorationContains(mouse.x, mouse.y)) {
                __listView.currentIndex = pressedRow
                if (clickedRow === -1)
                    clickedRow = pressedRow
                mouseSelect(pressedRow, mouse.modifiers, false)
                if (!mouse.modifiers)
                    clickedRow = pressedRow
            }
        }

        onReleased: {
            pressedRow = -1
            pressedColumn = -1
            autoScroll = 0
        }

        onPositionChanged: {
            // NOTE: Testing for pressed is not technically needed, at least
            // until we decide to support tooltips or some other hover feature
            if (mouseY > __listView.height && pressed) {
                if (autoScroll === 1) return;
                autoScroll = 1
            } else if (mouseY < 0 && pressed) {
                if (autoScroll === 2) return;
                autoScroll = 2
            } else  {
                autoScroll = 0
            }

            if (pressed && containsMouse) {
                var oldPressedRow = pressedRow
                pressedRow = __listView.indexAt(0, mouseY + __listView.contentY)
                pressedColumn = __listView.columnAt(mouseX)
                if (pressedRow > -1 && oldPressedRow !== pressedRow) {
                    __listView.currentIndex = pressedRow
                    mouseSelect(pressedRow, mouse.modifiers, true /* drag */)
                }
            }
        }

        onExited: {
            pressedRow = -1
            pressedColumn = -1
        }

        onCanceled: {
            pressedRow = -1
            pressedColumn = -1
            autoScroll = 0
        }

        onClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(clickIndex)
                if (branchDecorationContains(mouse.x, mouse.y)) {
                    if (modelAdaptor.isExpanded(modelIndex))
                        modelAdaptor.collapse(modelIndex)
                    else
                        modelAdaptor.expand(modelIndex)
                } else if (root.__activateItemOnSingleClick) {
                    root.activated(modelIndex)
                }
                root.clicked(modelIndex)
            }
        }

        onDoubleClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(clickIndex)
                if (!root.__activateItemOnSingleClick)
                    root.activated(modelIndex)
                root.doubleClicked(modelIndex)
            }
        }

        onPressAndHold: {
            var pressIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (pressIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(pressIndex)
                root.pressAndHold(modelIndex)
            }
        }

        Keys.forwardTo: [root]

        Keys.onUpPressed: {
            event.accepted = __listView.decrementCurrentIndexBlocking()
            keySelect(event.modifiers)
        }

        Keys.onDownPressed: {
            event.accepted = __listView.incrementCurrentIndexBlocking()
            keySelect(event.modifiers)
        }

        Keys.onRightPressed: {
            if (root.currentIndex.valid)
                root.expand(currentIndex)
            else
                event.accepted = false
        }

        Keys.onLeftPressed: {
            if (root.currentIndex.valid)
                root.collapse(currentIndex)
            else
                event.accepted = false
        }

        Keys.onReturnPressed: {
            if (root.currentIndex.valid)
                root.activated(currentIndex)
            else
                event.accepted = false
        }

        Keys.onPressed: {
            __listView.scrollIfNeeded(event.key)

            if (event.key === Qt.Key_A && event.modifiers & Qt.ControlModifier
                && !!selection && selectionMode > SelectionMode.SingleSelection) {
                var sel = modelAdaptor.selectionForRowRange(0, __listView.count - 1)
                selection.select(sel, ItemSelectionModel.SelectCurrent)
            } else if (event.key === Qt.Key_Shift) {
                shiftPressed = true
            }
        }

        Keys.onReleased: {
            if (event.key === Qt.Key_Shift)
                shiftPressed = false
        }
    }
}
