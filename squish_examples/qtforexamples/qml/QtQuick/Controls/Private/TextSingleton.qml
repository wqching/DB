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

pragma Singleton
import QtQuick 2.2
Text {
    /**
      selectionItem is the item that currently has a text selection. On some platforms
      (iOS) you can select text without activating the input field. This means that
      selectionItem can be different from item with active focus on those platforms.
      */
    property Item selectionItem: null

    function updateSelectionItem(item)
    {
        // Convenience function to check if we should transfer or
        // remove selectionItem status from item.
        var selection = item.selectionStart !== item.selectionEnd
        if (item === selectionItem) {
            if (!selection)
                selectionItem = null
        } else if (selection) {
            if (selectionItem)
                selectionItem.select(selectionItem.cursorPosition, selectionItem.cursorPosition)
            selectionItem = item
        }
    }
}
