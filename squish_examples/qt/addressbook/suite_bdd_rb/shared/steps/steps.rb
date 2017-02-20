# encoding: UTF-8
require 'squish'
include Squish

Given("addressbook application is running") do |context|
  startApplication("addressbook")
  waitFor("Squish::Object.exists(':Address Book_MainWindow')", 20000)
  Test.compare(findObject(":Address Book_MainWindow").enabled, true)
end

When("I create a new addressbook") do |context|
  clickButton(waitForObject(":Address Book.New_QToolButton"))
end

Then("addressbook should be empty") do |context|
  waitFor("Squish::Object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000)
  Test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, 0)
end

When("I add a new person '|word|','|word|','|any|','|integer|' to address book") do |context, forename, surname, email, phone|
  clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"))
  type(waitForObject(":Forename:_LineEdit"), forename)
  type(waitForObject(":Surname:_LineEdit"), surname)
  type(waitForObject(":Email:_LineEdit"), email)
  type(waitForObject(":Phone:_LineEdit"), phone)
  clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
  context.userData = Hash.new
  context.userData[:forename] = forename
  context.userData[:surname] = surname    
end

Then("'|integer|' entries should be present") do |context, num|
  waitFor("Squish::Object.exists(':Address Book - Unnamed.File_QTableWidget')", 20000)
  Test.compare(findObject(":Address Book - Unnamed.File_QTableWidget").rowCount, num)
end

When("I add new persons to address book") do |context|
  table = context.table
  
  # Drop initial row with column headers
  table.shift
  
  for forename, surname, email, phone in table do
    clickButton(waitForObject(":Address Book - Unnamed.Add_QToolButton"))
    type(waitForObject(":Forename:_LineEdit"), forename)
    type(waitForObject(":Surname:_LineEdit"), surname)
    type(waitForObject(":Email:_LineEdit"), email)
    type(waitForObject(":Phone:_LineEdit"), phone)
    clickButton(waitForObject(":Address Book - Add.OK_QPushButton"))
  end
end

Then("previously entered forename and surname shall be at the top") do |context|
  Test.compare(waitForObject(":File.0_0_QModelIndex").text, context.userData[:forename], "forename?")
  Test.compare(waitForObject(":File.0_1_QModelIndex").text, context.userData[:surname], "surname?")
end



