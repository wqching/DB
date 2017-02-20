sub checkAnItem {
    my ( $indent, $index, $treeView, $model, $selectionModel ) = @_;
    if ( $indent > -1 && $index->isValid() ) {
        my $text       = $model->data($index)->toString();
        my $checked    = "";
        my $selected   = "";
        my $checkState = $model->data( $index, Qt::CheckStateRole )->toInt();
        if ( $checkState == Qt::Checked ) {
            $checked = " +checked";
        }
        if ( $selectionModel->isSelected($index) ) {
            $selected = " +selected";
        }
        test::log(
            "|" . " " x $indent . "'" . $text . "'" . $checked . $selected );
    }
    else {
        $indent = -4;
    }

    # Only show visible child items
    if ( $index->isValid() && $treeView->isExpanded($index)
        || !$index->isValid() )
    {
        for ( my $row = 0 ; $row < $model->rowCount($index) ; ++$row )
        {
            checkAnItem(
                $indent + 4,
                $model->index( $row, 0, $index ),
                $treeView, $model, $selectionModel
            );
        }
    }
}

sub main {
    startApplication("itemviews");
    my $treeViewName   = "{type='QTreeView' unnamed='1' visible='1'}";
    my $treeView       = waitForObject($treeViewName);
    my $model          = $treeView->model();
    my $selectionModel = $treeView->selectionModel();
    checkAnItem( -1, new QModelIndex(), $treeView, $model, $selectionModel );
}
