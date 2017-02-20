sub main {
    startApplication("itemviews");
    my $tableViewName  = "{type='QTableView' unnamed='1' visible='1'}";
    my $tableView      = waitForObject($tableViewName);
    my $model          = $tableView->model();
    my $selectionModel = $tableView->selectionModel();
    for ( my $row = 0 ; $row < $model->rowCount() ; ++$row ) {
        for ( my $column = 0 ; $column < $model->columnCount() ; ++$column ) {
            my $index    = $model->index( $row, $column );
            my $text     = $model->data($index)->toString();
            my $checked  = "";
            my $selected = "";
            my $checkState =
              $model->data( $index, Qt::CheckStateRole )->toInt();
            if ( $checkState == Qt::Checked ) {
                $checked = " +checked";
            }
            if ( $selectionModel->isSelected($index) ) {
                $selected = " +selected";
            }
            test::log("($row, $column) '$text'$checked$selected");
        }
    }
}
