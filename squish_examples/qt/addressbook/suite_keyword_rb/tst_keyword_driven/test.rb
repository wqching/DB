# encoding: UTF-8
require 'squish'
include Squish

def main
  require findFile("scripts", "driver.rb")
  drive("keywords.tsv")
end
