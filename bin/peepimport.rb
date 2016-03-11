#!/usr/bin/env ruby
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'FileUtils'
require 'logger'
require 'peeptools/volume_finder'
require 'peeptools/importer'

CONFIG = {
  :volume_matcher => /peeppro/i,
  # :volume_matcher => /peep/i,
  :subfolder => File.join('DCIM','100GOPRO'),
  # :subfolder => 'Peepshow-Generale/Data01/cam1',
  :file_pattern => '*.MP4',
  :number_name_separator => '--',
  # :import_folder => './_IMPORT',
  # :organised_folder => './ORGANISE',
  # :take_names => [
  # ]
}


class Organiser
  attr_reader :options

  def initialize opts = {}
    @options = opts
  end

  def logger
    @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end

  def take_names
    options[:take_names] || CONFIG[:take_names] || []
  end

  def import_folder
    @import_folder ||= File.expand_path(options[:folder] || options[:folder] || File.join(Dir.pwd, '_IMPORT'))
  end

  def organised_folder
    @organise_folder ||= File.expand_path(options[:folder] || options[:folder] || File.join(Dir.pwd, 'ORGANISED'))
  end

  def take_folders
    if File.directory?(organised_folder)
      folders = Dir.glob(File.join(organised_folder, '*')).select{|f| File.directory?(f)}

      if non_empty_folder = folders.find{|f| Dir.glob(File.join(f, '*')).length > 0}
        logger.error "Take folder not empty: #{non_empty_folder}"
        return []
      end

      return folders
    end

    if take_names.length < 1
      logger.warn "Organiser didn't have any take names to work with"
      return []
    end

    logger.info "Creating folder for organised takes..."
    Dir.mkdir(organised_folder)

    take_names.each do |name|
      logger.info "Creating take folder #{name}"
      Dir.mkdir(File.join(organised_folder, name))
    end

    return take_folders
  end

  def cam_folders
    @cam_folders ||= (Dir.glob(File.join(import_folder, '*'))).sort
  end

  def execute
    take_folders.each_with_index do |take_folder, idx|
      logger.info "Populating take folder: #{take_folder}"
      logger.info "Cam fs: #{cam_folders.inspect}"
      cam_folders.each_with_index do |cam_folder, idx|
        cam_no_part = (File.basename(cam_folder).match(/(\d+)$/) || [])[1] || (File.basename(cam_folder).match(/(\d+)/) || [])[1] || "IDX#{idx}"
        cam_file = Dir.glob(File.join(cam_folder, '*')).sort{|a,b| a.downcase <=> b.downcase}.first
        dest_name = "cam#{cam_no_part}#{CONFIG[:number_name_separator]}#{File.basename(cam_file)}"
        dest_path = File.join(take_folder, dest_name)
        logger.info "Taking file from cam folder #{File.basename(cam_folder)} as #{dest_name}"
        File.rename(cam_file, dest_path)
      end
    end
  end
end

class Cleaner
  attr_reader :options

  def initialize opts = {}
    @options = opts
  end

  def logger
    @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end

  def organised_folder
    @organise_folder ||= File.expand_path(options[:folder] || options[:folder] || File.join(Dir.pwd, 'ORGANISED'))
  end

  def take_folders
    @take_folders ||= (Dir.glob(File.join(organised_folder, '*')))
  end

  def clean
    take_folders.each do |take_folder|
      logger.info "Cleaning take folder: #{take_folder}"
      files = Dir.glob(File.join(take_folder, '*'))

      files.each do |file|
        fname = File.basename(file)
        if (parts = fname.split(CONFIG[:number_name_separator])).length > 1
          to = File.join(take_folder, "#{parts[0]}#{File.extname(fname)}")
          logger.info "Moving file from #{fname} to #{to}"
          FileUtils.mv(file, to)
        else
          logger.warn "#{fname} doesn't have file separator '#{CONFIG[:number_name_separator]}'"
        end
      end
    end
  end

  def unindex
    take_folders.each do |f|
      if File.basename(f) =~ /^\d{2}-/
        from = f
        to = File.join(organised_folder, File.basename(f).gsub(/^\d{2}-/, ''))
        cmd = "mv #{from} #{to}"
        logger.info "Exec: #{cmd}"
        `#{cmd}`
      end
    end
  end
end

class Checker
  attr_reader :options

  def initialize opts = {}
    @options = opts
  end

  def logger
    @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end

  def import_folder
    File.expand_path(options[:folder] || CONFIG[:import_folder] || File.join(Dir.pwd, '_IMPORT'))
  end

  def cam_folders
    Dir.glob(File.join(import_folder, '*'))
  end

  def check_hashes

  end

  def check_amounts
    data = cam_folders.inject({}) do |result, folder|
      files = Dir.glob(File.join(folder, '*.MP4'))
      logger.info "#{folder}: #{files.length} files"
      result.merge(folder => files)
    end
  end
end

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
    when 'volume'
      folder = Peep::VolumeFinder.new(:logger => logger).folder
      if folder
        logger.info "Found GoPro folder: #{folder.full_path}"
      else
        logger.info "No GoPro folders found"
      end

    when 'volumes'
      folders = Peep::VolumeFinder.new(:logger => logger).folders
      logger.info "Number of GoPro volumes found: #{folders.length}"
      folders.each{|f| logger.info " - #{f.full_path}"}

    when 'import'
      folders = Peep::VolumeFinder.new(:logger => logger).folders

      if folders.empty?
        logger.info 'No volumes found'
        return
      end

      folders.each do |folder|
        logger.info "Importing volume #{folder.full_path} with GoPro number: #{folder.number}"
        Peep::Importer.new(:folder => folder, :logger => logger).import
        logger.info 'done.'
      end

    when 'check'
      Checker.new(:logger => logger).check_hashes

    when 'amounts'

      # Checker.new(:logger => logger).check_amounts
      Peep::Importer.new(:logger => logger).import_folder.folders.each do |f|
        logger.info "#{f.name}: #{f.files(:ext => 'MP4').length} mp4 file(s)"
      end

    when 'sizes'
      Checker.new(:logger => logger).check_size
    when 'organise'
      Organiser.new(:logger => logger).execute
    when 'clean'
      Cleaner.new(:logger => logger).clean
    when 'unindex'
      Cleaner.new(:logger => logger).unindex
    else
      puts "USAGE: #{File.basename(__FILE__)} volume|import|check|amounts|sizes|organise|clean|unindex"
    end
  end
end

Runner.new(:argv => ARGV).run

# puts "__FILE__: #{__FILE__.inspect}"
# puts "ARGV: #{ARGV.inspect}"
