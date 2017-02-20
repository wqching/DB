# encoding: UTF-8
require 'squish'
include Squish

def main
  startApplication("csvtable")
  require findFile("scripts", "common.rb")
  doFileOpen("suite_py/shared/testdata/before.csv")
  tableWidget = waitForObject("{type='QTableWidget' " +
    "unnamed='1' visible='1'}")
  compareTableWithDataFile(tableWidget, "before.csv")
end
