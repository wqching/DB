Given("addressbook application is running", function(context) {
    startApplication("addressbook");
    waitFor("object.exists(':Address Book_MainWindow')", 20000);
    test.compare(findObject(":Address Book_MainWindow").enabled, true);
    });
    
When("I create a new addressbook", function(context) {
        clickButton(waitForObject(":Address Book.New_QToolButton"));
    });

Then("addressbook should be empty", function(context) {
        waitFor("object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000);
        test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, 0);
    });

When("I add a new person '|word|','|word|','|any|','|integer|' to address book",
    function (context, forename, surname, email, phone){
        clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"));
        type(waitForObject(":Forename:_LineEdit"), forename);
        type(waitForObject(":Surname:_LineEdit"), surname);
        type(waitForObject(":Email:_LineEdit"), email);
        type(waitForObject(":Phone:_LineEdit"), phone);
        clickButton(waitForObject(":Address Book - Add.OK_QPushButton"));
        context.userData["forename"] = forename;
        context.userData["surname"] = surname; 
});

Then("'|integer|' entries should be present", function(context, rowCount) {
    waitFor("object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000);
    test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, rowCount);
});

When("I add new persons to address book", function(context) {
    var table = context.table;

    // Drop initial row with column headers
    for (var i = 1; i < table.length; ++i) {
      var forename = table[i][0];
      var surname = table[i][1];
      var email = table[i][2];
      var phone = table[i][2];
      clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"))
      type(waitForObject(":Forename:_LineEdit"), forename)
      type(waitForObject(":Surname:_LineEdit"), surname)
      type(waitForObject(":Email:_LineEdit"), email)
      type(waitForObject(":Phone:_LineEdit"), phone)
      clickButton(waitForObject(":Address Book - Add.OK_QPushButton")) 
    }
});

Then("previously entered forename and surname shall be at the top",function(context){
    test.compare(waitForObject(":File.0_0_QModelIndex").text,context.userData["forename"], "forname?");
    test.compare(waitForObject(":File.0_1_QModelIndex").text,context.userData["surname"], "surname?");
});
