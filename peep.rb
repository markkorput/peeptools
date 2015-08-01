#!/usr/bin/env ruby
require 'FileUtils'
require 'logger'
require './peep_helper'

class Runner
  attr_reader :options

  def initialize opts = {}
    @options = opts
  end

  def logger
    @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end

  def argv
    options[:argv] || []
  end

  def run
    case argv[0]
    when 'empty'
      puts "Layer folders without videos: \n"+Peeper.new.layer_folders.select{|f| f.vids.empty?}.map{|f| File.basename(f.folder) + "\t" + f.folder}.join("\n")
    when 'linkvids'
      Peeper.new.ln_stitches
    when 'kavaall'
      Peeper.new.kavaall
    else
      puts 'USAGE: peep.rb empty'
    end
  end
end

Runner.new(:argv => ARGV).run
