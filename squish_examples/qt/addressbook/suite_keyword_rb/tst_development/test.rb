# encoding: UTF-8
require 'squish'
include Squish

def main
  require findFile("scripts", "actions.rb")
  startApplication("addressbook")
  chooseMenuItem("File", "New")
  Test.compare(getRowCount(), 0)
  addAddress("Red", "Herring", "red.herring@froglogic.com",
  "555 123 4567")
  addAddress("Blue", "Cod", "blue.cod@froglogic.com", "555 098 7654")
  addAddress("Green", "Pike", "green.pike@froglogic.com", "555 675 8493")
  Test.compare(getRowCount(), 3)
  removeAddress("green.pike@froglogic.com")
  removeAddress("blue.cod@froglogic.com")
  removeAddress("red.herring@froglogic.com")
  Test.compare(getRowCount(), 0)
  chooseMenuItem("File", "Quit")
  clickButton(waitForObject(":Address Book.No_QPushButton"))
end
