sub checkAnItem {
    my ( $indent, $item, $root ) = @_;
    if ( $indent > -1 ) {
        my $checked  = "";
        my $selected = "";
        if ( $item->checkState(0) == Qt::Checked ) {
            $checked = " +checked";
        }
        if ( $item->isSelected() ) {
            $selected = " +selected";
        }
        test::log( "|"
              . " " x $indent . "'"
              . $item->text(0) . "'"
              . $checked
              . $selected );
    }
    else {
        $indent = -4;
    }

    # Only show visible child items
    if ( $item != $root && $item->isExpanded() || $item == $root ) {
        for ( my $row = 0 ; $row < $item->childCount() ; ++$row ) {
            checkAnItem( $indent + 4, $item->child($row), $root );
        }
    }
}

sub main {
    startApplication("itemviews");
    my $treeWidgetName = "{type='QTreeWidget' unnamed='1' visible='1'}";
    my $treeWidget     = waitForObject($treeWidgetName);
    my $root           = $treeWidget->invisibleRootItem();
    checkAnItem( -1, $root, $root );
}
