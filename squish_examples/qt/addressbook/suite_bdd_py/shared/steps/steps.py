# -*- coding: utf-8 -*-
import __builtin__
 
@Given("addressbook application is running")
def step(context):
    startApplication("addressbook");
    waitFor("object.exists(':Address Book_MainWindow')", 20000)
    test.compare(findObject(":Address Book_MainWindow").enabled, True)
     
@Step("I create a new addressbook")
def step(context):
    clickButton(waitForObject(":Address Book.New_QToolButton"))

@Then("addressbook should be empty")
def step(context):
    waitFor("object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000)
    test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, 0)
    
@When("I add a new person '|word|','|word|','|any|','|integer|' to address book")
def step(context, forename, surname, email, phone):
    clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"))
    type(waitForObject(":Forename:_LineEdit"), forename)
    type(waitForObject(":Surname:_LineEdit"), surname)
    type(waitForObject(":Email:_LineEdit"), email)
    type(waitForObject(":Phone:_LineEdit"), phone)
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
    context.userData = {}
    context.userData['forename'] = forename
    context.userData['surname'] = surname  

@Step("'|integer|' entries should be present")
def step(context, num):
    snooze(2);
    waitFor("object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000)
    test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, num)  

@Step("I add new persons to address book")
def step(context):
    table = context.table
    # Drop initial row with column headers
    table.pop(0)
    for (forname, surname, email, phone) in table:
        test.log("Adding entry: "+forname+","+surname+","+email+","+phone);
        clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"))
        type(waitForObject(":Forename:_LineEdit"), forname)
        type(waitForObject(":Surname:_LineEdit"), surname)
        type(waitForObject(":Email:_LineEdit"), email)
        type(waitForObject(":Phone:_LineEdit"), phone)
        clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))        

@Then("previously entered forename and surname shall be at the top")
def step(context):
    test.compare(waitForObject(":File.0_0_QModelIndex").text,context.userData['forename']);
    test.compare(waitForObject(":File.0_1_QModelIndex").text,context.userData['surname']);    
