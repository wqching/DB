# encoding: UTF-8
require 'squish'

include Squish

def natify(path)
  return path.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
end

def main
  startApplication("csvtable")
  # Load data from an external file
  infile = natify(findFile("testdata", "before.csv"))
  Test.log("Reading %s" % infile)
  lines = []
  File.open(infile, "r:utf-8") do |file|
    file.each {|line| lines << line}
  end
  Test.verify(lines.length == 13)

  # Save data to an external file
  outfile = natify(File.join(Dir.getwd, File.basename(infile) + ".tmp"))
  Test.log("Writing %s" % outfile)
  File.open(outfile, "w:utf-8") do |file|
    lines.each {|line| file.write(line)}
    #file.write("X") # Uncomment this to make the files different
  end

  # Compare two external files
  diff = File::ALT_SEPARATOR == "\\" ? "fc" : "diff"
  `#{diff} "#{infile}" "#{outfile}"`
  Test.verify($?.exitstatus == 0, "infile and outfile equal according to #{diff}")

  # Delete external file
  File.delete(outfile)

  # Check the existence of external files
  Test.verify(File.exist?(infile), "infile correctly present")
  Test.verify(!File.exist?(outfile), "outfile sucessfully deleted")

  # Access environment variables
  ENV.each {|key, value| Test.log("#{key} = #{value}") }
end
