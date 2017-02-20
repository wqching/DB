sub main
{
    startApplication("itemviews");
    my $listWidgetName = "{type='QListWidget' unnamed='1' visible='1'}";
    my $listWidget     = waitForObject($listWidgetName);
    for ( my $row = 0 ; $row < $listWidget->count ; ++$row ) {
        my $item     = $listWidget->item($row);
        my $checked  = "";
        my $selected = "";
        if ( $item->checkState() == Qt::Checked ) {
            $checked = " +checked";
        }
        if ( $item->isSelected() ) {
            $selected = " +selected";
        }
        test::log( "($row) '" . $item->text() . "'$checked$selected" );
    }
}
