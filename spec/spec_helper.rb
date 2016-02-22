# loads and runs all tests for the rxsd project
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the AGPLv3+ http://www.gnu.org/licenses/agpl.txt

require 'rspec'
require 'logger'

begin
  require 'byebug'
rescue LoadError => e
  Logger.new(STDOUT).warn("Could not load byebug, continuing without it")
end

def spec_logger
	@spec_logger_cache ||= Logger.new(STDOUT).tap do |logr|
		logr.level = Logger::WARN
	end
end

$: << File.expand_path('../lib', File.dirname(__FILE__))

# monkey patch some stubbing logic
def stubstub(subject)
    if subject.is_a?(Peep::GoproFolder)
        expect(Dir).to receive(:glob).with('/Volumes/*').and_return(["/Volumes/#{subject.name}"])
        expect(File).to receive(:directory?).with("/Volumes/#{subject.name}").and_return(true)
        expect(File).to receive(:exist?).with("/Volumes/#{subject.name}/DCIM/100GOPRO").and_return(true)
        expect(File).to receive(:exist?).with("/Volumes/#{subject.name}/MISC").and_return(true) # this just surpresses the logger warning of a missing MISC folder
    end
end
