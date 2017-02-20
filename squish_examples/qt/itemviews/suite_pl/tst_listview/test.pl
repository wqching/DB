sub main {
    startApplication("itemviews");
    my $listViewName   = "{type='QListView' unnamed='1' visible='1'}";
    my $listView       = waitForObject($listViewName);
    my $model          = $listView->model();
    my $selectionModel = $listView->selectionModel();
    for ( my $row = 0 ; $row < $model->rowCount() ; ++$row ) {
        my $index      = $model->index( $row, 0 );
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
        test::log("($row) '$text'$checked$selected");
    }
}
