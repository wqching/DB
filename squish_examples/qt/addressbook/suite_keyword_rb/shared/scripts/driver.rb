# encoding: UTF-8
require 'squish'

include Squish

def drive(datafile)
  require findFile("scripts", "actions.rb")
  Test.log("Drive: '#{datafile}'")
  TestData.dataset(datafile).each_with_index do
    |record, row|
    command = TestData.field(record, "Keyword") + "("
    comma = ""
    for i in 1...5
      arg = TestData.field(record, "Argument #{i}")
      if arg and arg != ""
        command += "#{comma}'#{arg}'"
        comma = ", "
      else
        break
      end
    end
    command += ")"
    Test.log("Execute: #{command}")
    eval command
  end
end
