sub main {
    startApplication("csvtable");
    source( findFile( "scripts", "common.pl" ) );

    # Populate the table with some data
    my $tableWidget = waitForObject("{type='QTableWidget' " .
                                    "unnamed='1' visible='1'}");
    $tableWidget->setRowCount(4);
    $tableWidget->setColumnCount(3);
    my $count = 0;
    for (my $row = 0; $row < $tableWidget->rowCount; ++$row) {
        for (my $column = 0; $column < $tableWidget->columnCount; ++$column)
        {
            my $tableItem = new QTableWidgetItem("Item $count");
            ++$count;
            if ($column == 2) {
                $tableItem->setCheckState(Qt::Unchecked);
                if ($row == 1 || $row == 3) {
                    $tableItem->setCheckState(Qt::Checked);
                }
            }
            $tableWidget->setItem($row, $column, $tableItem);
            if ($count == 6 || $count == 10) {
                $tableItem->setSelected(1);
            }
        }
    }
    $tableWidget->setRowHidden(2, 1);

    # Iterate over all the table's items and print their text and
    # state to the log
    $tableWidget =
      waitForObject( "{type='QTableWidget' " . "unnamed='1' visible='1'}" );
    for ( my $row = 0 ; $row < $tableWidget->rowCount ; ++$row ) {
        if ( $tableWidget->isRowHidden($row) ) {
            test::log("Skipping hidden row $row");
            next;
        }
        for ( my $column = 0 ; $column < $tableWidget->columnCount ; ++$column )
        {
            my $tableItem = $tableWidget->item( $row, $column );
            my $text      = $tableItem->text();
            my $checked   = "";
            my $selected  = "";
            if ( $tableItem->checkState() == Qt::Checked ) {
                $checked = " +checked";
            }
            if ( $tableItem->isSelected() ) {
                $selected = " +selected";
            }
            test::log("($row, $column) '$text'$checked$selected");
        }
    }
}
